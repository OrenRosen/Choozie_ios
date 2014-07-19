//
//  NSDictionary+ValueNotNull.h
//  FTBpro-Mobile
//
//  Created by Oded Regev on 1/24/13.
//  Copyright (c) 2013 FTBpro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (ValueNotNull)

- (id)objectForKeyNotNull:(id)key;

@end

