//
//  QuandlObject.h
//  SVWebService
//
//  Created by Bradley Hilton on 11/24/14.
//  Copyright (c) 2014 Brad Hilton. All rights reserved.
//

#import "JSONModel.h"

@interface QuandlObject : JSONModel
@property (nonatomic) NSDictionary *errors;
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *sourceName;
@property (nonatomic) NSString *sourceCode;
@property (nonatomic) NSString *code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *urlizeName;
@property (nonatomic) NSString *displayUrl;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic) NSArray *columnNames;
@property (nonatomic) BOOL private;
@property (nonatomic) BOOL premium;
@property (nonatomic) NSArray *data;
@end
