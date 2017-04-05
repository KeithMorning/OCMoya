//
//  OCMProvider+stub.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProvider.h"
#import "OCMDefination.h"


@interface OCMProvider (stub)

+ (StubClosure)neverStub;

+ (StubClosure)immediatelyStub;

+ (StubClosure)delayedStub:(NSTimeInterval)time;

@end
