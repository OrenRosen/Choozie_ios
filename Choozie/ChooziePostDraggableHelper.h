//
//  ChooziePostDraggableHelper.h
//  Choozie
//
//  Created by admin on 4/25/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChoozieTwoImagesPostCell;
@interface ChooziePostDraggableHelper : NSObject

@property (nonatomic, weak) UIImageView *pointerImageView;

- (instancetype)initInCell:(ChoozieTwoImagesPostCell *)cell withConstraintX:(NSLayoutConstraint *)constraintX constraintY:(NSLayoutConstraint *)constraintY;

@end
