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
    
    return [self addingParameters:self.urlParameters
                 httpHeaderFields:httpHeaderFields
                parameterEncoding:self.parameterEncoding];

}

- (OCMEndpoint *)addingParameters:(parameterType *)parameters
                 httpHeaderFields:(httpHeaderType *)httpHeaders
                parameterEncoding:(OCMParameterEncoding)encoding{
    
    parameterType *newParameters = [self addWithParameters:parameters parameterType:encoding];
    httpHeaderType *newHttpHeaderFields = [self addWithHttpHeaderFields:httpHeaders];
    
    
    switch (encoding) {
        case OCMParameterEncodingURL:
        {
            return [[OCMEndpoint alloc] initWithURL:self.url
                              sampleResponseClosure:self.sampleResponseClosure
                                             method:self.method
                                      urlParameters:newParameters
                                      bodyParameters:self.bodyParameters
                                  parameterEncoding:encoding
                                   httpHeaderFields:newHttpHeaderFields];
        }
            break;
            
        default:
            return [[OCMEndpoint alloc] initWithURL:self.url
                              sampleResponseClosure:self.sampleResponseClosure
                                             method:self.method
                                      urlParameters:self.urlParameters
                                      bodyParameters:newParameters
                                  parameterEncoding:encoding
                                   httpHeaderFields:newHttpHeaderFields];
            break;
    }
    


}


- (parameterType *)addWithParameters:(parameterType *)parameters parameterType:(OCMParameterEncoding)encodingType{
    
    switch (encodingType) {
        case OCMParameterEncodingURL:
        {
            if (self.urlParameters == parameters
                || !parameters
                || parameters.allKeys.count==0) {
                return self.urlParameters;
            }
            
            if (!self.urlParameters) {
                self.urlParameters = @{};
            }
            
            __block _M_parameterType *newParameters = [[NSMutableDictionary alloc] initWithDictionary:self.urlParameters];
            
            [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [newParameters setObject:obj forKey:key];
            }];
            
            return [newParameters copy];
        }
            break;
            
        default:
        {
            if (self.bodyParameters == parameters
                || !parameters
                || parameters.allKeys.count==0) {
                return self.bodyParameters;
            }
            
            if (!self.bodyParameters) {
                self.bodyParameters = @{};
            }
            
            __block _M_parameterType *newParameters = [[NSMutableDictionary alloc] initWithDictionary:self.bodyParameters];
            
            [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [newParameters setObject:obj forKey:key];
            }];
            
            return [newParameters copy];
        }
            
            
            break;
    }
    

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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = [OCMoyaConfig getHTTPOCMMethod:self.method];
    request.allHTTPHeaderFields = self.httpHeaderFields;
    
    OCMHTTPRequestSerializer *serializer = [OCMRequestSerializer SerializerWithType:OCMParameterEncodingURL];
    serializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE",@"POST", nil];//avoid some POST have url parameter
    
    
    //url encoding
    NSError *error;
    NSURLRequest *newRequest = [serializer requestBySerializingRequest:request withParameters:self.urlParameters error:&error];
    
    //encoding url parameter meet error
    if (error) {
        NSLog(@"encoding the reqeust' url meet error the reqeut is %@ /n reason is %@",request,error);
        return newRequest;
    }
    
    //body encoding
    if (self.method == OCMMethodPOST) {// it only work when POST
        
         OCMHTTPRequestSerializer *requestserialization = [OCMRequestSerializer SerializerWithType:self.parameterEncoding];
        
        NSError *bodyEncodingError;
        newRequest = [requestserialization requestBySerializingRequest:newRequest withParameters:self.bodyParameters error:&bodyEncodingError];
        
        //encoding body meet error
        if (bodyEncodingError) {
            NSLog(@"Convert the reqeust's body meet error the reqeut is %@ /n reason is %@",newRequest,bodyEncodingError);
            return newRequest;
        }
    }

    return newRequest;
}

- (NSURLRequest *)adapt:(NSURLRequest *)request{
    return self.urlRequest;
}

@end
