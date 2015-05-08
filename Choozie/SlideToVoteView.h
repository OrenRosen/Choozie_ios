//
//  SlideToVoteView.h
//  Choozie
//
//  Created by admin on 5/3/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>



@class ChoozieTwoImagesPostCell;
@interface SlideToVoteView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *arrow;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintArrowWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintArrowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRightArrow;

- (void)initDragForCell:(ChoozieTwoImagesPostCell *)cell;


@end
