//
//  ChoozieUser.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieMantle.h"

@interface ChoozieUser : ChoozieMantle


@property (nonatomic, strong) NSString *fb_uid;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *display_name;
@property (nonatomic, strong) NSString *avatar;

@end
