//
//  ChoozieTwoImagesPostCell.h
//  Choozie
//
//  Created by admin on 4/17/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NINetworkImageView.h"
#import "ChoozieBasicPostCell.h"


@class MLPSpotlight;
@class ChoozieTwoImagesPostCell;
@class ChooziePost;
@class HeroButton;
@class SlideToVoteView;

@protocol ChoozieTwoImagesPostCellDelegate <NSObject>

- (void)votedLeftInChoozieCell:(ChoozieTwoImagesPostCell *)cell;
- (void)votedRightInChoozieCell:(ChoozieTwoImagesPostCell *)cell;

@end

@interface ChoozieTwoImagesPostCell : ChoozieBasicPostCell

@property (weak, nonatomic) IBOutlet NINetworkImageView *leftImageView;
@property (weak, nonatomic) IBOutlet NINetworkImageView *rightImageView;

@property (weak, nonatomic) IBOutlet HeroButton *votesButtonRight;
@property (weak, nonatomic) IBOutlet HeroButton *votesButtonLeft;
@property (weak, nonatomic) IBOutlet UILabel *votesLabelLeft;

@property (weak, nonatomic) IBOutlet UILabel *votesLabelRight;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageRight;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageLeft;

@property (nonatomic, strong) SlideToVoteView *slideToVoteView;
@property (nonatomic, weak) IBOutlet UIView *slideToVoteContainer;

@property (nonatomic, strong) MLPSpotlight *spotlightLeft;
@property (nonatomic, strong) MLPSpotlight *spotlightRight;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintWidthImageRight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintWidthImageLeft;

@property (nonatomic, weak) id<ChoozieTwoImagesPostCellDelegate> choozieTwoImagesCelldelegate;

// For dragging
@property (nonatomic, weak) IBOutlet UIImageView *pointerImageView;
@property (weak, nonatomic) IBOutlet HeroButton *circleRight;
@property (weak, nonatomic) IBOutlet UIView *choozeDraggedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageLeftLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageLeftRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageLeftTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageRightRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageRightTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageRightLeft;


- (void)preparePost:(ChooziePost *)post;

@end
