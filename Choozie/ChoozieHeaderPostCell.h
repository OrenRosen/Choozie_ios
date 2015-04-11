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

@protocol ChoozieHeaderPostCellDelegate <NSObject>

- (void)choozieHeaderPostCelldidClickOnUserImageView:(ChoozieHeaderPostCell *)cell;

@end


@interface ChoozieHeaderPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userQuestion;

@property (nonatomic, strong) id<ChoozieHeaderPostCellDelegate> delegate;

- (void)prepareHeaderForPost:(ChooziePost *)post;


@end
