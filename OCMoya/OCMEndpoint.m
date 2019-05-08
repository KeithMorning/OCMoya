//
//  OCMEndPoint.m
//  OCMoya
//
//  Created by KeithXi on 24/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#import "OCMEndpoint.h"
#import "OCMoyaConfig.h"
#import "OCMRequestSerializer.h"
#import "OCMDefination.h"

@implementation OCMEndpointSampleResponse


- (instancetype)initWithStatusCode:(NSInteger)statusCode data:(NSData *)data error:(NSError *)error{
    
    if (self = [super init]) {
        _statusCode = statusCode;
        _data = data;
        _error = error;
    }
    
    return self;

}

@end


typedef NSMutableDictionary<NSString *,id> _M_parameterType;
typedef NSMutableDictionary<NSString *,NSString *> _M_httpHeaderType;

@interface OCMEndpoint()

@property (nonatomic,copy) NSString *url;

@property (nonatomic,assign) OCMMethod method;

@property (nonatomic,copy) OCMEndpointSampleResponseClosure sampleResponseClosure;

@property (nonatomic,copy) parameterType *parameters;

@property (nonatomic,assign) OCMParameterEncoding parameterEncoding;

@property (nonatomic,copy) httpHeaderType *httpHeaderFields;

@property (nonatomic,copy) NSArray<OCMUploadFormProvider *> *uploadTasks;

@end

@implementation OCMEndpoint


- (instancetype)initWithURL:(nonnull NSString *)url
      sampleResponseClosure:(nullable OCMEndpointSampleResponseClosure)closure
                     method:(OCMMethod)method
                 parameters:(nullable NSDictionary<NSString *,id> *)parameters
          parameterEncoding:(OCMParameterEncoding)encoding
           httpHeaderFields:(nullable NSDictionary<NSString *,NSString *> *)httpHeaderFields{
    
    if (!url) {
        NSAssert(url != nil, @"input a invaild url");
        return nil;
    }
    
    self.url = url;
    self.method = method;
    self.sampleResponseClosure = closure;
    self.parameters = parameters;
    self.parameterEncoding = encoding;
    self.httpHeaderFields = httpHeaderFields;
    
    return self;

}



- (OCMEndpoint *)addingHttpHeaderFields:(httpHeaderType *)httpHeaderFields{
    
    return [self addingParameters:self.parameters
                 httpHeaderFields:httpHeaderFields];

}

- (OCMEndpoint *)addingUpload:(OCMoyaTargetUploadMultipartTask *)targetTask{
    
    if(!targetTask.providers || !targetTask.providers.count){
        
        return self;
    }
    
    if(!self.uploadTasks){ self.uploadTasks = @[]; }
    NSMutableArray *temptasks = [self.uploadTasks mutableCopy];
    [temptasks addObjectsFromArray:targetTask.providers];
    self.uploadTasks = [temptasks copy];
    return self;
}

- (nonnull OCMEndpoint *)addingParameters:(nullable parameterType *)parameters
                         httpHeaderFields:(nullable httpHeaderType *)httpHeaders; {
    
    parameterType *newParamters = [self addWithParameters:parameters orignalParameters:self.parameters];
    
    httpHeaderType *newHttpHeaderFields = [self addWithHttpHeaderFields:httpHeaders];

    self.parameters = newParamters;
    self.httpHeaderFields = newHttpHeaderFields;
    
    return self;
}


- (parameterType *)addWithParameters:(parameterType *)parameters orignalParameters:(parameterType *)orginalParameters{
    
    if (parameters == orginalParameters
        || !parameters
        || parameters.allKeys.count == 0) {
        
        return orginalParameters;
    }
    
    if (!orginalParameters) {
        orginalParameters = @{};
    }
    
    __block _M_parameterType *newParameters = [[NSMutableDictionary alloc] initWithDictionary:orginalParameters];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [newParameters setObject:obj forKey:key];
    }];
    
    return [newParameters copy];
    
   }

- (httpHeaderType *)addWithHttpHeaderFields:(httpHeaderType *)httpHeaderFields{
    
    if (self.httpHeaderFields == httpHeaderFields
        || !httpHeaderFields
        || httpHeaderFields.allKeys.count==0) {
        return self.httpHeaderFields;
    }
    
    if (!self.httpHeaderFields) {
        self.httpHeaderFields = @{};
    }
    
    __block _M_httpHeaderType *newHttpHeaderFields = [[NSMutableDictionary alloc] initWithDictionary:self.httpHeaderFields];
    
    [httpHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [newHttpHeaderFields setObject:obj forKey:key];
    }];
    
    return [newHttpHeaderFields copy];
}



- (NSURLRequest *)urlRequest{
    if (!self.url) {
        NSAssert(NO,@"Input a invaild url,please check it");
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:self.url];
    
    if (!url) {
        NSAssert(url, @"Input a invaild url,please check it");
        return nil;
    }
    
    NSString *HTTPMethod = [OCMoyaConfig getHTTPOCMMethod:self.method];
    
    NSError *error;
    NSMutableURLRequest * request;
    
     OCMHTTPRequestSerializer *requestserialization = [OCMRequestSerializer SerializerWithType:self.parameterEncoding];
    
    if (self.parameterEncoding == OCMParameterEncodingMultiPartForm){
        NSAssert(self.method == OCMMethodPOST, @"multipart form must use post http method");
        
        
        NSMutableURLRequest *mutipartReqeust = [requestserialization multipartFormRequestWithMethod:HTTPMethod URLString:self.url parameters:self.parameters constructingBodyWithBlock:^(id<OCMMultipartFormData>  _Nonnull formData) {
            for (OCMUploadFormProvider *provider in self.uploadTasks) {
                if ([provider isKindOfClass:[OCMUploadFormDataProvider class]]) {
                    OCMUploadFormDataProvider *dataProvider = (OCMUploadFormDataProvider *)provider;
                    [formData appendPartWithFileData:dataProvider.data name:dataProvider.name fileName:dataProvider.fileName mimeType:dataProvider.mimeType];
                }else if ([provider isKindOfClass:[OCMUploadFormFileProvider class]]){
                    
                    OCMUploadFormFileProvider *fileProvider = (OCMUploadFormFileProvider *)provider;
                    [formData appendPartWithFileURL:fileProvider.file name:fileProvider.name fileName:fileProvider.fileName mimeType:fileProvider.mimeType error:nil];
                }else if([provider isKindOfClass:[OCMUploadFormStreamProvider class]]){
                    
                    OCMUploadFormStreamProvider *streamProvider = (OCMUploadFormStreamProvider *)provider;
                    [formData appendPartWithInputStream:streamProvider.inputStream name:streamProvider.name fileName:streamProvider.fileName length:streamProvider.offset mimeType:streamProvider.mimeType];
                }else{
                    
                    NSLog(@"unspport upload provider");
                }
                
            }
            
        } error:&error];
        
        request = mutipartReqeust;
        
    }else{ //
    
        request = [requestserialization requestWithMethod:HTTPMethod URLString:self.url parameters:self.parameters error:&error];
        
    }
    
    if (error) {
        NSLog(@"encoding the reqeust  meet error the reqeut is %@ /n reason is %@",request,error);
        return request;
    }
    
   
    
    
    [self.httpHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    NSURLRequest *newRequest = [request copy];
    return newRequest;
}


@end
