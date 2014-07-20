//
//  Utils.m
//  ChoozieApp
//
//  Created by Oren Rosenblum on 11/23/13.
//  Copyright (c) 2013 ChoozieApp. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (id)sharedInstance {
    static Utils *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        // initialize parameters
        
    });
    return _sharedInstance;
}



@end
