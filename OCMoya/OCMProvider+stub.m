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

@end
