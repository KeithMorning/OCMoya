//
//  OCMoyaError.h
//  OCMoya
//
//  Created by KeithXi on 27/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OCMResponse;

typedef NS_ENUM(NSUInteger, OCMoyaErrorType) {
    OCMoyaErrorTypeImageMapping = 20001,
    OCMoyaErrorTypeJsonMapping,
    OCMoyaErrorTypeStringMapping,
    OCMoyaErrorTypeHttpFailed,
    OCMoyaErrorTypeServiceFailed,
    OCMoyaErrorTypeRequestMapping,
    OCMoyaErrorTypeUnderlying,
};

@interface OCMoyaError : NSObject

- (instancetype)initWithError:(NSError *)error
                    errorType:(OCMoyaErrorType)ErrorType
                     response:(OCMResponse *)response;

+ (instancetype)underlyingError:(NSError *)error;

@property (nonatomic,strong,readonly) OCMResponse *response;

@property (nonatomic,assign,readonly) OCMoyaErrorType errorType;

@property (nonatomic,assign,readonly) NSInteger errorcode;

@property (nonatomic,copy,readonly) NSString *errorDescription;

@property (nonatomic,copy,readonly) NSString *errorDomain;

@property (class,readonly) OCMoyaError *requestMappingError;

@end

@interface NSError (OCMoyaError)

+(instancetype)errorWithCode:(NSInteger)code errorlocalizetion:(NSString *)message;

@end
