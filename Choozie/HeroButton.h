//
//  HeroButton.h
//  Choozie
//
//  Created by admin on 4/20/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HeroButton;
@protocol HeroButtonDelegate <NSObject>

- (void)heroButtonDidClick:(HeroButton *)heroButton;

@end

@interface HeroButton : UIButton

@property (nonatomic, weak) IBOutlet UIImageView *heroImageView;
@property (nonatomic, weak) IBOutlet UILabel *heroLabel;

@property (nonatomic, strong) UIColor *colorIdle;
@property (nonatomic, strong) UIColor *colorPress;

@property (nonatomic) NSString *disabledImageName;
@property (nonatomic) NSString *chosenImageName;

@property (nonatomic, weak) id<HeroButtonDelegate> heroButtonDelegate;



@property (nonatomic) BOOL disableTouches;

- (void)setAsChosen;
- (void)setAsNotChosen;


@end
