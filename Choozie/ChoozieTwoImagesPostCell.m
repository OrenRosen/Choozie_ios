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
#import "FBShimmeringView.h"

@interface ChoozieTwoImagesPostCell() <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIView *backViewForBorder;
@property (nonatomic, weak) IBOutlet UIView *backViewForBorder2;
@property (nonatomic, weak) IBOutlet UIView *backViewForBorder3;
@property (nonatomic, weak) IBOutlet UIView *backViewForBorder4;
@property (weak, nonatomic) IBOutlet HeroButton *circleLeft;
@property (weak, nonatomic) IBOutlet HeroButton *circleRight;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *arrowLeft;

@property (nonatomic, strong) UIPanGestureRecognizer *dragGesture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCenterX;

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
    self.circleRight.layer.borderColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0].CGColor;
    
    self.circleRight.colorIdle = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    self.circleRight.colorPress = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
    
    self.circleLeft.colorIdle = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    self.circleLeft.colorPress = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:0.5];
    
    self.shimmeringViewLeft.contentView = self.circleLeft;
    self.shimmeringViewLeft.shimmering = YES;
    self.shimmeringViewLeft.shimmeringPauseDuration = 1;
    self.shimmeringViewLeft.shimmeringSpeed = 160;
    self.shimmeringViewLeft.shimmeringHighlightWidth = 1;
    self.shimmeringViewLeft.shimmeringHighlightLength = 1;
    self.shimmeringViewLeft.shimmeringEndFadeDuration = 100;
    self.shimmeringViewLeft.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    self.circleLeft.shimmeringColorIdle = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    self.circleLeft.shimmeringColorPress = [UIColor whiteColor];
    
    self.circleLeft.borderColorIdle = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    
    self.circleLeft.borderColorPress = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0];
    
    self.shimmeringViewLeft.shimmering = NO;

    [self lalaGestures];
//
    
    
//    [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1.0];
    //[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.circleRight];
    BOOL isInside = (CGRectContainsPoint(self.circleRight.bounds, location));
    NSLog(@" ******* insid - %d", isInside);
    return isInside;
}


- (void)lalaGestures
{
    self.dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    self.dragGesture.delegate = self;
    [self addGestureRecognizer:self.dragGesture];
}

- (void)dragged:(UIPanGestureRecognizer *)gesture
{
    static CGPoint last = {0, 0};
    CGPoint current = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        last = current;
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGFloat diffX = current.x - last.x;
        CGFloat diffY = current.y - last.y;
        
        self.constraintCenterX.constant = self.constraintCenterX.constant - diffX;
        self.constraintCenterY.constant = self.constraintCenterY.constant + diffY;
        
        [self layoutIfNeeded];
        
        last = current;
        
        NSLog(@" *** changed x = %f, y = %f **", diffX, diffY);
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        self.constraintCenterX.constant = 0;
        self.constraintCenterY.constant = 0;
        
        last = CGPointMake(0, 0);
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        }];
    }
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
