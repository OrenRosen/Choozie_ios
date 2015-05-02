//
//  ChooziePostDraggableHelper.m
//  Choozie
//
//  Created by admin on 4/25/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "ChooziePostDraggableHelper.h"
#import "UIView+Draggable.h"
#import "ChoozieTwoImagesPostCell.h"
#import "HeroButton.h"
#import "MLPSpotlight.h"

@interface ChooziePostDraggableHelper()

@property (nonatomic, weak) ChoozieTwoImagesPostCell *chooziePostCell;
@property (nonatomic, weak) NSLayoutConstraint *constraintX;
@property (nonatomic, weak) NSLayoutConstraint *constraintY;
@property (nonatomic, weak) UIView *viewtoDrag;

@end



@implementation ChooziePostDraggableHelper



- (instancetype)initInCell:(ChoozieTwoImagesPostCell *)cell withConstraintX:(NSLayoutConstraint *)constraintX constraintY:(NSLayoutConstraint *)constraintY
{
    if (self = [super init]) {
        
        self.chooziePostCell = cell;
        self.constraintX = constraintX;
        self.constraintY = constraintY;
        self.viewtoDrag = cell.circleRight;
        [self setDraggableInCell];    }
    
    return self;
}



- (void)setDraggableInCell
{
    [self setDraggingChangedBlock];
    [self setDraggingEndedBlock];
    [self.viewtoDrag setDraggableWithConstraintX:self.constraintX constraintY:self.constraintY inView:self.chooziePostCell];
    self.viewtoDrag.shouldReturnWithBoundWhenDraggingEnds = YES;
    
}



#pragma mark - Private Methdos


- (void)setDraggingChangedBlock
{
    [self.viewtoDrag setDraggingChangedBlock:^{
        [self rotateDraggedView];
    }];
}


- (void)setDraggingEndedBlock
{
    [self.viewtoDrag setDraggingEndedBlock:^{
        [self rotateWithAnimationToDeg:0];
    }];
    

//    NSTimeInterval duration = 320.0 / velocityX;
//    CGPoint offScreenCenter = moveView.center;
//    offScreenCenter.x += xPoints;
//    [UIView animateWithDuration:duration animations:^{
//        moveView.center = offScreenCenter;
//    }];
}


- (void)draggedChanged
{
    [self rotateDraggedView];
}


- (void)rotateDraggedView
{
    static NSInteger prev = -1;
    UIView *anchorView = [self getViewInRegardToRotateWithGesture];
    CGFloat deg = [self getWantedDegreeForDraggedView];
    
    NSInteger current = (anchorView == self.chooziePostCell.rightImageView) ? 1 : 2;
    BOOL isDiffAnchorView = ((prev == -1) || (current != prev));
    if (isDiffAnchorView) {
        [self rotateWithAnimationToDeg:deg];
    } else {
        [self rotateWithoutAnimationToDeg:deg];
    }
    
    prev = current;
    
    CGRect anchorViewFrame = [anchorView convertRect:anchorView.bounds toView:self.chooziePostCell.contentView];
    CGRect draggedViewFrame = [self.viewtoDrag convertRect:self.viewtoDrag.bounds toView:self.chooziePostCell.contentView];
    
    BOOL isInside = CGRectIntersectsRect(anchorViewFrame, draggedViewFrame);
    
    UIView *spotLightview = (anchorView == self.chooziePostCell.rightImageView) ? self.chooziePostCell.spotlightRight : self.chooziePostCell.spotlightLeft;
    
    CGFloat diff = anchorViewFrame.origin.y + anchorViewFrame.size.height - (draggedViewFrame.origin.y + draggedViewFrame.size.height);
    CGFloat alpha = MIN(0.8,(diff+100)/(anchorViewFrame.size.height/4));
    
    if (isDiffAnchorView) {
       UIView *prevSpotLightView = (anchorView == self.chooziePostCell.rightImageView) ? self.chooziePostCell.spotlightLeft : self.chooziePostCell.spotlightRight;
        
        spotLightview.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            prevSpotLightView.alpha = 0.0;
            spotLightview.alpha = alpha;
            
        } completion:^(BOOL finished) {
            prevSpotLightView.hidden = YES;
            prevSpotLightView.opaque = NO;
        }];
    } else {
        spotLightview.alpha = alpha;
        spotLightview.hidden = (alpha > 0) ? NO : YES;
    }
}


