//
//  BaseService.m
//  SVWebService
//
//  Created by Bradley Hilton on 11/24/14.
//  Copyright (c) 2014 bradhilton. All rights reserved.
//

#import "BaseService.h"
#import "QuandlObject.h"

@implementation BaseService

+ (void)configureService
{
    [self setRelativePath:@"https://www.quandl.com/api/v1/datasets"];
    [self setLogging:SVWebServiceLoggingNone];
    [self addValue:@"application/json" forHeader:@"Accept"];
    [self setResponseObjectClass:[QuandlObject class]];
}

@end
