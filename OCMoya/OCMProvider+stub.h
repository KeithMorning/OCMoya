//
//  OCMProvider+stub.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProvider.h"
#import "OCMDefination.h"
#import "OCMCancellableToken.h"


@interface OCMProvider (stub)

+ (StubClosure)neverStub;

+ (StubClosure)immediatelyStub;

+ (StubClosure)delayedStub:(NSTimeInterval)time;

- (OCMCancellableToken *)stubRequest:(id<OCMTargetType>)target
                             request:(NSURLRequest *)request
                            endpoint:(OCMEndpoint *)endpoint
                        stubBehavior:(OCMStubBehavor)stubBehavor;

@end
