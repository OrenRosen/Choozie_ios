//
//  ChooziePostCell.h
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NINetworkImageView.h"
#import "TTTAttributedLabel.h"

@interface ChooziePostCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userQuestionLabel;

@property (weak, nonatomic) IBOutlet NINetworkImageView *photo1ImageView;
@property (weak, nonatomic) IBOutlet NINetworkImageView *photo2ImageView;

@property (weak, nonatomic) IBOutlet UILabel *votes1Label;
@property (weak, nonatomic) IBOutlet UILabel *votes2Label;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *comment1;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *comment2;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *comment3;

@property (weak, nonatomic) IBOutlet UIButton *seeAllCommentsButton;
@property (weak, nonatomic) IBOutlet UIButton *writeCommentButton;


@end
