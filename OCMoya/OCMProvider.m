//
//  OCMProvider.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProvider.h"

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
    
    return self;
}


@end

