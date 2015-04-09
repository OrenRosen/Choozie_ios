//
//  FeedResponse.m
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "FeedResponse.h"
#import "ChooziePost.h"

@implementation FeedResponse


+ (NSValueTransformer *)feedJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ChooziePost class]];
}




@end
