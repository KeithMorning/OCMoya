//
//  AFHTTPRequestSerializer+OCMSerializer.m
//  OCMoya
//
//  Created by keith on 26/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMRequestSerializer.h"

@implementation OCMRequestSerializer

+ (OCMHTTPRequestSerializer *)SerializerWithType:(OCMParameterEncoding)parameterEncoding{

    switch (parameterEncoding) {
        case OCMParameterEncodingURL:{
            AFHTTPRequestSerializer *RequestSerializer = [AFHTTPRequestSerializer serializer];
            
            return RequestSerializer;
            break;
        }
            
        case OCMParameterEncodingPropertyList:{
            AFPropertyListRequestSerializer *propertySerializer = [AFPropertyListRequestSerializer serializer];
            [propertySerializer setValue:@"application/x-plist" forHTTPHeaderField:@"Content-Type"];
            
            return propertySerializer;
        }
            
        case OCMParameterEncodingJSON:{
            AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
            [jsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            return jsonRequestSerializer;
        }
        case OCMParameterEncodingMultiPartForm:
        {
            AFHTTPRequestSerializer *RequestSerializer = [AFHTTPRequestSerializer serializer];
            return RequestSerializer;
            break;
        }
        
            
    }
}

@end
