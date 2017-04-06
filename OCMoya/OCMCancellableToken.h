//
//  OCMCancellableToken.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMCancellable.h"
#import "OCMTargetType.h"
#import "OCMEndpoint.h"
#import "OCMRequestTask.h"


@interface OCMCancellableToken : NSObject<OCMCancellable>

@property (nonatomic,assign) BOOL isCancelled;

@property (nonatomic,strong,readonly) OCMRequestTask *requestTask;

- (instancetype)initWithRequestTask:(OCMRequestTask *)requestTask;

@end
