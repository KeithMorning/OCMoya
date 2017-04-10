//
//  AFHTTPRequestSerializer+OCMSerializer.h
//  OCMoya
//
//  Created by keith on 26/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "OCMDefination.h"

@interface OCMRequestSerializer : NSObject

+ (OCMHTTPRequestSerializer *)SerializerWithType:(OCMParameterEncoding)parameterEncoding;

@end
