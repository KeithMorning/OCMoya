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
    
    if (!_Manager) {
        _Manager = [OCMProvider defaultHTTPManager];
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
    return [self request:target queue:nil progress:nil completion:completion];
}

- (id<OCMCancellable>)request:(id<OCMTargetType>)target queue:(dispatch_queue_t) queue progress:(progressBlock)progress completion:(Completion)completion{
    
    OCMEndpoint *endpoint = [self endpoint:target];
    OCMStubBehavor behavor = self.stubClosure(target);
   __block OCMCancellableToken *cancelToken = nil;
    
    typedef OCMResult<OCMResponse *,OCMoyaError *> Result;
    /**
     Allow the plugins modify the response
     */
    Completion plusginsWithCompletion = ^(Result *result){
        __block Result *tempresult = result;
        [self.plugins enumerateObjectsUsingBlock:^(id<OCMPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            tempresult = [obj process:tempresult.success error:tempresult.error targetType:target];
        }];
        completion(tempresult);
    };
    
    RequestResultClosure performNetworking = ^(OCMResult<NSURLRequest *,OCMoyaError *> * result){
        if (cancelToken.isCancelled) {
            //befor this request be constructed to a datatask,it may have be cancel
            [self cancelCompletion:target completion:completion];
            return;
        }
        
        if (result.error) {
            //can't create a vaild request
            Result *newResult = [[Result alloc] initWithFailure:result.error];
            completion(newResult);
            return;
        }
        
        //have a vaild request now, go next step
        NSURLRequest *request = result.success;
        __block NSURLRequest *prepareRequet= request;
        [self.plugins enumerateObjectsUsingBlock:^(id<OCMPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            prepareRequet = [obj prepareRequest:request];
            
        }];
        
        switch (behavor.behavor) {
            case OCMStubBehavorTypeNever:{
                //TODO: Track request here in future
                Completion netCompletion = ^(Result *result){
                    plusginsWithCompletion(result);
                };
                
                if ([target.taskType isKindOfClass:[OCMoyaTask class]]) {
                     cancelToken = [self sendRequest:target request:prepareRequet queue:queue progress:progress completion:netCompletion];
                }else{
                    assert(@"NOT support for now");
                }
            }
                break;
                
            default:
                cancelToken = [self stubRequest:target request:prepareRequet endpoint:endpoint stubBehavior:behavor completion:^(OCMResult<OCMResponse *,OCMoyaError *> *result) {
                    
                    //this fucntion's completion will call in the plusginsWithCompletion
                    plusginsWithCompletion(result);
                }];
                return;
                break;
        }
        
        
    };
    
    self.requestClosure(endpoint, performNetworking);
    
    return cancelToken;
}

- (void)cancelCompletion:(id<OCMTargetType>)target completion:(Completion)completion{
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
    OCMoyaError *moyaError = [OCMoyaError underlyingError:error];
    [self.plugins enumerateObjectsUsingBlock:^(id<OCMPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj didRecevice:nil error:moyaError targetType:target];
    }];
    OCMResult<OCMResponse *,OCMoyaError *> *result = [[OCMResult alloc] initWithFailure:moyaError];
    completion(result);
}

- (OCMCancellableToken *)sendRequest:(id<OCMTargetType>)target
                             request:(NSURLRequest *)request
                               queue:(dispatch_queue_t)queue
                            progress:(progressBlock)progressClosure
                          completion:(Completion)completion{
    
   OCMRequestTask *task = [self.Manager dataTaskWithRequest:request
                       uploadProgress:nil
                     downloadProgress:nil
                           completion:^(BOOL success, OCMResponse * _Nullable responseObject, OCMoyaError * _Nullable error) {
                               
                               void(^excute)() = ^{
                                   if (success) {
                                       completion([[OCMResult alloc] initWithSuccess:responseObject]);
                                   }else{
                                       completion([[OCMResult alloc] initWithFailure:error]);
                                   }
                               };
                               
                               if (queue) {
                                   dispatch_async(queue, ^{
                                       excute();
                                   });
                               }else{
                                   excute();
                               }
                               
    }];
    
   return [[OCMCancellableToken alloc] initWithRequestTask:task];
}

@end

