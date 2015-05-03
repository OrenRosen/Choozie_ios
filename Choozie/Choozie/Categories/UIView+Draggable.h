//
//  UIView+Draggable.h
//  Choozie
//
//  Created by admin on 4/24/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Draggable) 

@property (nonatomic, weak) NSLayoutConstraint *constraintForX;
@property (nonatomic, weak) NSLayoutConstraint *constraintForY;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, strong) UIPanGestureRecognizer *dragGesture;

@property (nonatomic, copy) BOOL (^shouldReturnWhenDragEnds)();
@property (nonatomic, copy) void (^draggingStartedBlock)();
@property (nonatomic, copy) void (^draggingChangedBlock)();
@property (nonatomic, copy) void (^draggingEndedBlock)();

//@property (nonatomic) BOOL shouldReturnWithBoundWhenDraggingEnds;

- (void)setDraggableWithConstraintX:(NSLayoutConstraint *)constraintX constraintY:(NSLayoutConstraint *)constraintY inView:(UIView *)containerView;



@end
