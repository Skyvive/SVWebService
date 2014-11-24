//
//  SVWebService.m
//  SendOutCardsApp
//
//  Created by Bradley Hilton on 10/6/14.
//  Copyright (c) 2014 Send Out Cards, LLC. All rights reserved.
//

#import "SVWebService.h"

@interface SVWebService ()
@property (nonatomic) SVProvider *provider;
@property (nonatomic) NSString *relativePath;
@property (nonatomic) NSDictionary *localHeaders;
@property (nonatomic) Class responseObjectClass;
@property (nonatomic) SVWebServiceLogging logging;
@end

@implementation SVWebService

+ (instancetype)sharedServiceShouldReset:(BOOL)shouldReset
{
    id objectToRemove = nil;
    for (id sharedInstance in [self sharedInstances]) {
        if ([sharedInstance isMemberOfClass:[self class]]) {
            if (shouldReset) {
                objectToRemove = sharedInstance;
            } else {
                return sharedInstance;
            }
        }
    }
    if (objectToRemove) {
        [[self sharedInstances] removeObject:objectToRemove];
    }
    id sharedInstance = [[[self class] alloc] init];
    [[self sharedInstances] addObject:sharedInstance];
    [self configureService];
    return sharedInstance;
}

+ (NSMutableArray *)sharedInstances
{
    static NSMutableArray *sharedInstances = nil;
    if (!sharedInstances) {
        sharedInstances = [NSMutableArray array];
    }
    return sharedInstances;
}

+ (NSArray *)selfAndSubclasses
{
    NSMutableArray *selfAndSubclasses = [NSMutableArray array];
    for (SVWebService *webService in [self sharedInstances]) {
        if ([webService isKindOfClass:[self class]]) {
            [selfAndSubclasses addObject:webService];
        }
    }
    return selfAndSubclasses;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.provider = [SVProvider providerWithService:[self class]];
        self.localHeaders = [NSDictionary dictionary];
        self.relativePath = @"";
    }
    return self;
}

+ (void)configureService
{
    
}

+ (Class)parentClass
{
    return [[self superclass] isSubclassOfClass:[SVWebService class]] ? [self superclass] : nil;
}

+ (instancetype)sharedService
{
    return [self sharedServiceShouldReset:NO];
}

+ (NSString *)absolutePath
{
    NSString *basePath = [[self parentClass] absolutePath] ? [[self parentClass] absolutePath] : @"";
    return [NSString stringWithFormat:@"%@%@", basePath, [self relativePath]];
}

+ (NSString *)relativePath
{
    return [[self sharedService] relativePath];
}

+ (void)setRelativePath:(NSString *)relativePath
{
    [[self sharedService] setRelativePath:relativePath];
}

+ (NSDictionary *)allHeaders
{
    NSMutableDictionary *allHeaders = [NSMutableDictionary dictionary];
    [allHeaders addEntriesFromDictionary:[[self parentClass] allHeaders]];
    [allHeaders addEntriesFromDictionary:[self localHeaders]];
    return allHeaders;
}

+ (NSDictionary *)localHeaders
{
    return [[self sharedService] localHeaders];
}

+ (void)addValue:(NSString *)value forHeader:(NSString *)header
{
    NSMutableDictionary *mutableLocalHeaders = [[[self sharedService] localHeaders] mutableCopy];
    mutableLocalHeaders[header] = value;
    [[self sharedService] setLocalHeaders:mutableLocalHeaders];
}

+ (void)removeHeader:(NSString *)header
{
    NSMutableDictionary *mutableLocalHeaders = [[[self sharedService] localHeaders] mutableCopy];
    [mutableLocalHeaders removeObjectForKey:header];
    [[self sharedService] setLocalHeaders:mutableLocalHeaders];
}

+ (Class)responseObjectClass
{
    return [[self sharedService] responseObjectClass] ? [[self sharedService] responseObjectClass] : [[self parentClass] responseObjectClass];
}

+ (void)setResponseObjectClass:(Class)responseObjectClass
{
    [[self sharedService] setResponseObjectClass:responseObjectClass];
}

+ (SVWebServiceLogging)logging
{
    return [[self sharedService] logging] ? [[self sharedService] logging] : [[[self parentClass] sharedService] logging];
}

+ (void)setLogging:(SVWebServiceLogging)logging
{
    [[self sharedService] setLogging:logging];
}

+ (SVProvider *)provider
{
    return [[self sharedService] provider];
}

@end