//
//  MainFeedDataSource.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTAttributedLabel.h"

@interface MainFeedDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate>


@property (nonatomic, strong) NSArray *feed;


@end
