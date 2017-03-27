//
//  OCMoyaConfig.m
//  OCMoya
//
//  Created by keith on 26/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMoyaConfig.h"

static NSDictionary *requetMethods;

@implementation OCMoyaConfig

+ (NSString *)getHTTPOCMMethod:(OCMMethod)enumMethod{
    
    if (!requetMethods) {
        requetMethods = @{
                          @(OCMMethodGET):@"GET",
                          @(OCMMethodPOST):@"POST",
                          @(OCMMethodPUT):@"PUT",
                          @(OCMMethodHEAD):@"HEAD",
                          @(OCMMethodDELETE):@"DELETE",
                          };
    }
    
    return [requetMethods objectForKey:@(enumMethod)];
}


@end
