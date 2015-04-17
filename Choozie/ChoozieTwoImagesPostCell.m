//
//  ChoozieTwoImagesPostCell.m
//  Choozie
//
//  Created by admin on 4/17/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "ChoozieTwoImagesPostCell.h"

@implementation ChoozieTwoImagesPostCell

- (void)awakeFromNib {
    // Initialization code
    
    [self addBorderToView:self.leftImageView];
    [self addBorderToView:self.rightImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
