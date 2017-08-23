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

@property (nonatomic,copy) parameterType *urlParameters;

@property (nonatomic,copy) parameterType *bodyParameters;

@property (nonatomic,assign) OCMParameterEncoding parameterEncoding;

@property (nonatomic,copy) httpHeaderType *httpHeaderFields;

@property (nonatomic,copy) NSArray<OCMUploadFormProvider *> *uploadTasks;

@end

@implementation OCMEndpoint


- (instancetype)initWithURL:(nonnull NSString *)url
      sampleResponseClosure:(nullable OCMEndpointSampleResponseClosure)closure
                     method:(OCMMethod)method
              urlParameters:(nullable NSDictionary<NSString *,id> *)urlParameters
              bodyParameters:(nullable NSDictionary<NSString *,id> *)bodyParameters
          parameterEncoding:(OCMParameterEncoding)encoding
           httpHeaderFields:(nullable NSDictionary<NSString *,NSString *> *)httpHeaderFields{
    
    if (!url) {
        NSAssert(url != nil, @"input a invaild url");
        return nil;
    }
    
    _url = url;
    _method = method;
    _sampleResponseClosure = closure;
    _urlParameters = urlParameters;
    _bodyParameters = bodyParameters;
    _parameterEncoding = encoding;
    _httpHeaderFields = httpHeaderFields;
    
    return self;

}



- (OCMEndpoint *)addingHttpHeaderFields:(httpHeaderType *)httpHeaderFields{
    
    return [self addingURLParameters:self.urlParameters
                      bodyParameters:self.bodyParameters
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

- (nonnull OCMEndpoint *)addingURLParameters:(nullable parameterType *)urlParameters
                              bodyParameters:(nullable parameterType *)bodyParamters
                            httpHeaderFields:(nullable httpHeaderType *)httpHeaders {
    
    parameterType *newURLParameters = [self addWithParameters:urlParameters orignalParameters:self.urlParameters];
    parameterType *newbodyParamters = [self addWithParameters:bodyParamters orignalParameters:self.bodyParameters];
    
    httpHeaderType *newHttpHeaderFields = [self addWithHttpHeaderFields:httpHeaders];
    
    self.urlParameters = newURLParameters;
    self.bodyParameters = newbodyParamters;
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
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:self.url];
    
    if (!url) {
        NSAssert(url, @"Input a invaild url,please check it");
        return nil;
    }
    
    OCMHTTPRequestSerializer *URLEncodingserializer = [OCMRequestSerializer SerializerWithType:OCMParameterEncodingURL];
    URLEncodingserializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE",@"POST", nil];//avoid some POST have url parameter
    
    NSString *HTTPMethod = [OCMoyaConfig getHTTPOCMMethod:self.method];
    
    //url encoding
    NSError *error;
    NSMutableURLRequest *request = [URLEncodingserializer requestWithMethod:HTTPMethod URLString:self.url parameters:self.urlParameters error:&error];
    
    //encoding url parameter meet error
    if (error) {
        NSLog(@"encoding the reqeust' url meet error the reqeut is %@ /n reason is %@",request,error);
        return request;
    }


    
    //body encoding
    
    if (self.method == OCMMethodPOST) {// it only work when POST
        
    
         OCMHTTPRequestSerializer *requestserialization = [OCMRequestSerializer SerializerWithType:self.parameterEncoding];
        
        NSError *bodyEncodingError;
        if (self.parameterEncoding == OCMParameterEncodingMultiPartForm) {
            NSMutableURLRequest *mutipartReqeust = [requestserialization multipartFormRequestWithMethod:HTTPMethod
                                    URLString:request.URL.absoluteString
                                    parameters:self.bodyParameters
                    constructingBodyWithBlock:^(id<OCMMultipartFormData>  _Nonnull formData) {
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
                        
                    } error:&bodyEncodingError];
            
            request = mutipartReqeust;
            
        }else{
        
            request = [[requestserialization requestBySerializingRequest:[request copy] withParameters:self.bodyParameters error:&bodyEncodingError] mutableCopy];
            
            //encoding body meet error
            if (bodyEncodingError) {
                NSLog(@"Convert the reqeust's body meet error the reqeut is %@ /n reason is %@",request,bodyEncodingError);
                return request;
            }
        }
       
    }
    
    
    [self.httpHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    NSURLRequest *newRequest = [request copy];
    return newRequest;
}

- (NSURLRequest *)adapt:(NSURLRequest *)request{
    return self.urlRequest;
}

@end
