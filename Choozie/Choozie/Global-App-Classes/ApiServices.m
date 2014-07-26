//
//  ApiServices.m
//  FTBpro-Mobile
//
//  Created by Oded Regev on 1/23/13.
//  Copyright (c) 2013 FTBpro. All rights reserved.
//

#import "ApiServices.h"
#import "AFJSONRequestOperation.h"
#import "Constants.h"

@interface ApiServices()

@property (nonatomic, strong) AFHTTPRequestOperation *currentOperation;

@end

@implementation ApiServices


+ (id)sharedInstance {
    static ApiServices *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        
        // initialize parameters

    });
    return _sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    self.parameterEncoding = AFJSONParameterEncoding;
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (AFJSONRequestOperation *) callService:(NSString *)serviceUrl withSuccessBlock:(void(^)(NSDictionary *json))onSuccess failureBlock:(void(^)(NSError *error))onFailure
{
    return [self callService:serviceUrl withCachePolicy:NSURLRequestUseProtocolCachePolicy timoutInterval:20.0 withSuccessBlock:onSuccess failureBlock:onFailure];
}


- (AFJSONRequestOperation *) callService:(NSString *)serviceUrl withCachePolicy:(NSURLRequestCachePolicy)cachePolicy timoutInterval:(NSTimeInterval)timeoutInterval withSuccessBlock:(void(^)(NSDictionary *json))onSuccess failureBlock:(void(^)(NSError *error))onFailure
{

    NSString *baseUrl = kBaseUrl;
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:serviceUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    
    NSLog(@"calling url: %@", url.absoluteString);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
                        NSLog(@"Success: %@", url.absoluteString);
                        if ([[json valueForKey:@"status"] isEqualToString:@"failure"]) {
                            NSLog(@"failure: %@", [json valueForKey:@"message"]);

                            if (onFailure) {
                                onFailure(nil);
                            }
                            return;
                        }
                        else {
                            if (onSuccess) {
                                NSDictionary *response = json;
                                [[response mutableCopy] removeObjectForKey:@"status"];
                                onSuccess(response);
                            }
                        }
                    }
                    failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                        NSLog(@"%@",  [error userInfo]);
                        // Handle failure with a proper UI
                        if (onFailure) {
                            onFailure(error);
                        }
                        else {
//                            [[Utils sharedInstance] showConnectionOrServerError:error withAlertDismissedCompletion:nil];
                        }
                    }];

    [operation start];
    

    
    return operation;
}



- (AFHTTPRequestOperation *) callHttpGetForUrl:(NSString *)urlString withSuccessBlock:(void(^)(id responseObject))onSuccess failureBlock:(void(^)(NSError *error))onFailure
{
    return [self callHttpGetForUrl:urlString withCachePolicy:NSURLRequestUseProtocolCachePolicy timoutInterval:20.0 withSuccessBlock:onSuccess failureBlock:onFailure];
}



- (AFHTTPRequestOperation *) callHttpGetForUrl:(NSString *)urlString withCachePolicy:(NSURLCacheStoragePolicy)cachePolicy timoutInterval:(NSTimeInterval)timeoutInterval withSuccessBlock:(void(^)(id responseObject))onSuccess failureBlock:(void(^)(NSError *error))onFailure{
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ftbpro.com/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    
    [request setCachePolicy:cachePolicy];
    [request setTimeoutInterval:timeoutInterval];

    NSLog(@"callHttpGetForUrl: %@", [[request URL] absoluteString]);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"callHttpGetForUrl Success: %@", [request URL].absoluteString);
        self.currentOperation = nil;
        if (onSuccess) {
            onSuccess(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.currentOperation = nil;
        if (onFailure) {
            onFailure(error);
        }
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    self.currentOperation = operation;
    [operation start];
    
    return operation;
}


@end
