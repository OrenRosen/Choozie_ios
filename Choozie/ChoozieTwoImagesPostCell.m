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
@property (nonatomic, weak) IBOutlet UIImageView *pointerImageView;

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
    
    [self addShadow];

    [self lalaGestures];
//
    
    
//    [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1.0];
    //[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
}

- (void)addShadow
{
        self.circleRight.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.circleRight.layer.shadowColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0].CGColor;
        self.circleRight.layer.shadowOffset = CGSizeMake(0, 5);
        self.circleRight.layer.shadowOpacity = 0.5;
        self.circleRight.layer.shadowRadius = 1;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI/2);
//    self.pointerImageView.transform = transform;

    
    
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
        [self rotateeeWithAnim:gesture];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGFloat diffX = current.x - last.x;
        CGFloat diffY = current.y - last.y;
        
        self.constraintCenterX.constant = self.constraintCenterX.constant + diffX;
        self.constraintCenterY.constant = self.constraintCenterY.constant + diffY;
        
        [self layoutIfNeeded];
        
        

        
        last = current;

        [self rotateee:gesture];
        
        
        
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        self.constraintCenterX.constant = 0;
        self.constraintCenterY.constant = 0;
        
        last = CGPointMake(0, 0);
        [UIView animateWithDuration:0.5 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI*2);
            self.pointerImageView.transform = transform;
            [self layoutIfNeeded];
        }];
    }
}


- (void)rotateee:(UIPanGestureRecognizer *)gesture
{
    static NSInteger prev = -1;
    UIView *vvv = [self getViewInRegardToRotateWithGesture];
    
    NSInteger current = (vvv == self.rightImageView) ? 1 : 2;
    if ((prev != -1) && (current != prev)) {
        [self rotateeeWithAnim:gesture];
        prev = current;
        return;
    }
    
    prev = current;
    
    CGFloat diffCeneterX = self.circleRight.superview.center.x - vvv.center.x;
    CGFloat diffCeneterY =  self.circleRight.superview.center.y - vvv.center.y;
    
    CGFloat x = atan2(diffCeneterY, diffCeneterX);
    CGFloat deg = ((x > 0 ? x : (2*M_PI + x)) * 360 / (2*M_PI)) - 90;
    CGAffineTransform transform = CGAffineTransformMakeRotation([self degreesToRadians:deg]);
    self.pointerImageView.transform = transform;
    
    [self updateShoadowOffset:deg];
    
//    NSLog(@" **** diffs - x = %f, y = %f, deg = %f", diffCeneterX, diffCeneterY, deg);
    
}


- (void)updateShoadowOffset:(CGFloat)deg
{
    NSLog(@" ****** deg = %f, x = %f", deg, [self getShadowOffsetForDeg:deg].height);
    self.circleRight.layer.shadowOffset = [self getShadowOffsetForDeg:deg];
}

- (CGSize)getShadowOffsetForDeg:(CGFloat)deg
{
    CGFloat x = 0;
    CGFloat y = 0;
    if ((deg > -90) && (deg <= 0)) {
        
        x =10.0/(90.0/(-deg));
        y = 10.0/(90.0/(90.0+deg));
        
    } else if ((deg > 0) && (deg <= 90)) {
        
        x = -10.0/(90.0/deg);
        y = 10.0/(90.0/(90.0-deg));
        
    } else if ((deg > 90) && (deg <= 180)) {
        
        y = -10.0/(90.0/(deg-90.0));
        deg = deg - 90;
        x = -10.0/(90.0/(90.0-deg));
        
    } else if ((deg > 180) && (deg <= 270)) {
        
        x =10.0/(90.0/(deg-180.0));
        y = -10.0/(90.0/(270.0-deg));
        
    }
    
    return CGSizeMake(x, y);
}

- (void)rotateeeWithAnim:(UIPanGestureRecognizer *)gesture
{
    UIView *vvv = [self getViewInRegardToRotateWithGesture];
    CGFloat diffCeneterX = self.circleRight.superview.center.x - vvv.center.x;
    CGFloat diffCeneterY =  self.circleRight.superview.center.y - vvv.center.y;
    
    CGFloat x = atan2(diffCeneterY, diffCeneterX);
    CGFloat deg = ((x > 0 ? x : (2*M_PI + x)) * 360 / (2*M_PI)) - 90;
    CGAffineTransform transform = CGAffineTransformMakeRotation([self degreesToRadians:deg]);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.pointerImageView.transform = transform;
    }];
    
    CABasicAnimation *animShadowOffset = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
    animShadowOffset.fromValue = [NSValue valueWithCGSize:self.circleRight.layer.shadowOffset];
    animShadowOffset.toValue = [NSValue valueWithCGSize:[self getShadowOffsetForDeg:deg]];
    animShadowOffset.duration = 0.1;
    [self updateShoadowOffset:deg];
    [self.layer addAnimation:animShadowOffset forKey:@"shadowOffset"];
    
    
//    NSLog(@" **** diffs - x = %f, y = %f, deg = %f", diffCeneterX, diffCeneterY, deg);
    
}


- (UIView *)getViewInRegardToRotateWithGesture
{
    if (self.constraintCenterX.constant > 0) {
        return self.rightImageView;
    } else {
        return self.leftImageView;
    }
}

- (CGFloat)degreesToRadians:(CGFloat) degrees
{
    return degrees * M_PI / 180;
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
