//
//  OCMEndPoint.m
//  OCMoya
//
//  Created by KeithXi on 24/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#import "OCMEndpoint.h"
#import "OCMoyaConfig.h"
#import "AFHTTPRequestSerializer+OCMSerializer.h"
#import "OCMDefination.h"

@implementation OCMEndpointSampleResponse
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

@end

@implementation OCMEndpoint


- (instancetype)initWithURL:(NSString *)url
      sampleResponseClosure:(OCMEndpointSampleResponseClosure)closure
                     method:(OCMMethod)method
                 parameters:(NSDictionary<NSString *,NSString *> *)parameters
          parameterEncoding:(OCMParameterEncoding)encoding
           httpHeaderFields:(NSDictionary<NSString *,NSString *> *)httpHeaderFields{
    
    if (!url) {
        NSAssert(url != nil, @"input a invaild url");
        return nil;
    }
    
    _url = url;
    _method = method;
    _sampleResponseClosure = closure;
    _parameters = parameters;
    _parameterEncoding = encoding;
    _httpHeaderFields = httpHeaderFields;
    
    return self;

}


- (OCMEndpoint *)addingParameter:(parameterType *)newparameter{
    return [self addingParameters:newparameter
                 httpHeaderFields:self.httpHeaderFields
                parameterEncoding:self.parameterEncoding];

}

- (OCMEndpoint *)addingHttpHeaderFields:(httpHeaderType *)httpHeaderFields{
    
    return [self addingParameters:self.parameters
                 httpHeaderFields:httpHeaderFields
                parameterEncoding:self.parameterEncoding];

}

- (OCMEndpoint *)addingParameters:(parameterType *)parameters httpHeaderFields:(httpHeaderType *)httpHeaders parameterEncoding:(OCMParameterEncoding)encoding{
    
    parameterType *newParameters = [self addWithParameters:parameters];
    httpHeaderType *newHttpHeaderFields = [self addWithHttpHeaderFields:httpHeaders];
    
    return [[OCMEndpoint alloc] initWithURL:self.url
                      sampleResponseClosure:self.sampleResponseClosure
                                     method:self.method
                                 parameters:newParameters
                          parameterEncoding:encoding
                           httpHeaderFields:newHttpHeaderFields];

}


- (parameterType *)addWithParameters:(parameterType *)parameters{
    
    if (self.parameters == parameters
        || !parameters
        || parameters.allKeys.count==0) {
        return self.parameters;
    }
    
    if (!self.parameters) {
        self.parameters = @{};
    }
    
   __block _M_parameterType *newParameters = [[NSMutableDictionary alloc] initWithDictionary:self.parameters];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [newParameters setObject:obj forKey:key];
    }];
    
    return [newParameters copy];
}

- (httpHeaderType *)addWithHttpHeaderFields:(httpHeaderType *)httpHeaderFields{
    
    if (self.httpHeaderFields == httpHeaderFields
        || !httpHeaderFields
        || httpHeaderFields.allKeys.count==0) {
        return self.parameters;
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
    
    id<OCMURLRequestSerialization> serializer = [[OCMHTTPRequestSerializer alloc] initWithType:self.parameterEncoding];
    NSError *error;
    NSURLRequest *newRequest = [serializer requestBySerializingRequest:request withParameters:self.parameters error:&error];
    
    if (error) {
        NSLog(@"Convert the reqeust error the reqeut is %@ /n reason is %@",request,error);
    }
    
    return newRequest;
}

@end
