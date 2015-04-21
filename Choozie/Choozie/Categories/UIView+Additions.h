//
//  UIView+UIView_Additions.h
//
//  Created by Yosi Taguri on 10/17/12.
//  Copyright (c) 2012 Labgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


- (void)fadeOutWithDuration:(CGFloat)duration;
- (void)fadeInWithDuration:(CGFloat)duration;
- (void)fadeInWithDuration:(CGFloat)duration withCompletion:(void(^)(void))onComplete;
- (void)fadeOutWithDuration:(CGFloat)duration withCompletion:(void(^)(void))onComplete;

+ (void)fadeOutViews:(NSArray *)views withDuration:(CGFloat)duration;
+ (void)fadeInViews:(NSArray *)views withDuration:(CGFloat)duration;
+ (void)fadeOutViews:(NSArray *)views withDuration:(CGFloat)duration withCompletion:(void(^)(void))onComplete;
+ (void)fadeInViews:(NSArray *)views withDuration:(CGFloat)duration withCompletion:(void(^)(void))onComplete;


@end
