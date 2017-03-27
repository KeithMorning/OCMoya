//
//  AFHTTPRequestSerializer+OCMSerializer.m
//  OCMoya
//
//  Created by keith on 26/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "AFHTTPRequestSerializer+OCMSerializer.h"

@implementation AFHTTPRequestSerializer (OCMSerializer)

- (instancetype)initWithType:(OCMParameterEncoding)parameterEncoding{
    switch (parameterEncoding) {
        case OCMParameterEncodingURL:
            return [AFHTTPRequestSerializer serializer];
            break;
        case OCMParameterEncodingPropertyList:
            return [AFPropertyListRequestSerializer serializer];
        case OCMParameterEncodingJSON:
            return [AFJSONRequestSerializer serializer];
        default:
            break;
    }
}

@end
