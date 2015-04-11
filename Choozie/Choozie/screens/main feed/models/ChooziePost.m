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
#import "ChoozieUser.h"


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

- (NSArray *)votes1
{
    if (!_votes1) {
        [self parseVotes];
    }
    
    return _votes1;
}

- (NSArray *)votes2
{
    if (!_votes2) {
        [self parseVotes];
    }
    
    return _votes2;
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ChoozieUser class]];
}

+ (NSValueTransformer *)commentsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ChoozieComment class]];
}

+ (NSValueTransformer *)votesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ChoozieVote class]];
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
