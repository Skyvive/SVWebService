//
//  QuandlObject.m
//  SVWebService
//
//  Created by Bradley Hilton on 11/24/14.
//  Copyright (c) 2014 Brad Hilton. All rights reserved.
//

#import "QuandlObject.h"

@implementation QuandlObject

+ (JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
