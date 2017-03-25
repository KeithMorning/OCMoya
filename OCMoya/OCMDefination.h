//
//  OCMDefination.h
//  OCMoya
//
//  Created by KeithXi on 23/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#ifndef OCMDefination_h
#define OCMDefination_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OCMMethod) {
    OCMMethodGET,
    OCMMethodPOST,
    OCMMethodPUT,
    OCMMethodDELETE,
    OCMMethodHEAD,
};

typedef NS_ENUM(NSUInteger, OCMParameterEncoding) {
    OCMParameterEncodingJSON,
    OCMParameterEncodingURL,
    OCMParameterEncodingPropertyList,
};


typedef NS_ENUM(NSUInteger, OCMTaskType) {
    OCMTaskTypeRequest,
    OCMTaskTypeUploadFile,
    OCMTaskTypeUploadMultipart,
    OCMTaskTypeDownload,
};


@protocol OCMURLRquestConverible <NSObject>

- (NSURLRequest *)convert;

@end

#endif /* OCMDefination_h */
