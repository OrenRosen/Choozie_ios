//
//  UIView+Draggable.m
//  Choozie
//
//  Created by admin on 4/24/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "UIView+Draggable.h"
#import <objc/runtime.h>


@interface UIView (Draggable_Private)

@property (nonatomic) CGPoint lastDraggedPoint;

@property (nonatomic) CGFloat originalX;
@property (nonatomic) CGFloat originalY;

@end


@implementation UIView(Draggable_Private)

- (void)setLastDraggedPoint:(CGPoint)lastDraggedPoint
{
    NSValue *lastDraggedPointValue = [NSValue valueWithCGPoint:lastDraggedPoint];
    objc_setAssociatedObject(self, @selector(lastDraggedPoint), lastDraggedPointValue, OBJC_ASSOCIATION_RETAIN);
}


- (CGPoint)lastDraggedPoint
{
    NSValue *lastDraggedPointValue = objc_getAssociatedObject(self, @selector(lastDraggedPoint));
    return [lastDraggedPointValue CGPointValue];
}


- (void)setOriginalX:(CGFloat)originalX
{
    NSNumber *originalXNumber = [NSNumber numberWithFloat:originalX];
    objc_setAssociatedObject(self, @selector(originalX), originalXNumber, OBJC_ASSOCIATION_ASSIGN);
}


- (CGFloat)originalX
{
    NSNumber *originalXNumber = objc_getAssociatedObject(self, @selector(originalX));
    return [originalXNumber floatValue];
}


- (void)setOriginalY:(CGFloat)originalY
{
    NSNumber *originalYNumber = [NSNumber numberWithFloat:originalY];
    objc_setAssociatedObject(self, @selector(originalX), originalYNumber, OBJC_ASSOCIATION_ASSIGN);
}


- (CGFloat)originalY
{
    NSNumber *originalYNumber = objc_getAssociatedObject(self, @selector(originalY));
    return [originalYNumber floatValue];
}



@end


@implementation UIView(Draggable)


#pragma mark - setters/getters

- (void)setDragGesture:(UIPanGestureRecognizer*)dragGesture
{
    objc_setAssociatedObject(self, @selector(dragGesture), dragGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIPanGestureRecognizer *)dragGesture
{
    return objc_getAssociatedObject(self, @selector(dragGesture));
}


- (void)setContainerView:(UIView *)containerView
{
    objc_setAssociatedObject(self, @selector(containerView), containerView, OBJC_ASSOCIATION_ASSIGN);
}


- (UIView *)containerView
{
    return objc_getAssociatedObject(self, @selector(containerView));
}


- (void)setConstraintForX:(NSLayoutConstraint *)constraintForX
{
    objc_setAssociatedObject(self, @selector(constraintForX), constraintForX, OBJC_ASSOCIATION_ASSIGN);
}


- (void)setConstraintForY:(NSLayoutConstraint *)constraintForY
{
    objc_setAssociatedObject(self, @selector(constraintForY), constraintForY, OBJC_ASSOCIATION_ASSIGN);
}


- (NSLayoutConstraint *)constraintForX
{
    return objc_getAssociatedObject(self, @selector(constraintForX));
}


- (NSLayoutConstraint *)constraintForY
{
    return objc_getAssociatedObject(self, @selector(constraintForY));
}


- (void)setDraggingStartedBlock:(void (^)())draggingStartedBlock
{
    objc_setAssociatedObject(self, @selector(draggingStartedBlock), draggingStartedBlock, OBJC_ASSOCIATION_RETAIN);
}

- (void (^)())draggingStartedBlock
{
    return objc_getAssociatedObject(self, @selector(draggingStartedBlock));
}

- (void)setDraggingEndedBlock:(void (^)())draggingEndedBlock
{
    objc_setAssociatedObject(self, @selector(draggingEndedBlock), draggingEndedBlock, OBJC_ASSOCIATION_RETAIN);
}

- (void (^)())draggingEndedBlock
{
    return objc_getAssociatedObject(self, @selector(draggingEndedBlock));
}


- (void)setDraggingChangedBlock:(void (^)())draggingChangedBlock
{
    objc_setAssociatedObject(self, @selector(draggingChangedBlock), draggingChangedBlock, OBJC_ASSOCIATION_RETAIN);
}


- (void (^)())draggingChangedBlock
{
    return objc_getAssociatedObject(self, @selector(draggingChangedBlock));
}


- (void)setShouldReturnWithBoundWhenDraggingEnds:(BOOL)shouldReturnWithBoundWhenDraggingEnds
{
    NSNumber *numberVal = [NSNumber numberWithBool:shouldReturnWithBoundWhenDraggingEnds];
    objc_setAssociatedObject(self, @selector(shouldReturnWithBoundWhenDraggingEnds), numberVal, OBJC_ASSOCIATION_ASSIGN);
}


- (BOOL)shouldReturnWithBoundWhenDraggingEnds
{
    NSNumber *numberVal = objc_getAssociatedObject(self, @selector(shouldReturnWithBoundWhenDraggingEnds));
    return [numberVal boolValue];
}


#pragma mark - iInterface Methods

- (void)setDraggableWithConstraintX:(NSLayoutConstraint *)constraintX constraintY:(NSLayoutConstraint *)constraintY inView:(UIView *)containerView
{
    self.constraintForX = constraintX;
    self.constraintForY = constraintY;
    self.containerView = containerView;
    self.originalX = constraintY.constant;
    self.originalY = constraintY.constant;
    self.dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.dragGesture];
}


