//
//  MainFeedDataSource.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTAttributedLabel.h"
#import "ChoozieFeedPostCell.h"
#import "ChoozieUser.h"


@protocol MainFeedDataSourceDelegate <NSObject>

- (void)didClickToShowProfileForUser:(ChoozieUser *)user;

@end


@interface MainFeedDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate, ChoozieFeedPostCellDelegate>


@property (nonatomic, strong) NSArray *feed;
@property (nonatomic, strong) id<MainFeedDataSourceDelegate> mainFeedDataSourceDelegate;

@end
