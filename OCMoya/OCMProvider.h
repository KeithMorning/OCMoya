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
#import "OCMCancellable.h"
#import "OCMResponse.h"
#import "OCMProgressResponse.h"
#import "OCMCancellableToken.h"

//the Target covert into a Endpoint block
typedef OCMEndpoint *(^EndpointClosure)(id<OCMTargetType>);

//custom yourself request here
typedef  void(^RequestResultClosure)(OCMResult *result);

//Closure that resolves an `Endpoint` into `RequestResult`
typedef void(^RequestClosure)(OCMEndpoint *endpoint, RequestResultClosure);

//Closure that decides if/how a request should be stubbed
typedef OCMStubBehavor(^StubClosure)(id<OCMTargetType>);

typedef void(^Completion)(OCMResult<OCMResponse *,OCMoyaError *> *result);

typedef void(^progressBlock)(OCMProgressResponse *progress);

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




- (OCMEndpoint *)endpoint:(id<OCMTargetType>)target;

- (OCMCancellableToken *)request:(id<OCMTargetType>)target completion:(Completion)completion;

- (OCMCancellableToken *)request:(id<OCMTargetType>)target queue:(dispatch_queue_t) queue progress:(progressBlock)progress completion:(Completion)completion;

- (void)cancelCompletion:(id<OCMTargetType>)target completion:(Completion)completion;

@end
