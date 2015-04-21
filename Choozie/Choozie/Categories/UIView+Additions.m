//
//  UIView+UIView_Additions.m
//
//  Created by Yosi Taguri on 10/17/12.
//  Copyright (c) 2012 Labgoo. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)fadeInWithDuration:(CGFloat)duration
{
    [UIView fadeInViews:@[self] withDuration:duration];
}

- (void)fadeOutWithDuration:(CGFloat)duration
{
    [UIView fadeOutViews:@[self] withDuration:duration];
}

- (void)fadeInWithDuration:(CGFloat)duration withCompletion:(void (^)(void))onComplete
{
    [UIView fadeInViews:@[self] withDuration:duration withCompletion:onComplete];
}

- (void)fadeOutWithDuration:(CGFloat)duration withCompletion:(void (^)(void))onComplete
{
    [UIView fadeOutViews:@[self] withDuration:duration withCompletion:onComplete];
}

+ (void)fadeInViews:(NSArray *)views withDuration:(CGFloat)duration
{
    [UIView fadeInViews:views withDuration:duration withCompletion:nil];
}

+ (void)fadeOutViews:(NSArray *)views withDuration:(CGFloat)duration
{
    [UIView fadeOutViews:views withDuration:duration withCompletion:nil];
}

+ (void)fadeInViews:(NSArray *)views withDuration:(CGFloat)duration withCompletion:(void (^)(void))onComplete
{
    for (UIView *view in views) {
        view.alpha = 0.0;
        view.opaque = NO;
        view.hidden = NO;
    }
    
    [UIView animateWithDuration:duration animations:^{
        
        for (UIView *view in views) {
            view.alpha = 1.0;
        }
        
    } completion:^(BOOL finished) {
        
        for (UIView *view in views) {
            view.opaque = YES;
        }
        
        if (onComplete) {
            onComplete();
        }
        
    }];
}

+ (void)fadeOutViews:(NSArray *)views withDuration:(CGFloat)duration withCompletion:(void (^)(void))onComplete
{
    [UIView animateWithDuration:duration animations:^{
        
        for (UIView *view in views) {
            view.alpha = 0.0;
        }
        
    } completion:^(BOOL finished) {
        
        for (UIView *view in views) {
            view.hidden = YES;
            view.alpha = 1.0;
            view.opaque = YES;
        }
        
        if (onComplete) {
            onComplete();
        }
    }];
}



@end
