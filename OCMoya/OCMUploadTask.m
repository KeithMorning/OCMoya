//
//  OCMUploadTask.m
//  OCMoya
//
//  Created by keith on 26/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMUploadTask.h"

@implementation OCMUploadTask

@end

@interface OCMUploadMultipartTask()

@property (nonatomic,strong) OCMUploadFromProvider *provider;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *fileName;

@property (nonatomic,copy) NSString *mineType;

@end

@implementation OCMUploadMultipartTask

- (instancetype)initWithFromProvider:(OCMUploadFromProvider *)provider
                                name:(NSString *)name
                            fileName:(NSString *)fileName
                            mimeType:(NSString *)miniType {
    
    if(self = [super init]){
        _provider = provider;
        _name = name;
        _fileName = fileName;
        _mineType = miniType;
    }
    
    return self;
    
}


@end


@implementation OCMUploadFromProvider


@end


@implementation OCMUploadFromDataProvider

- (instancetype)initWithData:(NSData *)data{
    if (self = [super init]) {
        _data = data;
    }
    
    return self;
}

@end

@implementation OCMUploadFromFileProvider

- (instancetype)initWithFile:(NSURL *)file{
    if (self = [super init]) {
        _file = file;
    }
    
    return self;
}

@end

@implementation OCMUploadFromStreamProvider

- (instancetype)initWithStream:(NSInputStream *)inputStream offset:(uint64_t)offset{
    if (self = [super init]) {
        _inputStream = inputStream;
        _offset = offset;
    }
    
    return self;
}

@end