#pragma mark - Private Methods

- (void)dragged:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        self.lastDraggedPoint = [gesture translationInView:gesture.view];;
        [self callDraggingStartedBlockIfNeeded];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        [self updateConstraintsXYWhileDragging];
        self.lastDraggedPoint = [gesture translationInView:gesture.view];;
        [self callDraggingChangedBlockIfNeeded];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self returnToOriginaPositionlIfNeeded];
        [self callDraggingEndedBlockIfNeeded];
    }
}


- (void)updateConstraintsXYWhileDragging
{
    CGPoint current = [self.dragGesture translationInView:self.dragGesture.view];
    CGFloat diffX = current.x - self.lastDraggedPoint.x;
    CGFloat diffY = current.y - self.lastDraggedPoint.y;
    
    self.constraintForX.constant = self.constraintForX.constant + diffX;
    self.constraintForY.constant = self.constraintForY.constant + diffY;
    [self layoutIfNeeded];
}


- (void)returnToOriginaPositionlIfNeeded
{
    self.constraintForX.constant = -self.constraintForX.constant/5;
    self.constraintForY.constant = -self.constraintForY.constant/5;

    [UIView animateWithDuration:0.2 animations:^{
        
        [self.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.constraintForX.constant = -self.constraintForX.constant/2;
        self.constraintForY.constant = -self.constraintForY.constant/2;
        
        [UIView animateWithDuration:0.14 animations:^{
            [self.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.constraintForX.constant = -self.constraintForX.constant/3;
            self.constraintForY.constant = -self.constraintForY.constant/3;
            
            [UIView animateWithDuration:0.1 animations:^{
                [self.containerView layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.constraintForX.constant = 0;
                self.constraintForY.constant = 0;
                
                [UIView animateWithDuration:0.05 animations:^{
                    [self.containerView layoutIfNeeded];
                }];
            }];
        }];
    }];
}


- (void)callDraggingStartedBlockIfNeeded
{
    if (self.draggingStartedBlock) {
        self.draggingStartedBlock();
    }
}


- (void)callDraggingChangedBlockIfNeeded
{
    if (self.draggingChangedBlock) {
        self.draggingChangedBlock();
    }
}


- (void)callDraggingEndedBlockIfNeeded
{
    if (self.draggingEndedBlock) {
        self.draggingEndedBlock();
    }
}



@end
