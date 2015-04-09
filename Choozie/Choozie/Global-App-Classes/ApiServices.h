//
//  ApiServices.h
//  FTBpro-Mobile
//
//  Created by Oded Regev on 1/23/13.
//  Copyright (c) 2013 FTBpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface ApiServices : AFHTTPSessionManager

+ (id)sharedInstance;

- (NSURLSessionDataTask *) callService:(NSString *)serviceUrl withSuccessBlock:(void(^)(NSDictionary *json))onSuccess failureBlock:(void(^)(NSError *error))onFailure;

// Call to service with different cache policy or timeout
- (NSURLSessionDataTask *) callService:(NSString *)serviceUrl timoutInterval:(NSTimeInterval)timeoutInterval withSuccessBlock:(void(^)(NSDictionary *json))onSuccess failureBlock:(void(^)(NSError *error))onFailure;


- (NSURLSessionDataTask *) callHttpGetForUrl:(NSString *)urlString withSuccessBlock:(void(^)(NSDictionary * responseObject))onSuccess failureBlock:(void(^)(NSError *error))onFailure;

// Call to HTTP GET with different cache policy or timeout
- (NSURLSessionDataTask *) callHttpGetForUrl:(NSString *)urlString timoutInterval:(NSTimeInterval)timeoutInterval withSuccessBlock:(void(^)(NSDictionary * responseObject))onSuccess failureBlock:(void(^)(NSError *error))onFailure;

- (void) callHttpPostToUrl:(NSString *)postPath withDictionary:(NSDictionary *)data;

@end
