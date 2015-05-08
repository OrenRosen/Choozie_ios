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
#import "SlideToVoteView.h"
#import "UIView+Additions.h"

@interface ChooziePostDraggableHelper()

@property (nonatomic, weak) ChoozieTwoImagesPostCell *chooziePostCell;
@property (nonatomic, weak) NSLayoutConstraint *constraintX;
@property (nonatomic, weak) NSLayoutConstraint *constraintY;
@property (nonatomic, weak) UIView *viewtoDrag;

@property (nonatomic, weak) UIView *anchorView;
@property (nonatomic, weak) UIView *antiAnchorView;
@property (nonatomic, weak) UIView *spotLightview;
@property (nonatomic, weak) UIView *prevSpotLightView;
@property (nonatomic) CGRect anchorViewFrame;
@property (nonatomic) CGRect draggedViewFrame;
@property (nonatomic) NSInteger currentImageNumber;
@property (nonatomic) NSInteger prevImageNumber;
@property (nonatomic) BOOL isDiffAnchorView;
@property (nonatomic) CGFloat alphaForSpotlightView;

@property (nonatomic, weak) SlideToVoteView *slideToVoteView;

@property (nonatomic) CGFloat originalWidthConstant;

@property (nonatomic, copy) CGFloat (^lineEquation)(CGFloat);




@end

typedef CGFloat (^LineEquation)(CGFloat);

@implementation ChooziePostDraggableHelper

CGFloat const kMaxSpotLightAlpha = 1;

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
        
        self.slideToVoteView = cell.slideToVoteView;
        self.slideToVoteView.constraintArrowHeight.constant = 0;
        self.slideToVoteView.constraintArrowWidth.constant = 0;
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
    [self setImageForArrow];
    [self setWidthConstantForArrow];
    [self updateImagesSizes];
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
    return NO;
    return self.alphaForSpotlightView == 1;
}


- (void)animateDraggedViewAfterSelecting
{
    
}


- (void)animateDraggedViewAfterCanceling
{
    [self rotateWithAnimationToDeg:0];
    [self animateArrowToOriginalPosition];
    
}


- (void)animateArrowToOriginalPosition
{
    self.chooziePostCell.constraintImageLeftLeft.constant = 0;
    self.chooziePostCell.constraintImageLeftTop.constant = 0;
    self.chooziePostCell.constraintImageLeftRight.constant = 0;
    
    self.chooziePostCell.constraintImageRightLeft.constant = 0;
    self.chooziePostCell.constraintImageRightTop.constant = 0;
    self.chooziePostCell.constraintImageRightRight.constant = 0;
    
    self.slideToVoteView.constraintArrowHeight.constant = 0;
    self.slideToVoteView.constraintArrowWidth.constant = 0;
    self.slideToVoteView.constraintRightArrow.constant = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.chooziePostCell layoutIfNeeded];
    }];
}


- (void)initPropertiesForDragedChanged
{
    self.anchorView = [self getViewInRegardToRotateWithGesture];
    self.originalWidthConstant = self.anchorView.height;
    self.currentImageNumber = (self.anchorView == self.chooziePostCell.rightImageView) ? 1 : 2;
    self.isDiffAnchorView = ((self.prevImageNumber == -1) || (self.currentImageNumber != self.prevImageNumber));
    self.anchorViewFrame = [self.anchorView convertRect:self.anchorView.bounds toView:self.chooziePostCell.contentView];
    self.draggedViewFrame = [self.viewtoDrag convertRect:self.viewtoDrag.bounds toView:self.chooziePostCell.contentView];
    self.spotLightview = (self.anchorView == self.chooziePostCell.rightImageView) ? self.chooziePostCell.spotlightRight : self.chooziePostCell.spotlightLeft;
    self.prevSpotLightView = (self.anchorView == self.chooziePostCell.rightImageView) ? self.chooziePostCell.spotlightLeft : self.chooziePostCell.spotlightRight;
    self.alphaForSpotlightView = [self getAlphaForSpotLightView];
    
    NSLog(@" ****** alpha = %f", self.alphaForSpotlightView);
    
    self.prevImageNumber = self.currentImageNumber;
    self.antiAnchorView = (self.currentImageNumber == 1) ? self.chooziePostCell.leftImageView : self.chooziePostCell.rightImageView;
}


- (void)setImageForArrow
{
    if (self.isDiffAnchorView) {
        NSString *imageName = (self.currentImageNumber == 1) ? @"arrow-right" : @"arrow-left";
        self.slideToVoteView.arrow.image = [UIImage imageNamed:imageName];
    }
}


- (void)setWidthConstantForArrow
{
    CGFloat cnstant = [self getConstantForWidth];
    self.slideToVoteView.constraintArrowWidth.constant = cnstant;
    self.slideToVoteView.constraintArrowHeight.constant = cnstant;
    
    
    CGPoint p1 = CGPointMake(0,0);
    CGPoint p2 = (self.currentImageNumber == 1) ? CGPointMake(60, -10) : CGPointMake(60, -50);
    LineEquation equation = [self getLineEquationWithFirstPoint:p1 second:p2];
    self.slideToVoteView.constraintRightArrow.constant = equation(cnstant);
    
    [self rotateArrow];
}


