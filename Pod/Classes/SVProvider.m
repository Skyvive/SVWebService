//
//  SVProvider.m
//  SendOutCardsApp
//
//  Created by Bradley Hilton on 10/20/14.
//  Copyright (c) 2014 Send Out Cards, LLC. All rights reserved.
//

#import "SVProvider.h"

@implementation SVProvider

+ (instancetype)providerWithService:(Class)service
{
    SVProvider *provider = [SVProvider new];
    provider.service = service;
    return provider;
}

- (void)GET:(NSString *)relativePath parameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [self makeCallWithMethod:@"GET" relativePath:relativePath parameters:parameters object:nil success:success failure:failure];
}

- (void)POST:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [self makeCallWithMethod:@"POST" relativePath:relativePath parameters:parameters object:object success:success failure:failure];
}

- (void)POST:(NSString *)relativePath parameters:(NSDictionary *)parameters multipartConstructor:(void (^)(id <AFMultipartFormData> formData))multipartConstructor success:(Success)success failure:(Failure)failure
{
    [self makeRequest:[self multipartRequestWithMethod:@"POST" relativePath:relativePath parameters:parameters multipartConstructor:multipartConstructor] success:success failure:failure];
}

- (void)PUT:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [self makeCallWithMethod:@"PUT" relativePath:relativePath parameters:parameters object:object success:success failure:failure];
}

- (void)PATCH:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object success:(Success)success failure:(Failure)failure
{
    [self makeCallWithMethod:@"PATCH" relativePath:relativePath parameters:parameters object:object success:success failure:failure];
}

- (void)DELETE:(NSString *)relativePath parameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [self makeCallWithMethod:@"DELETE" relativePath:relativePath parameters:parameters object:nil success:success failure:failure];
}

- (void)makeCallWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object success:(void (^)(NSArray *objects))success failure:(void (^)(NSError *error))failure
{
    [self makeRequest:[self urlRequestWithMethod:method relativePath:relativePath parameters:parameters object:object] success:success failure:failure];
}

- (NSURLRequest *)urlRequestWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters object:(id)object
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[self urlWithRelativePath:relativePath parameters:parameters]];
    urlRequest.HTTPBody = [self dataForObject:object];
    [[self.service allHeaders] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [urlRequest addValue:obj forHTTPHeaderField:key];
    }];
    urlRequest.HTTPMethod = method;
    return urlRequest;
}

- (NSURLRequest *)multipartRequestWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters multipartConstructor:(void (^)(id<AFMultipartFormData>))multipartConstructor
{
    NSURL *url = [self urlWithRelativePath:relativePath parameters:parameters];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    NSMutableURLRequest *urlRequest = [httpClient multipartFormRequestWithMethod:method path:url.absoluteString parameters:nil constructingBodyWithBlock:multipartConstructor];
    [[self.service allHeaders] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [urlRequest addValue:obj forHTTPHeaderField:key];
    }];
    NSString *contentType = [urlRequest.allHTTPHeaderFields valueForKey:@"Content-Type"];
    [urlRequest setValue:[contentType stringByReplacingOccurrencesOfString:@"," withString:@""] forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPMethod = method;
    return urlRequest;
}

- (NSData *)dataForObject:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (JSONModel *modelObject in object) {
            [dataArray addObject:[modelObject toDictionary]];
        }
        return [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:nil];
    } else if ([object isKindOfClass:[JSONModel class]]) {
        return [NSJSONSerialization dataWithJSONObject:[(JSONModel *)object toDictionary]  options:0 error:nil];
    } else if ([object isKindOfClass:[NSData class]]) {
        return object;
    }
    return nil;
}

- (NSURL *)urlWithRelativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters
{
    NSMutableString *mutablePath = [[self.service absolutePath] mutableCopy];
    if (relativePath) {
        [mutablePath appendString:relativePath];
    }
    return [NSURL URLWithString:[self addQueryParameters:parameters toRelativePath:mutablePath]];
}

