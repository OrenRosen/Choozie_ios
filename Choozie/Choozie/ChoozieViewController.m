//
//  ChoozieViewController.m
//  Choozie
//
//  Created by Oren Rosenblum on 19/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "ChoozieViewController.h"
#import "ApiServices.h"
#import "Constants.h"
#import "FeedResponse.h"
#import "UserProfileViewController.h"
#import "FXBlurView.h"
#import "MainFeedDataSource.h"

@interface ChoozieViewController () <MainFeedDataSourceDelegate>

@property (weak, nonatomic) IBOutlet FeedTableView *feedTableView;
@property (nonatomic, weak) IBOutlet FXBlurView *topBar;
@property (nonatomic, strong) MainFeedDataSource *mainFeedDataSource;
@property (nonatomic, strong) FeedResponse *feedResponse;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopBarToTop;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation ChoozieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.feedTableView.feedTableViewDelegate = self;
    
    self.feedTableView.delaysContentTouches = NO;
    
    self.feedTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:self.topBar.frame];
    tb.barTintColor = [UIColor colorWithRed:40/255.0 green:120/255.0 blue:255/255.0 alpha:0.1];
    tb.alpha = 0.8;
    tb.translucent = YES;
    
    self.topBar.tintColor = [UIColor colorWithRed:40/255.0 green:120/255.0 blue:255/255.0 alpha:0.5];
    self.topBar.blurRadius = 50;
    self.topBar.backgroundColor = [UIColor clearColor];
    
    self.mainFeedDataSource = [[MainFeedDataSource alloc] init];
    self.mainFeedDataSource.mainFeedDataSourceDelegate = self;
    self.feedTableView.delegate = self.mainFeedDataSource;
    self.feedTableView.dataSource = self.mainFeedDataSource;
    
    [self getDataFromServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getDataFromServer
{
    [[ApiServices sharedInstance] callService:kFeedUrl withSuccessBlock:^(NSDictionary *json) {
        
        NSError *error = nil;
        self.feedResponse = [MTLJSONAdapter modelOfClass:[FeedResponse class] fromJSONDictionary:json error:&error];
        self.mainFeedDataSource.feed = self.feedResponse.feed;
        [self.feedTableView reloadData];
    } failureBlock:^(NSError *error) {
    }];}


#pragma mark - FeedTableViewDelegate Methods

- (void)feedTableViewDidDropForInfScroll:(FeedTableView *)feedTableView
{
    NSString *feedUrl = [self getFeedUrlForInfScrollWithCurrentCursor];
    [[ApiServices sharedInstance] callService:feedUrl withSuccessBlock:^(NSDictionary *json) {
        
        
        NSError *error = nil;
        FeedResponse *response = [MTLJSONAdapter modelOfClass:[FeedResponse class] fromJSONDictionary:json error:&error];
        
        if (response.feed.count == 0) {
            return;
        }
        
        [self updateNewFeedResponse:response];
        self.mainFeedDataSource.feed = self.feedResponse.feed;
        [feedTableView reloadData];
        [[feedTableView infiniteScrollingView] stopAnimating];
        
    } failureBlock:^(NSError *error) {
        
        [[feedTableView infiniteScrollingView] stopAnimating];
    }];
}




#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserProfileSegue"]) {
        UserProfileViewController *userProfileViewController = segue.destinationViewController;
        
        userProfileViewController.user = (ChoozieUser *)sender;
    }
}


#pragma mark - MainFeedDataSourceDelegate Methods

- (void)didClickToShowProfileForUser:(ChoozieUser *)user
{
    [self performSegueWithIdentifier:@"UserProfileSegue" sender:user];
}


- (void)feedTableviewScrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastY = -1;
    
    if (lastY == -1) {
        lastY = scrollView.contentOffset.y;
        return;
    }
    
    CGFloat currentY = scrollView.contentOffset.y;
    CGFloat difference = floorf(currentY - lastY);
    
