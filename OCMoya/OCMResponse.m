//
//  OCMResponse.m
//  OCMoya
//
//  Created by KeithXi on 27/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMResponse.h"



@interface OCMResponse()

@property(nonatomic,assign) NSInteger statusCode;

@property (nonatomic,strong) NSData *data;

@property (nonatomic,strong) NSURLRequest *request;

@property (nonatomic,strong) NSURLResponse *response;

@end

@implementation OCMResponse

- (instancetype)initWithStatusCode:(NSInteger)statusCode
                              data:(NSData *)data
                           request:(NSURLRequest *)request
                          response:(NSURLResponse *)response{
    
    if (self = [super init]) {
        _statusCode = statusCode;
        _data = data;
        _request = request;
        _response = response;
    }
    
    return self;

}

- (NSString *)description{
    NSString *debugdescription = [NSString stringWithFormat:@"status code %ld, data length %ld",
                                  self.statusCode,self.data.length];
    return debugdescription;
}

- (BOOL)isEqual:(OCMResponse *)object{
    if (![object isKindOfClass:[OCMResponse class]]) {
        return NO;
    }
    
    if (!object) {
        return NO;
    }
    
    BOOL isEqual = self.statusCode == object.statusCode && [self.response isEqual:object.response] && [self.data isEqual:object.data];
    
    return isEqual;
}

@end

@implementation OCMResponse (OCMDataMapping)

- (OCMImage *)mapImage:(OCMoyaError **)error{
    
    OCMImage *image = [[OCMImage alloc] initWithData:self.data];
    
    if (!image) {
        *error = [[OCMoyaError alloc] initWithError:nil errorType:OCMoyaErrorTypeImageMapping response:self];
    }
    
    return image;
}

- (id)mappJSON:(OCMoyaError **)error{
    NSError *jsonConverError;
    
    id obj = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableLeaves error:&jsonConverError];
    
    if (!obj || jsonConverError) {
        *error = [[OCMoyaError alloc] initWithError:jsonConverError errorType:OCMoyaErrorTypeJsonMapping response:self];
        return [NSNull null];
    }
    
    return obj;
}

- (NSString *)mappStringWithKeyPath:(NSString *)keyPath error:(OCMoyaError **)error{
    if(keyPath){
        NSDictionary *jsonDict = [self mappJSON:error];
        
        NSString *string = [jsonDict valueForKey:keyPath];
        
        if (!string || [string isEqual:[NSNull null]]) {
            if (!*error) {
                *error = [[OCMoyaError alloc] initWithError:nil errorType:OCMoyaErrorTypeStringMapping response:self];
            }
        }
        
        return string;
    }else{
    
        NSString *string = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        if (!string) {
            *error = [[OCMoyaError alloc] initWithError:nil errorType:OCMoyaErrorTypeStringMapping response:self];
        }
        
        return string;
    }
    
    
}

@end
