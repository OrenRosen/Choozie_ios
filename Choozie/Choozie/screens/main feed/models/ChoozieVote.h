//
//  ChoozieVote.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieMantle.h"


@class ChoozieUser;
@interface ChoozieVote : ChoozieMantle


@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSNumber *vote_for;
@property (nonatomic, strong) ChoozieUser *user;


@end
