//
//  UserProfileViewController.m
//  Choozie
//
//  Created by Oren Rosenblum on 26/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Utils.h"
#import "Constants.h"
#import "ApiServices.h"
#import "FeedResponse.h"
#import "MainFeedDataSource.h"
#import "FeedTableView.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet FeedTableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescriptionLabel;
@property (nonatomic, strong) MainFeedDataSource *mainFeedDataSource;

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[Utils sharedInstance] setImageforView:self.userProfileImageView withCachedImageFromURL:self.user.avatar];
    self.tableView.feedTableViewDelegate = self;
    [self getDataFromServer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - Private Methods

- (void)getDataFromServer
{
    NSString *userProfileUrl = [kFeedUrl stringByAppendingString:[NSString stringWithFormat:kUserProfileAdditionToFeedUrl, self.user.fb_uid]];
    
    [[ApiServices sharedInstance] callService:userProfileUrl withSuccessBlock:^(NSDictionary *json) {
        NSError *error = nil;
        FeedResponse *response = [MTLJSONAdapter modelOfClass:[FeedResponse class] fromJSONDictionary:json error:&error];
        
    } failureBlock:^(NSError *error) {
    }];

                     
}


#pragma mark - FeedTableViewDelegate Methods



@end
