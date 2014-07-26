//
//  ChoozieComment.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "Jastor.h"
#import "ChoozieUser.h"

@interface ChoozieComment : Jastor


@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) ChoozieUser *user;


- (NSString *)getBasicCommentString;
- (NSString *)getFullCommentString;

@end
