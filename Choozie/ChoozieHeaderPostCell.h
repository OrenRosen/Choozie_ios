//
//  ChoozieHeaderPostCell.h
//  Choozie
//
//  Created by Oren Rosenblum on 28/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ChoozieHeaderPostCell;
@class ChooziePost;
@class TTTAttributedLabel;



@class BlurViewHeader;
@protocol ChoozieHeaderPostCellDelegate <NSObject>

- (void)choozieHeaderPostCelldidClickOnUserImageView:(ChoozieHeaderPostCell *)cell;

@end


@interface ChoozieHeaderPostCell : UIView

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet BlurViewHeader *blurView;
@property (nonatomic, strong) BlurViewHeader *realBlurView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet UIView *leftSeperator;
@property (nonatomic, weak) IBOutlet UIView *rightSeperator;
@property (nonatomic, weak) IBOutlet UIView *centerSeperator;

@property (weak, nonatomic) IBOutlet UILabel *userQuestion;

@property (nonatomic, strong) id<ChoozieHeaderPostCellDelegate> delegate;

- (void)prepareHeaderForPost:(ChooziePost *)post;
- (void)prepareForReuse;



@end
