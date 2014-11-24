//
//  GoldPriceService.m
//  SVWebService
//
//  Created by Bradley Hilton on 11/24/14.
//  Copyright (c) 2014 Brad Hilton. All rights reserved.
//

#import "GoldPriceService.h"
#import "QuandlObject.h"

@implementation GoldPriceService

+ (void)configureService
{
    [self setRelativePath:@"/BUNDESBANK"];
}

+ (void)getGoldPricesWithSuccess:(Success)success failure:(Failure)failure
{
    [[self provider] GET:@"/BBK01_WT5511" parameters:@{@"trim_start":@"1968-04-01", @"trim_end":@"2014-11-24"} success:success failure:failure];
}

@end
