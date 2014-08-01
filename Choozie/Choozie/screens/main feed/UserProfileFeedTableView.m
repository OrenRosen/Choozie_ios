//
//  UserProfileFeedTableView.m
//  Choozie
//
//  Created by Oren Rosenblum on 01/08/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "UserProfileFeedTableView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "Constants.h"

@implementation UserProfileFeedTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//
//- (void)addInfScroll
//{
//    __weak FeedTableView *weakSelf = self;
//    [self addInfiniteScrollingWithActionHandler:^{
//        
//        NSString *userProfileUrl = [kFeedUrl stringByAppendingString:[NSString stringWithFormat:kCurserAdditionToFeedUrl, weakSelf.feedResponse.cursor]];
//        userProfileUrl = [userProfileUrl stringByAppendingString:kUserProfileAdditionToFeedUrl, self.]
//        
//    }];
//}

@end
