//
//  GoldPriceTableViewCell.m
//  SVWebService
//
//  Created by Bradley Hilton on 11/24/14.
//  Copyright (c) 2014 Brad Hilton. All rights reserved.
//

#import "GoldPriceTableViewCell.h"

@implementation GoldPriceTableViewCell

- (void)setValuesForData:(NSArray *)data
{
    self.dateLabel.text = data.firstObject;
    self.valueLabel.text = [NSString stringWithFormat:@"%@", data.lastObject];
}

@end
