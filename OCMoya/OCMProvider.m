//
//  OCMProvider.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProvider.h"
#import "OCMProvider+defaultProvider.h"
#import "OCMProvider+stub.h"

@implementation OCMProvider

- (instancetype)initWithEndpointClosure:(EndpointClosure)enpointClosure
                         requestClosure:(RequestClosure)requestClosure
                            stubClosure:(StubClosure)stubClosure
                                manager:(OCMHTTPSessionManager *)manager
                                plugins:(NSArray<id<OCMPlugin>> *)plugins{
    
    if (self = [super init]) {
        _endpointClosure = enpointClosure;
        _requestClosure = requestClosure;
        _stubClosure = stubClosure;
        _Manager = manager;
        _plugins = plugins;
    }
    
    if (!_endpointClosure) {
        _endpointClosure = OCMProvider.defaultEndpointMappingClosure;
    }
    
    if (!_requestClosure) {
        _requestClosure = OCMProvider.defaultRequestMappingClosure;
    }
    
    if (!_stubClosure) {
        _stubClosure = [OCMProvider neverStub];
    }
    
    if (_plugins) {
        _plugins = @[];
    }
    
    
    
    return self;
}

- (OCMEndpoint *)endpoint:(id<OCMTargetType>)target{
    if (self.endpointClosure) {
        return self.endpointClosure(target);
    }
    
    return nil;
}

- (id<OCMCancellable>)request:(id<OCMTargetType>)target completion:(Completion)completion{
    return nil;
}



@end

