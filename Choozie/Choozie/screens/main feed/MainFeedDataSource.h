//
//  MainFeedDataSource.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChoozieFeedPostCell.h"
#import "ChoozieHeaderPostCell.h"
#import "ChoozieUser.h"


@protocol MainFeedDataSourceDelegate <NSObject>

- (void)didClickToShowProfileForUser:(ChoozieUser *)user;

@optional

- (void)feedTableviewScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)feedTableScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)feedTableScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end


@interface MainFeedDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, ChoozieFeedPostCellDelegate, ChoozieHeaderPostCellDelegate>


@property (nonatomic, strong) NSArray *feed;
@property (nonatomic, strong) id<MainFeedDataSourceDelegate> mainFeedDataSourceDelegate;

@end
