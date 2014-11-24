//
//  GoldPriceTableViewCell.h
//  SVWebService
//
//  Created by Bradley Hilton on 11/24/14.
//  Copyright (c) 2014 Brad Hilton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoldPriceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
- (void)setValuesForData:(NSArray *)data;
@end
