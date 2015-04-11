//
//  ChoozieFeedPostCell.m
//  Choozie
//
//  Created by Oren Rosenblum on 28/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieFeedPostCell.h"
#import "UIView+Borders.h"

@implementation ChoozieFeedPostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    for (UIView *view in @[self.photo1ImageView, self.photo2ImageView, self.centerPhotoImageView]) {
        [self addBordersToView:view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.photo1ImageView prepareForReuse];
    [self.photo2ImageView prepareForReuse];
}

- (IBAction)voted1:(id)sender
{
    [self.delegate chooziePostCell:self didVoteOnPhotoNumber:1];
}

- (IBAction)voted2:(id)sender
{
    [self.delegate chooziePostCell:self didVoteOnPhotoNumber:2];
}


#pragma mak - Private Methods

- (void)addBordersToView:(UIView *)view
{
    [view addBottomBorderWithHeight:1.0 andColor:[UIColor blackColor]];
    [view addLeftBorderWithWidth:1.0 andColor:[UIColor blackColor]];
    [view addRightBorderWithWidth:1.0 andColor:[UIColor blackColor]];
}



@end
