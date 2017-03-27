//
//  OCMTargetType.h
//  OCMoya
//
//  Created by KeithXi on 23/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#ifndef OCMTargetType_h
#define OCMTargetType_h

#import <Foundation/Foundation.h>
#import "OCMDefination.h"
#import "OCMoyaTask.h"

@protocol OCMTargetType <NSObject>

@property (nonatomic,copy,readonly) NSURL *baseURL;

@property (nonatomic,copy,readonly) NSString *path;

@property (nonatomic,assign,readonly) OCMMethod meathod;

@property (nonatomic,copy,readonly) NSDictionary<NSString *,id> *parameters;

@property (nonatomic,assign,readonly) OCMParameterEncoding parameterEncoding;

@property (nonatomic,copy,readonly) NSData *sampleData;

@property (nonatomic,strong,readonly) OCMoyaTask *taskType;

@property (nonatomic,assign,readonly) BOOL validate;

@end


#endif /* OCMTargetType_h */
