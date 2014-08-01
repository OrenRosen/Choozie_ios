//
//  UserProfileViewController.h
//  Choozie
//
//  Created by Oren Rosenblum on 26/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoozieUser.h"
#import "FeedTableView.h"

@interface UserProfileViewController : UIViewController <FeedTableViewDelegate>

@property (nonatomic, strong) ChoozieUser *user;

@end
