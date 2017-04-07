//
//  OCMProvider+stub.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProvider+stub.h"

@implementation OCMProvider (stub)

+ (StubClosure)neverStub{
    return ^OCMStubBehavor(id<OCMTargetType> target){
        OCMStubBehavor behavor = {.delay = 0,.behavor = OCMStubBehavorTypeNever};
        return behavor;
    };
}

+ (StubClosure)immediatelyStub{
    return ^OCMStubBehavor(id<OCMTargetType> target){
        OCMStubBehavor behavor = {.delay = 0,.behavor = OCMStubBehavorTypeImmediate};
        return behavor;
    };
}

+ (StubClosure)delayedStub:(NSTimeInterval)time{
    return ^OCMStubBehavor(id<OCMTargetType> target){
        OCMStubBehavor behavor = {.delay = time,.behavor = OCMStubBehavorTypeDelayed};
        return behavor;
    };
}

- (OCMCancellableToken *)stubRequest:(id<OCMTargetType>)target
                             request:(NSURLRequest *)request
                            endpoint:(OCMEndpoint *)endpoint
                        stubBehavior:(OCMStubBehavor)stubBehavor completion:(Completion)competion{
    
    [self notifyPluginsOfImpendingStub:request target:target];
    OCMCancellableToken *cancelToken = [OCMCancellableToken new];
    void(^stub)() = [self createStubFuction:cancelToken plugins:self.plugins urlRequest:request endpoint:endpoint target:target completion:competion];
    
    switch (stubBehavor.behavor) {
        case OCMStubBehavorTypeNever:
            assert(@"Can't call never type stub in stub request");
            break;
        case OCMStubBehavorTypeImmediate:
            stub();
            break;
        case OCMStubBehavorTypeDelayed:
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(stubBehavor.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                stub();
            });
            break;
    }
    
    return cancelToken;

}

- (void)notifyPluginsOfImpendingStub:(NSURLRequest *)request target:(id<OCMTargetType>) target{
    
    OCMRequestTask *requestTask = [self.Manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completion:nil];
    [requestTask cancel];
    
    [self.plugins enumerateObjectsUsingBlock:^(id<OCMPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj willSendWithRequestType:requestTask target:target];
    }];
}

- (void(^)())createStubFuction:(OCMCancellableToken *)cancelToken
                       plugins:(NSArray<id<OCMPlugin>> *)plugins
                    urlRequest:(NSURLRequest *)request
                      endpoint:(OCMEndpoint *)endpoint
                        target:(id<OCMTargetType>)target
                    completion:(Completion)completion{
    
    //TODO:
    return ^{
        if (cancelToken.isCancelled) {
            [self cancelCompletion:target completion:completion];
            return;
        }
        
        OCMEndpointSampleResponse *stubResponse = endpoint.sampleResponseClosure();
        if (stubResponse.error) {
            OCMoyaError *moyaError = [OCMoyaError underlyingError:stubResponse.error];
            [plugins enumerateObjectsUsingBlock:^(id<OCMPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj didRecevice:nil error:moyaError targetType:target];
            }];
            
            completion([[OCMResult alloc] initWithFailure:moyaError]);
            return;
        }else{
            OCMResponse *response = [[OCMResponse alloc] initWithStatusCode:stubResponse.statusCode data:stubResponse.data request:request response:stubResponse.response];
            [plugins enumerateObjectsUsingBlock:^(id<OCMPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj didRecevice:response error:nil targetType:target];
            }];
            
            completion([[OCMResult alloc] initWithSuccess:response]);
            return;
        }
    };

}
@end
