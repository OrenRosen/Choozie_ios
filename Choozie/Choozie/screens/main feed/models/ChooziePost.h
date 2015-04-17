//
//  ChooziePost.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieMantle.h"

@class ChoozieUser;
@interface ChooziePost : ChoozieMantle

@property (nonatomic, strong) NSString *photo1;
@property (nonatomic, strong) NSString *photo2;
@property (nonatomic, strong) ChoozieUser *user;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSNumber *post_type;

@property (nonatomic, strong) NSArray *votes1;
@property (nonatomic, strong) NSArray *votes2;


- (BOOL)isSingleImagePostCell;

@end
