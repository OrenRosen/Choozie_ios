//
//  ChooziePost.m
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChooziePost.h"
#import "ChoozieComment.h"
#import "ChoozieVote.h"

@implementation ChooziePost

+ (Class)comments_class
{
    return [ChoozieComment class];
}

+ (Class)votes_class
{
    return [ChoozieVote class];
}


@end
