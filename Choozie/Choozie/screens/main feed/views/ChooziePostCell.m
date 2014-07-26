//
//  ChooziePostCell.m
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChooziePostCell.h"

@implementation ChooziePostCell

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


@end
