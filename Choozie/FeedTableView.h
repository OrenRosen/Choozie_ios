//
//  FeedTableView.h
//  Choozie
//
//  Created by Oren Rosenblum on 01/08/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedResponse.h"
#import "MainFeedDataSource.h"


@protocol FeedTableViewDelegate <NSObject>

@optional
- (void)didClickToShowProfileForUser:(ChoozieUser *)user;

@end



@interface FeedTableView : UITableView <MainFeedDataSourceDelegate>

@property (nonatomic, strong) FeedResponse *feedResponse;
@property (nonatomic, weak) id<FeedTableViewDelegate> feedTableViewDelegate;

@end
