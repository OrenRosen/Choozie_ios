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


@class ChoozieTwoImagesPostCell;
@class ChooziePost;
@class HeroButton;
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

@property (nonatomic, weak) id<ChoozieTwoImagesPostCellDelegate> choozieTwoImagesCelldelegate;

// For dragging
@property (nonatomic, weak) IBOutlet UIImageView *pointerImageView;
@property (weak, nonatomic) IBOutlet HeroButton *circleRight;



- (void)preparePost:(ChooziePost *)post;

@end
