//
//  OCMDefination.h
//  OCMoya
//
//  Created by KeithXi on 23/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#if  TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
#import <UIKit/UIKit.h>
typedef UIImage OCMImageType;
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
typedef NSImage OCMImageType;
#endif

typedef OCMImageType OCMImage;

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
    OCMParameterEncodingURL,
    OCMParameterEncodingJSON,
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
