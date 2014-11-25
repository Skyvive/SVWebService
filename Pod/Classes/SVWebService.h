//
//  SVWebService.h
//  SVWebService
//
//  Created by Bradley Hilton on 10/6/14.
//  Copyright (c) 2014 Skyvive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <JSONModel/JSONModel.h>
#import "SVProvider.h"

typedef enum {
    SVWebServiceLoggingInherit,
    SVWebServiceLoggingNone,
    SVWebServiceLoggingAlways
} SVWebServiceLogging;

@class SVProvider;

@interface SVWebService : NSObject

// Subclass configureService to setup relative path, headers, response object class, etc.
+ (void)configureService;

// Convenience methods for accessing and setting the URL path.
+ (NSString *)absolutePath;
+ (NSString *)relativePath;
+ (void)setRelativePath:(NSString *)relativePath;

// Convenience methods for accessing and setting service headers.
+ (NSDictionary *)allHeaders;
+ (NSDictionary *)localHeaders;
+ (void)addValue:(NSString *)value forHeader:(NSString *)header;
+ (void)removeHeader:(NSString *)header;

// Convenience methods for getting and setting your response object class.
+ (Class)responseObjectClass;
+ (void)setResponseObjectClass:(Class)responseObjectClass;

// Convenience methods for getting and setting logging
+ (SVWebServiceLogging)logging;
+ (void)setLogging:(SVWebServiceLogging)logging;

// Get service provider
+ (SVProvider *)provider;

// Get shared service
+ (instancetype)sharedService;

@end
