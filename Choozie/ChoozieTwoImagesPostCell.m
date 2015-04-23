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
@property (nonatomic, weak) IBOutlet UIView *backViewForBorder2;
@property (nonatomic, weak) IBOutlet UIView *backViewForBorder3;
@property (nonatomic, weak) IBOutlet UIView *backViewForBorder4;
@property (weak, nonatomic) IBOutlet HeroButton *circleLeft;
@property (weak, nonatomic) IBOutlet HeroButton *circleRight;

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
    
    self.backViewForBorder.layer.borderColor = [UIColor colorWithRed:209.0/255 green:209.0/255 blue:209.0/255 alpha:1.0].CGColor;
    self.backViewForBorder.layer.borderWidth = 1;
    
    self.backViewForBorder2.layer.borderColor = [UIColor colorWithRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0].CGColor;
    self.backViewForBorder2.layer.borderWidth = 1;
    
    self.backViewForBorder3.layer.borderColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0].CGColor;
    self.backViewForBorder3.layer.borderWidth = 1;
    
    self.backViewForBorder4.layer.borderColor = [UIColor colorWithRed:227.0/255 green:227.0/255 blue:227.0/255 alpha:1.0].CGColor;
    self.backViewForBorder4.layer.borderWidth = 1;
    
    self.circleLeft.layer.borderColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0].CGColor;
    self.circleRight.layer.borderColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0].CGColor;
    
    self.circleRight.colorIdle = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    self.circleRight.colorPress = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
    
    self.circleLeft.colorIdle = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    self.circleLeft.colorPress = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:0.5];
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
