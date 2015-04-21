//
//  ChoozieTwoImagesPostCell.m
//  Choozie
//
//  Created by admin on 4/17/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "ChoozieTwoImagesPostCell.h"
#import "ChooziePost.h"
#import "Constants.h"

@interface ChoozieTwoImagesPostCell()



@end

@implementation ChoozieTwoImagesPostCell

- (void)awakeFromNib {
    // Initialization code
    
    [self addBorderToView:self.leftImageView];
    [self addBorderToView:self.rightImageView];
    self.votesButtonLeft.disabledImageName = @"heart-disabled";
    self.votesButtonRight.disabledImageName = @"heart-disabled";
//    [self.votesLabelLeft setHighlightedTextColor:[UIColor redColor]];
//    [self.votesLabelRight setHighlightedTextColor:[UIColor redColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)preparePost:(ChooziePost *)post
{
    [self.rightImageView setPathToNetworkImage:[kBaseUrl stringByAppendingString:post.photo1]];
    [self.leftImageView setPathToNetworkImage:[kBaseUrl stringByAppendingString:post.photo2]];
    
    NSInteger votesLeft = post.votes1.count;
    NSInteger votesRight = post.votes2.count;
    
    NSString *votesLeftString = [NSString stringWithFormat:@"%ld vote", (long)votesLeft];
    NSString *votesRightString = [NSString stringWithFormat:@"%ld vote", (long)votesRight];

    if (votesLeft > 1) {
        votesLeftString = [votesLeftString stringByAppendingString:@"s"];
    }
    
    if (votesRight > 1) {
        votesRightString = [votesRightString stringByAppendingString:@"s"];
    }
    
    self.votesLabelLeft.text = votesLeftString;
    self.votesLabelRight.text = votesRightString;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.votesButtonRight.disableTouches = NO;
    self.votesButtonLeft.disableTouches = NO;
}



- (IBAction)buttonVoteLeftPressed:(id)sender
{
    [self.choozieTwoImagesCelldelegate votedLeftInChoozieCell:self];
}


- (IBAction)buttonVoteRightPressed:(id)sender
{
    [self.choozieTwoImagesCelldelegate votedRightInChoozieCell:self];
}





@end
