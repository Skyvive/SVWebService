//
//  GoldPriceService.h
//  SVWebService
//
//  Created by Bradley Hilton on 11/24/14.
//  Copyright (c) 2014 Brad Hilton. All rights reserved.
//

#import "BaseService.h"

@interface GoldPriceService : BaseService
+ (void)getGoldPricesWithSuccess:(Success)success failure:(Failure)failure;
@end
