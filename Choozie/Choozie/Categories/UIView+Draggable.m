//
//  UIView+Draggable.m
//  Choozie
//
//  Created by admin on 4/24/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "UIView+Draggable.h"


@interface UIView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation UIView (Draggable)

//- (void)setAsDraggable
//{
//    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggedNpanned:)];
//    [self addGestureRecognizer:self.panGesture];
//    self.panGesture.delegate = self;
//}


//- (void)draggedNpanned:(UIPanGestureRecognizer *)gesture
//{
//    static CGFloat last = INFINITY;
//    if (last == INFINITY) return;
//    
//    CGFloat current = gesture translationInView:
//    
//    
//    
//    
//    
//    
//}


@end
