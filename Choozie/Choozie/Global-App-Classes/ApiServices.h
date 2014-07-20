//
//  ApiServices.h
//  FTBpro-Mobile
//
//  Created by Oded Regev on 1/23/13.
//  Copyright (c) 2013 FTBpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol ApiServicesDelegate <NSObject>



@end

@interface ApiServices : AFHTTPClient

+ (id)sharedInstance;

- (AFJSONRequestOperation *) callService:(NSString *)serviceUrl withSuccessBlock:(void(^)(NSDictionary *json))onSuccess failureBlock:(void(^)(NSError *error))onFailure;

// Call to service with different cache policy or timeout
- (AFJSONRequestOperation *) callService:(NSString *)serviceUrl withCachePolicy:(NSURLRequestCachePolicy)cachePolicy timoutInterval:(NSTimeInterval)timeoutInterval withSuccessBlock:(void(^)(NSDictionary *json))onSuccess failureBlock:(void(^)(NSError *error))onFailure;


- (AFHTTPRequestOperation *) callHttpGetForUrl:(NSString *)urlString withSuccessBlock:(void(^)(id responseObject))onSuccess failureBlock:(void(^)(NSError *error))onFailure;

// Call to HTTP GET with different cache policy or timeout
- (AFHTTPRequestOperation *) callHttpGetForUrl:(NSString *)urlString withCachePolicy:(NSURLCacheStoragePolicy)cachePolicy timoutInterval:(NSTimeInterval)timeoutInterval withSuccessBlock:(void(^)(id responseObject))onSuccess failureBlock:(void(^)(NSError *error))onFailure;


@end
