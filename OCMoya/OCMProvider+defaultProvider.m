//
//  OCMProvider+default.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProvider+defaultProvider.h"
#import "OCMoyaError.h"
#import "OCMEndpoint.h"
#import "OCMCommonURLResponseSerialization.h"

@implementation OCMProvider (defaultProvider)

+ (OCMEndpoint *)defaultEndpointMapping:(id<OCMTargetType>)target{
    
    NSString *urlstr = [target.baseURL URLByAppendingPathComponent:target.path].absoluteString;
    
    return [[OCMEndpoint alloc] initWithURL:urlstr
                      sampleResponseClosure:^OCMEndpointSampleResponse *{
                          return [[OCMEndpointSampleResponse alloc] initWithStatusCode:200 data:target.sampleData error:nil];
                      }
                                     method:OCMMethodGET
                                 parameters:target.parameters
                          parameterEncoding:target.parameterEncoding
                           httpHeaderFields:nil];
}


+ (void)defaultRequestMapping:(OCMEndpoint *)endpoint closure:(RequestResultClosure)closure{
    
    NSURLRequest *request = endpoint.urlRequest;
    if (request) {
        OCMResult<NSURLRequest *,OCMoyaError *> *result = [[OCMResult alloc] initWithSuccess:request];
        
        closure(result);
        
    }else{
        
        OCMoyaError *error = [[OCMoyaError alloc] initWithError:nil errorType:OCMoyaErrorTypeRequestMapping response:nil];
        
        OCMResult<NSURLRequest *,OCMoyaError *> *result = [[OCMResult<NSURLRequest *,OCMoyaError *> alloc] initWithFailure:error];
        
        closure(result);
    }

}


+ (OCMHTTPSessionManager *)defaultHTTPManager{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    OCMHTTPSessionManager *manager = [[OCMHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [OCMCommonURLResponseSerialization serializer];
    return manager;

}

+ (EndpointClosure)defaultEndpointMappingClosure{
    
    EndpointClosure closure = ^OCMEndpoint*(id<OCMTargetType> target){
       return [OCMProvider defaultEndpointMapping:target];
    };
    
    return closure;
}

+ (RequestClosure)defaultRequestMappingClosure{
    
    RequestClosure closure = ^void(OCMEndpoint *endpoint, RequestResultClosure requestResultClosure){
        [OCMProvider defaultRequestMapping:endpoint closure:requestResultClosure];
    };
    
    return closure;
}


@end
