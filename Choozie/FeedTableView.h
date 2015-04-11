//
//  FeedTableView.h
//  Choozie
//
//  Created by Oren Rosenblum on 01/08/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+SVInfiniteScrolling.h"

@class FeedTableView;
@protocol FeedTableViewDelegate <NSObject>

- (void)feedTableViewDidDropForInfScroll:(FeedTableView *)feedTableView;

@end



@interface FeedTableView : UITableView

@property (nonatomic, weak) id<FeedTableViewDelegate> feedTableViewDelegate;

@end
