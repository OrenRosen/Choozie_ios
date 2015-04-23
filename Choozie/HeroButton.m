//
//  HeroButton.m
//  Choozie
//
//  Created by admin on 4/20/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "HeroButton.h"

@interface HeroButton()




@end


@implementation HeroButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (self.disableTouches) {
        return;
    }
    
    self.heroImageView.highlighted = highlighted;
    self.heroLabel.highlighted = highlighted;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (self.disableTouches) {
        return;
    }
}


- (void)setAsChosen
{
    self.disableTouches = YES;
    self.heroImageView.highlighted = YES;
    self.heroLabel.highlighted = YES;
}


- (void)setAsNotChosen
{
    self.disableTouches = YES;
    self.heroImageView.highlighted = NO;
    [self.heroImageView setImage:[UIImage imageNamed:self.disabledImageName]];
//    self.heroLabel.enabled = NO;
}


@end
