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


@interface ChooziePost()

@property (nonatomic, strong) NSArray *votes;

@end


@implementation ChooziePost


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    [self parseVotes];
    
    return self;
}


+ (Class)comments_class
{
    return [ChoozieComment class];
}

+ (Class)votes_class
{
    return [ChoozieVote class];
}



- (void)parseVotes
{
    NSMutableArray *votes1 = [[NSMutableArray alloc] init];
    NSMutableArray *votes2 = [[NSMutableArray alloc] init];
    
    for (ChoozieVote *vote in self.votes) {
        if ([vote.vote_for integerValue] == 1) {
            [votes1 addObject:vote];
        } else {
            [votes2 addObject:vote];
        }
    }
    
    self.votes1 = [votes1 copy];
    self.votes2 = [votes2 copy];
}


@end
