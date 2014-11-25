//
//  SVProvider.h
//  SVWebService
//
//  Created by Bradley Hilton on 10/20/14.
//  Copyright (c) 2014 Skyvive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVWebService.h"

@interface SVProvider : NSObject
typedef void (^ Success)(NSArray *objects);
typedef void (^ Failure)(NSError *error);
@property (nonatomic) Class service;
+ (instancetype)providerWithService:(Class)service;
- (void)GET:(NSString *)relativePath parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
- (void)POST:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object success:(Success)success failure:(Failure)failure;
- (void)POST:(NSString *)relativePath parameters:(NSDictionary *)parameters multipartConstructor:(void (^)(id <AFMultipartFormData> formData))multipartConstructor success:(Success)success failure:(Failure)failure;
- (void)PUT:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object success:(Success)success failure:(Failure)failure;
- (void)PATCH:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object success:(Success)success failure:(Failure)failure;
- (void)DELETE:(NSString *)relativePath parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
- (void)makeCallWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object success:(Success)success failure:(Failure)failure;
@end
