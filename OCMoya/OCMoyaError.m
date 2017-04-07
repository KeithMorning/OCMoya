//
//  OCMoyaError.m
//  OCMoya
//
//  Created by KeithXi on 27/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMoyaError.h"
#import "OCMResponse.h"

NSString *const OCMoyaErrorDomain = @"com.moya.netService";

@interface OCMoyaError()

@property (nonatomic,strong) NSError *error;

@end

@implementation OCMoyaError

- (instancetype)initWithError:(NSError *)error errorType:(OCMoyaErrorType)errorType response:(OCMResponse *)response{
    if (self = [super init]) {
        _error = error;
        _errorType = errorType;
        _response = response;
    }
    
    return self;
}

- (NSString *)errorDescription{
    switch (self.errorType) {
        case OCMoyaErrorTypeImageMapping:
            return @"Failed to map data to an Image.";
            break;
        case OCMoyaErrorTypeJsonMapping:
            return @"Failed to map data to JSON.";
            break;
        case OCMoyaErrorTypeStringMapping:
            return @"Failed to map data to a String.";
            break;
        case OCMoyaErrorTypeRequestMapping:
            return @"Failed to map Endpoint to a URLRequest.";
            break;
        case OCMoyaErrorTypeServiceFailed:
        case OCMoyaErrorTypeHttpFailed:
        case OCMoyaErrorTypeUnderlying:
            return self.error.localizedDescription;
            break;
    }
}


+ (OCMoyaError *)requestMappingError{

    return [[OCMoyaError alloc] initWithError:nil errorType:OCMoyaErrorTypeRequestMapping response:nil];
}

+ (OCMoyaError *)underlyingError:(NSError *)error{
    return [[OCMoyaError alloc] initWithError:error errorType:OCMoyaErrorTypeUnderlying response:nil];
}

@end


@implementation NSError (OCMoyaError)

+ (instancetype)errorWithCode:(NSInteger)code errorlocalizetion:(NSString *)message{
    if (!message) {
        message = @"";
    }
    NSError *error = [NSError errorWithDomain:OCMoyaErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:message}];
    return error;
}

@end
