//
//  ChoozieComment.m
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieComment.h"
#import "ChoozieUser.h"

@implementation ChoozieComment

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ChoozieUser class]];
}


- (NSString *)getBasicCommentString
{
    return [NSString stringWithFormat: @"%@ %@",
     self.user.first_name,
     self.text];
}


- (NSString *)getFullCommentString
{
    return [NSString stringWithFormat: @"%@ %@ %@",
            self.user.first_name, self.user.last_name,
            self.text];
}

@end
