//
//  SlideToVoteView.m
//  Choozie
//
//  Created by admin on 5/3/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "SlideToVoteView.h"
#import "ChooziePostDraggableHelper.h"
#import "UIView+Draggable.h"
#import "ChoozieTwoImagesPostCell.h"

@interface SlideToVoteView()

@property (nonatomic, weak) IBOutlet UIView *draggedView;
@property (nonatomic, weak) IBOutlet UIView *ellipseView;
@property (nonatomic, weak) IBOutlet UIImageView *draggedImageView;
@property (nonatomic, strong) ChooziePostDraggableHelper *draggableHelper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDragViewCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDragViewCenterX;


@end

@implementation SlideToVoteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib
{
    [self addBorderToEllipse];
    [self addBorderToDrag];
    
    
}


- (void)initDragForCell:(ChoozieTwoImagesPostCell *)cell
{
    cell.choozeDraggedView = self.draggedView;
    [self addDragForCell:cell];
}

#pragma mark - Private Methods

- (void)addBorderToEllipse
{
    self.ellipseView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.3].CGColor;
    self.ellipseView.layer.borderWidth = 1;
    self.ellipseView.backgroundColor = [UIColor clearColor];
}


- (void)addBorderToDrag
{
    self.draggedView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.3].CGColor;
    self.draggedView.layer.borderWidth = 1;
}


- (void)addDragForCell:(ChoozieTwoImagesPostCell *)cell
{
    self.draggedView.layer.cornerRadius = 22.5;
//    self.draggedView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.3];
    
    
    self.draggableHelper = [[ChooziePostDraggableHelper alloc] initInCell:cell withConstraintX:self.constraintDragViewCenterX constraintY:self.constraintDragViewCenterY];
    self.draggableHelper.pointerImageView = self.draggedImageView;
//    [self.draggedView setDraggableWithConstraintX:self.constraintDragViewCenterX constraintY:self.constraintDragViewCenterY inView:self];
//    self.draggedView.shouldStopMovingOnAxisY = YES;
}

@end
