//
//  OCMEndPoint.m
//  OCMoya
//
//  Created by KeithXi on 24/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#import "OCMEndpoint.h"

@implementation OCMEndpointSampleResponse
@end


typedef NSDictionary<NSString *,id> parameterType;
typedef NSDictionary<NSString *,NSString *> httpHeaderType;

@interface OCMEndpoint()

@property (nonatomic,copy) NSString *url;

@property (nonatomic,assign) OCMMethod method;

@property (nonatomic,copy) OCMEndpointSampleResponseClosure sampleResponseClosure;

@property (nonatomic,copy) NSDictionary<NSString *,id> *parameters;

@property (nonatomic,assign) OCMParameterEncoding parameterEncoding;

@property (nonatomic,copy) NSDictionary<NSString *,NSString *> *httpHeaderFields;

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


- (OCMEndpoint *)addingNewParameter:(parameterType *)newparameter{

}

- (OCMEndpoint *)addingHttpHeaderFields:(httpHeaderType *)httpHeader{

}

- (OCMEndpoint *)addingNewParameter:(parameterType *)newparameter httpHeaderFields:(httpHeaderType *)httpHeader{

}


@end
