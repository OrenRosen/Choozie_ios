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

@property (nonatomic, weak) UIView *anchorView;
@property (nonatomic, weak) UIView *spotLightview;
@property (nonatomic, weak) UIView *prevSpotLightView;
@property (nonatomic) CGRect anchorViewFrame;
@property (nonatomic) CGRect draggedViewFrame;
@property (nonatomic) NSInteger currentImageNumber;
@property (nonatomic) NSInteger prevImageNumber;
@property (nonatomic) BOOL isDiffAnchorView;
@property (nonatomic) CGFloat alphaForSpotlightView;




@end


@implementation ChooziePostDraggableHelper

CGFloat const kMaxSpotLightAlpha = 0.8;

- (instancetype)initInCell:(ChoozieTwoImagesPostCell *)cell withConstraintX:(NSLayoutConstraint *)constraintX constraintY:(NSLayoutConstraint *)constraintY
{
    if (self = [super init]) {
        
        self.chooziePostCell = cell;
        self.constraintX = constraintX;
        self.constraintY = constraintY;
        self.viewtoDrag = cell.choozeDraggedView;
        self.viewtoDrag.shouldStopMovingOnAxisY = YES;
        self.prevImageNumber = -1;
        [self setDraggableInCell];
    }
    
    return self;
}


- (void)setDraggableInCell
{
    [self setDraggingChangedBlock];
    [self setDraggingEndedBlock];
    [self.viewtoDrag setDraggableWithConstraintX:self.constraintX constraintY:self.constraintY inView:self.chooziePostCell];
    
    [self.viewtoDrag setShouldReturnWhenDragEnds:^BOOL{
        return ![self wasAnchorViewSelected];
    }];
}



#pragma mark - Private Methdos

- (void)setDraggingChangedBlock
{
    [self.viewtoDrag setDraggingChangedBlock:^{
        [self dragChanged];
    }];
}


- (void)dragChanged
{
    [self initPropertiesForDragedChanged];
    [self rotateDraggedView];
    [self updateSpotLightAlpha];
}


- (void)setDraggingEndedBlock
{
    [self.viewtoDrag setDraggingEndedBlock:^{
        [self dragEnded];
    }];
}


- (void)dragEnded
{
    [self wasAnchorViewSelected] ? [self animateDraggedViewAfterSelecting] : [self animateDraggedViewAfterCanceling];
}


- (BOOL)wasAnchorViewSelected
{
//    BOOL isInside = CGRectIntersectsRect(anchorViewFrame, draggedViewFrame);
    return (self.alphaForSpotlightView > kMaxSpotLightAlpha - 0.15);
}


- (void)animateDraggedViewAfterSelecting
{
    [UIView animateWithDuration:0.1  delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.viewtoDrag.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:0.8 options:0 animations:^{
            self.viewtoDrag.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
            
        } completion:nil];
        
        
        [UIView animateWithDuration:0.3 delay:0.6 options:0 animations:^{
            self.viewtoDrag.alpha = 0.0;
        } completion:nil];
    }];
    
    

     
     
     
//     
//                     animations:^{
//        
//        self.viewtoDrag.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
//        
//        
//    }
//     
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            self.viewtoDrag.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
//        }];
//    }];
}


- (void)animateDraggedViewAfterCanceling
{
    [self rotateWithAnimationToDeg:0];
}


- (void)initPropertiesForDragedChanged
{
    self.anchorView = [self getViewInRegardToRotateWithGesture];
    self.currentImageNumber = (self.anchorView == self.chooziePostCell.rightImageView) ? 1 : 2;
    self.isDiffAnchorView = ((self.prevImageNumber == -1) || (self.currentImageNumber != self.prevImageNumber));
    self.anchorViewFrame = [self.anchorView convertRect:self.anchorView.bounds toView:self.chooziePostCell.contentView];
    self.draggedViewFrame = [self.viewtoDrag convertRect:self.viewtoDrag.bounds toView:self.chooziePostCell.contentView];
//    self.spotLightview = (self.anchorView == self.chooziePostCell.rightImageView) ? self.chooziePostCell.spotlightRight : self.chooziePostCell.spotlightLeft;
//    self.prevSpotLightView = (self.anchorView == self.chooziePostCell.rightImageView) ? self.chooziePostCell.spotlightLeft : self.chooziePostCell.spotlightRight;
    self.alphaForSpotlightView = [self getAlphaForSpotLightView];
    NSLog(@" ***** alpah = %f", self.alphaForSpotlightView);
    self.prevImageNumber = self.currentImageNumber;
}


