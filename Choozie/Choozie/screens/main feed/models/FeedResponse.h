//
//  FeedResponse.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieMantle.h"

@interface FeedResponse : ChoozieMantle

@property (nonatomic, strong) NSArray *feed;
@property (nonatomic, strong) NSString *cursor;

@end