//    NSLog(@" **** lastY = %f, currentY = %f", lastY, currentY);
    
    lastY = currentY;
    
    if ((difference > 0) && (scrollView.contentOffset.y <= -40)) {
        lastY = -40;
        return;
    }
    
    static NSInteger numberOfNum = 0;
    
    NSLog(@" **** numbb %f",  scrollView.contentOffset.y);
    if ((difference < 0) && ![self isTopBarInMiddle] && (scrollView.contentOffset.y > 0)) {
        numberOfNum++;
        
        if (numberOfNum < 30) {
//            numberOfNum = 0;
            return;
        }
    } else if (difference > 0) {
        numberOfNum = 0;
    }
    
//    if ((difference > -10) && (difference < 0) && ![self isTopBarInMiddle]) {
//        return;
//    }
    
//    NSLog(@" *** diff %f", difference);
    
    CGFloat newConstant = self.constraintTopBarToTop.constant - difference;
    
    newConstant = MIN(newConstant, 0);
    newConstant = MAX(newConstant, -40);
    
    static BOOL setOne = NO;
    static BOOL setTwo = NO;

    if (setOne && !setTwo) {
        return;
    }
    
    self.constraintTopBarToTop.constant = newConstant;
    
    [self.view layoutIfNeeded];
    
    setOne = YES;
    
    self.feedTableView.contentInset = UIEdgeInsetsMake(newConstant+40, 0, 0, 0);
    
    setTwo = YES;
    
    setOne = NO;
    setTwo = NO;
    
    CGFloat shrinkValue = 1 -  (-newConstant / 40.0);
    self.logoImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, shrinkValue, shrinkValue);
    self.logoImageView.alpha = shrinkValue;
    
}


- (void)feedTableScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        
        CGFloat constant = self.constraintTopBarToTop.constant;
        if (constant < 0 && constant >= -20) {
            
            
            self.constraintTopBarToTop.constant = 0;
            CGFloat shrinkValue = 1 -  (-self.constraintTopBarToTop.constant / 40.0);
            [UIView animateWithDuration:0.2 animations:^{
                [self.view layoutIfNeeded];
                self.feedTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
                self.logoImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, shrinkValue, shrinkValue);
                self.logoImageView.alpha = shrinkValue;
            }];
            
        } else if (constant < -20 && constant > -40) {
            
            
            self.constraintTopBarToTop.constant = -40;
            CGFloat shrinkValue = 1 -  (-self.constraintTopBarToTop.constant / 40.0);
            [UIView animateWithDuration:0.2 animations:^{
                [self.view layoutIfNeeded];
                self.feedTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                self.logoImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, shrinkValue, shrinkValue);
                self.logoImageView.alpha = shrinkValue;
            }];
            
        }
    }
}


#pragma mark - Private Methods

- (void)updateNewFeedResponse:(FeedResponse *)newFeedResponse
{
    self.feedResponse.cursor = newFeedResponse.cursor;
    self.feedResponse.feed = [self getFeedWithNewResponse:newFeedResponse];
}


- (NSArray *)getFeedWithNewResponse:(FeedResponse *)newFeedResponse
{
    NSMutableArray *newFeed = [self.feedResponse.feed mutableCopy];
    [newFeed addObjectsFromArray:newFeedResponse.feed];
    return [newFeed copy];
}


- (NSString *)getFeedUrlForInfScrollWithCurrentCursor
{
    return [kFeedUrl stringByAppendingString:[NSString stringWithFormat:kCurserAdditionToFeedUrl, self.feedResponse.cursor]];
}


- (BOOL)isTopBarShown
{
    return (self.constraintTopBarToTop.constant > -40);
}


- (BOOL)isTopBarInMiddle
{
    return ([self isTopBarShown] && ![self isTopBarFullUnshown]);
}


- (BOOL)isTopBarFullyShown
{
    return (self.constraintTopBarToTop.constant >= 0);
}


- (BOOL)isTopBarFullUnshown
{
    return (self.constraintTopBarToTop.constant <= -40);
}


@end
