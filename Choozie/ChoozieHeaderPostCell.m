//
//  ChoozieHeaderPostCell.m
//  Choozie
//
//  Created by Oren Rosenblum on 28/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieHeaderPostCell.h"
#import "Utils.h"
#import "ChooziePost.h"
#import "ChoozieUser.h"
#import "TTTAttributedLabel.h"
#import "FXBlurView.h"

@interface ChoozieHeaderPostCell() <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *backViewforBorder;

@end

@implementation ChoozieHeaderPostCell

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
    [super awakeFromNib];
    
    self.backViewforBorder.layer.borderColor = [UIColor colorWithRed:214.0/255 green:214.0/255 blue:214.0/255 alpha:1.0].CGColor;
    self.backViewforBorder.layer.borderWidth = 1;
    self.backViewforBorder.layer.cornerRadius = 3;
}

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    self.layer.shadowColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 5);
//    self.layer.shadowOpacity = 0.5;
//    self.layer.shadowRadius = 4;
//}

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    // Initialization code
////    self.blurView.dynamic = YES;
////    self.backgroundColor = [UIColor clearColor];
////    self.contentView.backgroundColor = [UIColor clearColor];
////    self.blurView.backgroundColor = [UIColor clearColor];
////    self.blurView.layer.shadowColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0].CGColor;
////    self.blurView.layer.shadowOffset = CGSizeMake(0, -1);
////    self.blurView.layer.shadowOpacity = 1;
////    self.blurView.layer.shadowRadius = 3;
////    
////    self.opaque = NO;
////    self.backgroundColor = [UIColor clearColor];
////    self.contentView.backgroundColor = [UIColor clearColor];
////    self.blurView.backgroundColor = [UIColor whiteColor];
////    self.blurView.alpha = 0.5;
////    self.blurView.tintColor = [UIColor redColor];
//    
////    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
////    UIView *toolbar = [[UIView alloc] initWithFrame:self.bounds];
////    FXBlurView *toolbar = [[FXBlurView alloc] initWithFrame:self.bounds];
////    toolbar.dynamic = NO;
////    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
////    toolbar.backgroundColor = [UIColor clearColor];
////    toolbar.barTintColor = [UIColor clearColor];
//    
////    [self insertSubview:toolbar atIndex:0];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)userImageClicked:(id)sender
{
    [self.delegate choozieHeaderPostCelldidClickOnUserImageView:self];
}


- (void)prepareHeaderForPost:(ChooziePost *)post
{
    NSString *text = [NSString stringWithFormat:@"%@ %@", post.user.display_name, post.question];
    [[Utils sharedInstance] setImageforView:self.userImageButton withCachedImageFromURL:post.user.avatar];
    NSRange range = [text rangeOfString:post.user.display_name];
    [[Utils sharedInstance] setLinkInLabel:self.userNameLabel withText:text inRange:range];
    [self.userNameLabel addLinkToAddress: @{@"user": post.user}
                  withRange: range];
//    
//    if ([post isSingleImagePostCell]) {
////        self.centerSeperator.hidden = NO;
//        self.leftSeperator.hidden = YES;
//        self.rightSeperator.hidden = YES;
//    } else {
//        self.centerSeperator.hidden = YES;
//        self.leftSeperator.hidden = NO;
//        self.rightSeperator.hidden = NO;
//    }
//    
//    
//    
//    
//    
//    
    self.centerSeperator.hidden = NO; //
    self.leftSeperator.hidden = YES;
    self.rightSeperator.hidden = YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-d H:m:s.A"];
    
    NSDate *nowDate = [NSDate date];
    NSDate *postDate = [dateFormat dateFromString:post.created_at];
    
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitSecond
                                               fromDate:postDate
                                                 toDate:nowDate options:kNilOptions];
    
    NSInteger days = [components day];
    NSInteger months = [components month];
    NSInteger year = [components year];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    NSInteger seconds = [components second];
    
    NSString *str = @"sda";
    NSInteger valueNumber = 0;
    NSString *type = @"year";
    if (months != 0) {
        
        valueNumber = months;
        type = @"month";
        
    } else if (days != 0) {
        valueNumber = days;
        type = @"day";
    } else if (hours != 0) {
        valueNumber = hours;
        type = @"hour";
    } else if (minutes != 0) {
        valueNumber = minutes;
        type = @"minute";
    } else if (seconds != 0) {
        valueNumber = seconds;
        type = @"second";
    }
    
    str = [NSString stringWithFormat:@"%ld %@", (long)valueNumber, type];
    if (valueNumber > 1) {
        str = [str stringByAppendingString:@"s"];
    }
    
    self.timeLabel.text = str;
    
}


@end