- (NSString *)addQueryParameters:(NSDictionary *)parameters toRelativePath:(NSString *)relativePath
{
    if (!parameters) {
        return relativePath;
    }
    NSURLComponents *components = [NSURLComponents componentsWithString:relativePath];
    NSMutableArray *queryItems = components.queryItems ? components.queryItems.mutableCopy : [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *name, id value, BOOL *stop) {
        if ([value isKindOfClass:[NSArray class]]) {
            value = [self commaSeperatedListForArray:value];
        }
        value = [NSString stringWithFormat:@"%@", value];
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:name value:value]];
    }];
    components.queryItems = queryItems;
    return [components.string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)commaSeperatedListForArray:(NSArray *)array
{
    NSMutableString *mutableString = [NSMutableString string];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mutableString appendFormat:idx > 0 ? @",%@" : @"%@", obj];
    }];
    return mutableString;
}

- (void)makeRequest:(NSURLRequest *)request success:(void (^)(NSArray *objects))success failure:(void (^)(NSError *error))failure
{
    if ([self.service logging] == SVWebServiceLoggingAlways) [self logRequest:request];
    NSDate *start = [NSDate date];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if ([self.service logging] == SVWebServiceLoggingAlways) NSLog(@"Connection Error: %@", connectionError.localizedDescription);
            if (failure) {
                failure(connectionError);
            }
        } else {
            if ([self.service logging] == SVWebServiceLoggingAlways) [self logRequest:request response:(NSHTTPURLResponse *)response data:data start:start];
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode > 299 && failure) {
                failure([NSError errorWithDomain:@"HTTP Error" code:statusCode userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Recieved a %li error.", (long)statusCode]}]);
            } else if (success) {
                success([self objectsForData:data]);
            }
        }
    }];
}

- (void)logRequest:(NSURLRequest *)request
{
    NSMutableString *log = [NSMutableString string];
    NSString *titleString = [NSString stringWithFormat:@"\n--> %@ %@", request.HTTPMethod, request.URL.absoluteString];
    [log appendString:titleString];
    [log appendString:[self headersString:request.allHTTPHeaderFields]];
    if (request.HTTPBody.length > 0) {
        [log appendString:[NSString stringWithFormat:@"\n%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]]];
    }
    [log appendString:@"\n-->"];
    NSLog(@"%@", log);
}

- (void)logRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data start:(NSDate *)start
{
    NSString *titleString = [NSString stringWithFormat:@"<-- %@ %@", request.HTTPMethod, response.URL.absoluteString];
    NSString *statusCode = [NSString stringWithFormat:@"%li", (long)response.statusCode];
    NSString *timeString = [NSString stringWithFormat:@"%0.2fs", [[NSDate date] timeIntervalSinceDate:start]];
    NSString *headersString = [self headersString:response.allHeaderFields];
    NSString *stringObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *formattedLog = [NSString stringWithFormat:@"\n%@ (%@, %@)%@\n%@\n<--", titleString, statusCode, timeString, headersString, stringObject];
    NSLog(@"%@", formattedLog);
}

- (NSString *)headersString:(NSDictionary *)allHeaderFields
{
    NSMutableString *headersString = [NSMutableString string];
    [allHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *headerField, NSString *headerValue, BOOL *stop) {
        [headersString appendString:[NSString stringWithFormat:@"\n%@ : %@", headerField, headerValue]];
    }];
    return headersString;
}

- (NSArray *)objectsForData:(NSData *)data
{
    NSMutableArray *objectArray = [NSMutableArray array];
    NSError *jsonSerializationError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonSerializationError];
    if (jsonSerializationError) {
        if ([self.service logging] == SVWebServiceLoggingAlways) NSLog(@"JSON Error: %@", jsonSerializationError.localizedDescription);
    }
    if (jsonObject) {
        [self addObject:jsonObject toObjectArray:objectArray];
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            for (id arrayObject in jsonObject) {
                [self addObject:arrayObject toObjectArray:objectArray];
            }
        }
    }
    return objectArray;
}

- (void)addObject:(id)object toObjectArray:(NSMutableArray *)objectArray
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        if ([self convertJsonObject:object]) {
            [objectArray addObject:[self convertJsonObject:object]];
        }
    }
}

- (id)convertJsonObject:(id)jsonObject
{
    NSError *jsonModelError = nil;
    id object = [(JSONModel *)[[self.service responseObjectClass] alloc] initWithDictionary:jsonObject error:&jsonModelError];
    if (jsonModelError) {
        if ([self.service logging] == SVWebServiceLoggingAlways) NSLog(@"JSONModel Error: %@", jsonModelError.localizedDescription);
    }
    return object;
}

@end
