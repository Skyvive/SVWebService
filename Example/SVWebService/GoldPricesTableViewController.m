//
//  GoldPricesTableViewController.m
//  SVWebService
//
//  Created by Bradley Hilton on 11/24/14.
//  Copyright (c) 2014 Brad Hilton. All rights reserved.
//

#import "GoldPricesTableViewController.h"
#import "GoldPriceService.h"
#import "QuandlObject.h"
#import "GoldPriceTableViewCell.h"

@interface GoldPricesTableViewController ()
@property (nonatomic) NSArray *goldPrices;
@end

@implementation GoldPricesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [GoldPriceService getGoldPricesWithSuccess:^(NSArray *objects) {
        QuandlObject *goldPriceData = objects.firstObject;
        self.goldPrices = goldPriceData.data;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goldPrices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoldPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoldPriceTableViewCell" forIndexPath:indexPath];
    [cell setValuesForData:self.goldPrices[indexPath.row]];
    return cell;
}

@end
