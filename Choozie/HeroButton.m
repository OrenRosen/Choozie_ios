//
//  HeroButton.m
//  Choozie
//
//  Created by admin on 4/20/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "HeroButton.h"
#import "FBShimmeringView.h"

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

- (void)awakeFromNib
{
    [self addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchCancel];
    [self addTarget:self action:@selector(startedTouching) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(startedTouching) forControlEvents:UIControlEventTouchDragEnter];
    
}

- (void)setIdle
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = self.colorIdle;
        self.shimmeringView.backgroundColor = self.colorPress;
        
        
    }];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:0.6];
    anim.duration = 0.3;
    [self.shimmeringView.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.shimmeringView.layer.shadowOpacity = 0.6;
    
    CABasicAnimation *animBorderColor = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    anim.fromValue = (id)self.borderColorPress.CGColor;
    anim.toValue = (id)self.borderColorIdle.CGColor;
    anim.duration = 0.3;
    [self.layer addAnimation:animBorderColor forKey:@"borderColor"];
    self.layer.borderColor = self.borderColorIdle.CGColor;
    
    
}


- (void)setPressed
{
    self.shimmeringView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shimmeringView.layer.shadowRadius = 2;
    self.shimmeringView.layer.shadowOffset = CGSizeMake(0, 3);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = self.colorPress;
        self.shimmeringView.backgroundColor = self.colorIdle;
    }];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.6];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = 0.1;
    [self.shimmeringView.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.shimmeringView.layer.shadowOpacity = 0.0;
    
    CABasicAnimation *animBorderColor = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    anim.fromValue = (id)self.borderColorIdle.CGColor;
    anim.toValue = (id)self.borderColorPress.CGColor;
    anim.duration = 0.1;
    [self.layer addAnimation:animBorderColor forKey:@"borderColor"];
    self.layer.borderColor = self.borderColorPress.CGColor;
}

- (IBAction)cancelClick
{
    [self setIdle];
}

- (IBAction)startedTouching
{
    [self setPressed];
}

- (IBAction)clicked
{
    [self setIdle];
    [self.heroButtonDelegate heroButtonDidClick:self];
}

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


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGFloat boundsExtension = 10.0f;
    CGRect outerBounds = CGRectInset(self.bounds, -1 * boundsExtension, -1 * boundsExtension);
    
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:self]);
    if(touchOutside)
    {
        BOOL previousTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:self]);
        if(previousTouchInside)
        {
            NSLog(@"Sending UIControlEventTouchDragExit");
            [self sendActionsForControlEvents:UIControlEventTouchDragExit];
        }
        else
        {
            NSLog(@"Sending UIControlEventTouchDragOutside");
            [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
        }
    } else {
        
        BOOL previousTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:self]);
        if(previousTouchInside)
        {
            NSLog(@"Sending UIControlEventTouchDragInside");
            [self sendActionsForControlEvents:UIControlEventTouchDragInside];
        }
        else
        {
            NSLog(@"Sending UIControlEventTouchDragEnter");
            [self sendActionsForControlEvents:UIControlEventTouchDragEnter];
        }
    }
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}


@end
