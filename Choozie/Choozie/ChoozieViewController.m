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

@end

@implementation ChoozieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.feedTableView.feedTableViewDelegate = self;
    
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



@end
