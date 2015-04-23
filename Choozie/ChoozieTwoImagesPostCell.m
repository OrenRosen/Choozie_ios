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
#import "UIView+Borders.h"

@interface ChoozieTwoImagesPostCell()

@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIView *backViewForBorder;

@end

@implementation ChoozieTwoImagesPostCell

- (void)awakeFromNib {
    // Initialization code

    UIColor *c = [UIColor colorWithRed:214.0/255 green:214.0/255 blue:214.0/255 alpha:1.0];
//    [self.backView addBottomBorderWithHeight:1.0 andColor:c];
//    [self.backView addLeftBorderWithWidth:1.0 andColor:c];
//    [self.backView addRightBorderWithWidth:1.0 andColor:c];
    
    self.votesButtonLeft.disabledImageName = @"heart-disabled";
    self.votesButtonRight.disabledImageName = @"heart-disabled";
//    [self.votesLabelLeft setHighlightedTextColor:[UIColor redColor]];
//    [self.votesLabelRight setHighlightedTextColor:[UIColor redColor]];
    
//    self.backView.layer.shadowColor = [UIColor whiteColor].CGColor;
//    self.backView.layer.shadowColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0].CGColor;
//    self.backView.layer.shadowOffset = CGSizeMake(0, 5);
//    self.backView.layer.shadowOpacity = 0.5;
//    self.backView.layer.shadowRadius = 4;
    
    self.backViewForBorder.layer.borderColor = [UIColor colorWithRed:214.0/255 green:214.0/255 blue:214.0/255 alpha:1.0].CGColor;
    self.backViewForBorder.layer.borderWidth = 1;
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
