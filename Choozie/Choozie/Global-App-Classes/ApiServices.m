//
//  ApiServices.m
//  FTBpro-Mobile
//
//  Created by Oded Regev on 1/23/13.
//  Copyright (c) 2013 FTBpro. All rights reserved.
//

#import "ApiServices.h"

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
        
    });
    return _sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (!self) {
        return nil;
    }
    
    NSString *currentVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *iosVersion = [UIDevice currentDevice].systemVersion;
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 20;
    self.requestSerializer = requestSerializer;
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"iOS %@, %@ %@", iosVersion, appName, currentVersion] forHTTPHeaderField:@"User-Agent"];
    
    return self;
}


//- (id)initWithBaseURL:(NSURL *)url {
//    self = [super initWithBaseURL:url];
//    if (!self) {
//        return nil;
//    }
//    
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    self.parameterEncoding = AFJSONParameterEncoding;
//    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
//    [self setDefaultHeader:@"Accept" value:@"application/json"];
//    
//    return self;
//}

- (NSURLSessionDataTask *) callService:(NSString *)serviceUrl timoutInterval:(NSTimeInterval)timeoutInterval withSuccessBlock:(void(^)(NSDictionary *json))onSuccess failureBlock:(void(^)(NSError *error))onFailure
{
    NSURLSessionDataTask *sessionDataTask = [self callService:serviceUrl withSuccessBlock:onSuccess failureBlock:onFailure];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (sessionDataTask.state == NSURLSessionTaskStateRunning) {
            [sessionDataTask cancel];
        }
    });
    
    return sessionDataTask;
    
}


- (NSURLSessionDataTask *) callService:(NSString *)serviceUrl withSuccessBlock:(void(^)(NSDictionary *json))onSuccess failureBlock:(void(^)(NSError *error))onFailure
{
    
#ifdef WHITE_LABEL_APP
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString *appName = [mainBundle objectForInfoDictionaryKey:@"app_name"];
    NSString *seprator = ([serviceUrl rangeOfString:@"?"].location != NSNotFound) ? @"&" : @"?";
    serviceUrl = [serviceUrl stringByAppendingFormat:@"%@name=%@", seprator, appName];
#endif
    
    NSString *baseUrl = kBaseUrl;
    
    NSString *url = [baseUrl stringByAppendingString:serviceUrl];
    
    NSLog(@"calling url: %@", url);
    NSURLSessionDataTask *session = [self GET:url parameters:nil
                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                          NSLog(@"Success: %@", url);
                                          if ([[responseObject valueForKey:@"status"] isEqualToString:@"failure"]) {
                                              NSLog(@"failure: %@", [responseObject valueForKey:@"message"]);

                                              if (onFailure) {
                                                  onFailure(nil);
                                              }
                                              return;
                                          }
                                          else {
                                              if (onSuccess) {
                                                  NSDictionary *response = responseObject;
                                                  [[response mutableCopy] removeObjectForKey:@"status"];
                                                  onSuccess(response);
                                              }
                                          }
                                      }
                                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                                          NSLog(@"%@",  [error userInfo]);
                                          
                                          // Handle failure with a proper UI
                                          if (onFailure) {
                                              onFailure(error);
                                          }
                                          else {
//                                              [[Utils sharedInstance] showConnectionOrServerError:error withAlertDismissedCompletion:nil];
                                          }
                                      }];
    
    return session;
}



- (NSURLSessionDataTask *) callHttpGetForUrl:(NSString *)urlString withSuccessBlock:(void(^)(NSDictionary * responseObject))onSuccess failureBlock:(void(^)(NSError *error))onFailure
{
    return [self callHttpGetForUrl:urlString timoutInterval:20.0 withSuccessBlock:onSuccess failureBlock:onFailure];
}



- (NSURLSessionDataTask *) callHttpGetForUrl:(NSString *)urlString timoutInterval:(NSTimeInterval)timeoutInterval withSuccessBlock:(void(^)(NSDictionary *responseObject))onSuccess failureBlock:(void(^)(NSError *error))onFailure{
    
    NSLog(@"callHttpGetForUrl: %@", urlString);
    
    NSURLSessionDataTask *session = [self GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"callHttpGetForUrl Success: %@", urlString);
        self.currentOperation = nil;
        if (onSuccess) {
            onSuccess(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.currentOperation = nil;
        if (onFailure) {
            onFailure(error);
        }
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    
    return session;
}


- (void) callHttpPostToUrl:(NSString *)postPath withDictionary:(NSDictionary *)data {
    NSLog(@"callHttpGetForUrl: %@ - with data: %@", postPath, data);
    [self POST:postPath parameters:data success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Post Request Successful, response '%@'", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}


@end
