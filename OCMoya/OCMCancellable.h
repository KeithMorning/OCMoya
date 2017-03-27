//
//  OCMCancellable.h
//  OCMoya
//
//  Created by KeithXi on 27/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol OCMCancellable <NSObject>

@property (nonatomic,assign) BOOL isCancelled;

- (void)cancel;

@end

@interface OCMSimpleCancellable : NSObject<OCMCancellable>

@property (nonatomic,assign) BOOL isCancelled;

@end

@interface OCMCancellableWrapper : NSObject<OCMCancellable>

@property (nonatomic,assign) BOOL isCancelled;

@end