- (void)rotateWithAnimationToDeg:(CGFloat)deg
{
    [UIView animateWithDuration:0.2 animations:^{
        self.chooziePostCell.spotlightLeft.alpha = 0;
        self.chooziePostCell.spotlightRight.alpha = 0;
        [self rotatePointerImageViewByDegree:deg];
    }];
    
    [self aniamateShadowOffsetToDeg:deg];
    
    
    CGPoint velocity = [self.viewtoDrag.dragGesture velocityInView:self.chooziePostCell];
    NSLog(@" ***** velo = %@", NSStringFromCGPoint(velocity));
}


- (void)rotateWithoutAnimationToDeg:(CGFloat)deg
{
    [self rotatePointerImageViewByDegree:deg];
    [self rotateShoadowOffsetByDegree:deg];
}


- (void)aniamateShadowOffsetToDeg:(CGFloat)deg
{
    CABasicAnimation *animShadowOffset = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
    animShadowOffset.fromValue = [NSValue valueWithCGSize:self.viewtoDrag.layer.shadowOffset];
    animShadowOffset.toValue = [NSValue valueWithCGSize:[self getShadowOffsetForDeg:deg]];
    animShadowOffset.duration = 0.1;
    [self rotateShoadowOffsetByDegree:deg];
    [self.viewtoDrag.layer addAnimation:animShadowOffset forKey:@"shadowOffset"];
}


- (UIView *)getViewInRegardToRotateWithGesture
{
    if (self.constraintX.constant > 0) {
        return self.chooziePostCell.rightImageView;
    } else {
        return self.chooziePostCell.leftImageView;
    }
}


- (CGFloat)getWantedDegreeForDraggedView
{
    UIView *anchorView = [self getViewInRegardToRotateWithGesture];
    CGFloat diffCeneterX = self.viewtoDrag.superview.center.x - anchorView.center.x;
    CGFloat diffCeneterY =  self.viewtoDrag.superview.center.y - anchorView.center.y;
    
    CGFloat x = atan2(diffCeneterY, diffCeneterX);
    CGFloat deg = ((x > 0 ? x : (2*M_PI + x)) * 360 / (2*M_PI)) - 90;
    return deg;
}


- (void)rotatePointerImageViewByDegree:(CGFloat)deg
{
    CGAffineTransform transform = CGAffineTransformMakeRotation([self degreesToRadians:deg]);
    self.chooziePostCell.pointerImageView.transform = transform;
}


- (void)rotateShoadowOffsetByDegree:(CGFloat)deg
{
    self.viewtoDrag.layer.shadowOffset = [self getShadowOffsetForDeg:deg];
    self.viewtoDrag.layer.shadowRadius = 3;
}



- (CGSize)getShadowOffsetForDeg:(CGFloat)deg
{
    CGFloat maxOffset = 3.0;
    CGFloat x = 0;
    CGFloat y = 0;
    if ((deg > -90) && (deg <= 0)) {
        
        x = (deg = 0)? 0 : maxOffset/(90.0/(-deg));
        y = maxOffset/(90.0/(90.0+deg));
        
    } else if ((deg > 0) && (deg <= 90)) {
        
        x = -maxOffset/(90.0/deg);
        y = maxOffset/(90.0/(90.0-deg));
        
    } else if ((deg > 90) && (deg <= 180)) {
        
        y = -maxOffset/(90.0/(deg-90.0));
        deg = deg - 90;
        x = -maxOffset/(90.0/(90.0-deg));
        
    } else if ((deg > 180) && (deg <= 270)) {
        
        x =maxOffset/(90.0/(deg-180.0));
        y = -maxOffset/(90.0/(270.0-deg));
        
    }
    
    return CGSizeMake(x, y);
}


- (CGFloat)degreesToRadians:(CGFloat) degrees
{
    return degrees * M_PI / 180;
}



@end
