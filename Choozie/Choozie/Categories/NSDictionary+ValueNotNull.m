//
//  NSDictionary+ValueNotNull.m
//  FTBpro-Mobile
//
//  Created by Oded Regev on 1/24/13.
//  Copyright (c) 2013 FTBpro. All rights reserved.
//

#import "NSDictionary+ValueNotNull.h"

@implementation NSDictionary (ValueNotNull)

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

@end
