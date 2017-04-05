//
//  OCMProvider.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMEndpoint.h"
#import "OCMTargetType.h"
#import "OCMResult.h"
#import "OCMPlugin.h"
#import "OCMDefination.h"
#import "OCMHTTPSessionManager.h"

//the Target covert into a Endpoint block
typedef OCMEndpoint *(^EndpointClosure)(id<OCMTargetType>);

//custom your request here
typedef  OCMResult<NSURLRequest *,OCMoyaError *> *(^RequestResultClosure)(OCMResult<NSURLRequest *,OCMoyaError *> *result);

//Closure that resolves an `Endpoint` into `RequestResult`
typedef id(^RequestClosure)(OCMEndpoint *endpoint, RequestResultClosure);

//Closure that decides if/how a request should be stubbed
typedef OCMStubBehavor(^StubClosure)(id<OCMTargetType>);

@interface OCMProvider : NSObject

@property (nonatomic,copy) EndpointClosure endpointClosure;

@property (nonatomic,copy) RequestClosure requestClosure;

@property (nonatomic,copy) StubClosure stubClosure;

@property (nonatomic,copy) NSArray<id<OCMPlugin>> *plugins;

@property (nonatomic,strong) OCMHTTPSessionManager *Manager;

- (instancetype)initWithEndpointClosure:(EndpointClosure)enpointClosure
                         requestClosure:(RequestClosure)requestClosure
                            stubClosure:(StubClosure)stubClosure
                                manager:(OCMHTTPSessionManager *)manager
                                plugins:(NSArray<id<OCMPlugin>> *)plugins;

@end
