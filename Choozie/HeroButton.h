//
//  HeroButton.h
//  Choozie
//
//  Created by admin on 4/20/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBShimmeringView.h"

@class HeroButton;
@protocol HeroButtonDelegate <NSObject>

- (void)heroButtonDidClick:(HeroButton *)heroButton;

@end

@interface HeroButton : UIButton

@property (nonatomic, weak) IBOutlet UIImageView *heroImageView;
@property (nonatomic, weak) IBOutlet UILabel *heroLabel;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;

@property (nonatomic, strong) UIColor *colorIdle;
@property (nonatomic, strong) UIColor *colorPress;

@property (nonatomic, strong) UIColor *borderColorIdle;
@property (nonatomic, strong) UIColor *borderColorPress;

@property (nonatomic, strong) UIColor *shimmeringColorIdle;
@property (nonatomic, strong) UIColor *shimmeringColorPress;

@property (nonatomic) NSString *disabledImageName;
@property (nonatomic) NSString *chosenImageName;



@property (nonatomic, weak) id<HeroButtonDelegate> heroButtonDelegate;


@property (nonatomic) BOOL disableTouches;

- (void)setAsChosen;
- (void)setAsNotChosen;


@end