- (void)rotateArrow
{
    CGFloat deg = [self getDegForArrow];
    CGAffineTransform transform = CGAffineTransformMakeRotation([self degreesToRadians:deg]);
    self.slideToVoteView.arrow.transform = transform;
}


- (CGFloat)getDegForArrow
{
    CGFloat diffX = ABS([self getDiffX]);
    if (self.currentImageNumber == 1) {
    
        
        CGPoint p1 = CGPointMake(self.anchorView.width/2, 360);
        CGPoint p2 = CGPointMake(0, 290);
        
        LineEquation le = [self getLineEquationWithFirstPoint:p2 second:p1];
        
        
        
        CGFloat deg = le(diffX);
    
        return deg;
        
    } else {
        CGPoint p1 = CGPointMake(self.anchorView.width/2, 0);
        CGPoint p2 = CGPointMake(0, 70);
        LineEquation le = [self getLineEquationWithFirstPoint:p2 second:p1];
        
        CGFloat deg = le(diffX);
        
        return deg;
    }
}


- (void)updateImagesSizes
{
    CGFloat diffX = ABS([self getDiffX]);
    
    CGPoint p1 = CGPointMake(0, 4);
    CGPoint p2 = CGPointMake(self.originalWidthConstant/2, 0);
    
    LineEquation widthEquation = [self getLineEquationWithFirstPoint:p1 second:p2];
    CGFloat width = widthEquation(diffX);
    
    width = MAX(MIN(width, 4), 0);
    
    NSLayoutConstraint *anchorConstraint = (self.currentImageNumber == 1) ? self.chooziePostCell.constraintImageRightLeft: self.chooziePostCell.constraintImageLeftRight;
    
    NSLayoutConstraint *antiConstraintTop = (self.currentImageNumber == 2) ? self.chooziePostCell.constraintImageRightTop: self.chooziePostCell.constraintImageLeftTop;
    NSLayoutConstraint *antiConstraintRight = (self.currentImageNumber == 2) ? self.chooziePostCell.constraintImageRightRight: self.chooziePostCell.constraintImageLeftRight;
    NSLayoutConstraint *antiConstraintLeft = (self.currentImageNumber == 2) ? self.chooziePostCell.constraintImageRightLeft: self.chooziePostCell.constraintImageLeftLeft;
    
    anchorConstraint.constant = -width;
    
    antiConstraintLeft.constant = width;
    antiConstraintRight.constant = width;
    antiConstraintTop.constant = width;
}


- (CGFloat)getDiffX
{
    CGPoint centerAnchor = [self centerForFrame:self.anchorViewFrame];
    CGPoint centerDragged = [self centerForFrame:self.draggedViewFrame];
    CGFloat weirdo = self.originalWidthConstant / 6;
    
    centerAnchor.x = (self.currentImageNumber == 1) ? centerAnchor.x + weirdo : centerAnchor.x - weirdo;
    
    CGFloat diff_x = centerAnchor.x - centerDragged.x;
    
    if ((self.currentImageNumber == 1) && (diff_x<0)) {
        diff_x = 0;
    }
    
    if ((self.currentImageNumber == 2) && (diff_x>0)) {
        diff_x = 0;
    }
    
    diff_x = ABS(diff_x);
    
    return diff_x;
}


- (CGPoint)centerForFrame:(CGRect)frame
{
    CGFloat x = frame.size.width/2 + frame.origin.x;
    CGFloat y = frame.size.height/2 + frame.origin.y;
    return CGPointMake(x, y);
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
//    CGFloat alpha_y = [self getAlphaForSpotlight_Y];
//    CGFloat alpha = MIN(alpha_x, alpha_y);
    return alpha_x;
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
    CGFloat diff_x = [self getDiffX];
    
    CGFloat m_x = (diff_x<0) ? kMaxSpotLightAlpha / self.originalWidthConstant : -kMaxSpotLightAlpha / self.originalWidthConstant;
    CGFloat alpha_x = MAX(0, MIN(kMaxSpotLightAlpha + m_x*diff_x, kMaxSpotLightAlpha));
    return alpha_x;
}


- (CGFloat)getConstantForWidth
{
    CGFloat diff_x = self.anchorViewFrame.origin.x + self.originalWidthConstant/2 - (self.draggedViewFrame.origin.x + self.draggedViewFrame.size.width/2);
    
    if ((self.currentImageNumber == 1) && (diff_x<0)) {
        diff_x = 0;
    }
    
    if ((self.currentImageNumber == 2) && (diff_x>0)) {
        diff_x = 0;
    }
    
    diff_x = ABS(diff_x);
    
    CGPoint p1 = CGPointMake(0, 60);
    CGPoint p2 = CGPointMake(self.anchorView.width/2, 0);
    
    LineEquation equation = [self getLineEquationWithFirstPoint:p1 second:p2];

    return equation(diff_x);
}


- (LineEquation)getLineEquationWithFirstPoint:(CGPoint)p1 second:(CGPoint)p2;
{
    CGFloat m = (p2.y - p1.y) / (p2.x - p1.x);
    LineEquation equation = ^CGFloat(CGFloat x) {
        return p1.y + m*x;
    };
    
    return equation;
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