- (void)rotateDraggedView
{
    CGFloat deg = [self getWantedDegreeForDraggedView];
    self.isDiffAnchorView ? [self rotateWithAnimationToDeg:deg] : [self rotateWithoutAnimationToDeg:deg];
}


- (void)updateSpotLightAlpha
{
    self.isDiffAnchorView? [self changeSpotLightAlphaWithChangedAnchor] : [self changeSpotLightAlphaWithoutChangedAnchor];
}


- (void)changeSpotLightAlphaWithChangedAnchor
{
    self.spotLightview.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.prevSpotLightView.alpha = 0.0;
        self.spotLightview.alpha = self.alphaForSpotlightView;
        
    } completion:^(BOOL finished) {
        self.prevSpotLightView.hidden = YES;
        self.prevSpotLightView.opaque = NO;
    }];
}


- (void)changeSpotLightAlphaWithoutChangedAnchor
{
    self.spotLightview.alpha = self.alphaForSpotlightView;
    self.spotLightview.hidden = (self.alphaForSpotlightView > 0) ? NO : YES;
}


- (CGFloat)getAlphaForSpotLightView
{
    CGFloat alpha_x = [self getAlphaForSpotlight_X];
    CGFloat alpha_y = [self getAlphaForSpotlight_Y];
    CGFloat alpha = MIN(alpha_x, alpha_y);
    return alpha;
}


- (CGFloat)getAlphaForSpotlight_Y
{
    CGFloat diff_y = self.anchorViewFrame.origin.y + self.anchorViewFrame.size.height/2 - (self.draggedViewFrame.origin.y + self.draggedViewFrame.size.height/2);
    CGFloat m_y = (diff_y<0) ? kMaxSpotLightAlpha / self.anchorViewFrame.size.height : -kMaxSpotLightAlpha / self.anchorViewFrame.size.height;
    CGFloat alpha_y = MAX(0, MIN(kMaxSpotLightAlpha + m_y*diff_y, kMaxSpotLightAlpha));
    return alpha_y;
}


- (CGFloat)getAlphaForSpotlight_X
{
    CGFloat diff_x = self.anchorViewFrame.origin.x + self.anchorViewFrame.size.width/2 - (self.draggedViewFrame.origin.x + self.draggedViewFrame.size.width/2);
    
    CGFloat m_x = (diff_x<0) ? kMaxSpotLightAlpha / self.anchorViewFrame.size.width : -kMaxSpotLightAlpha / self.anchorViewFrame.size.width;
    CGFloat alpha_x = MAX(0, MIN(kMaxSpotLightAlpha + m_x*diff_x, kMaxSpotLightAlpha));
    return alpha_x;
}

- (void)rotateWithAnimationToDeg:(CGFloat)deg
{
    [self animatePointerToDegree:deg];
    [self aniamateShadowOffsetToDeg:deg];
}


- (void)animatePointerToDegree:(CGFloat)deg
{
    [UIView animateWithDuration:0.2 animations:^{
        self.chooziePostCell.spotlightLeft.alpha = 0;
        self.chooziePostCell.spotlightRight.alpha = 0;
        [self rotatePointerImageViewByDegree:deg];
    }];
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
    CGFloat diffCeneterX = self.viewtoDrag.superview.center.x - anchorView.center.x ;
    CGFloat diffCeneterY = anchorView.center.y - self.viewtoDrag.superview.center.y;
    
    CGFloat x = atan2(diffCeneterY, diffCeneterX);
    CGFloat deg = ((x > 0 ? x : (2*M_PI + x)) * 360 / (2*M_PI)) - 90;
    return deg;
}


- (void)rotatePointerImageViewByDegree:(CGFloat)deg
{
    CGAffineTransform transform = CGAffineTransformMakeRotation([self degreesToRadians:deg]);
    self.pointerImageView.transform = transform;
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
