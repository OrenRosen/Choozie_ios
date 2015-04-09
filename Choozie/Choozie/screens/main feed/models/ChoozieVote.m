//
//  ChoozieVote.m
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieVote.h"
#import "ChoozieUser.h"

@implementation ChoozieVote


+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ChoozieUser class]];
}


@end
