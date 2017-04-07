//
//  OCMResult.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMoyaError.h"

@interface OCMResult<ObjectType,ErrorType> : NSObject

typedef ObjectType resultType;
typedef ErrorType resultErrorType;

@property (nonatomic,strong,readonly) ObjectType success;

@property (nonatomic,strong,readonly) ErrorType error;

- (instancetype)initWithSuccess:(ObjectType)success;
- (instancetype)initWithFailure:(ErrorType)error;

@end
