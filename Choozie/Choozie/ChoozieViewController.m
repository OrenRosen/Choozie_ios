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

@interface ChoozieViewController ()

@property (nonatomic, strong) MainFeedDataSource *mainFeedDataSource;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;

@end

@implementation ChoozieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainFeedDataSource = [[MainFeedDataSource alloc] init];
    self.mainFeedDataSource.mainFeedDataSourceDelegate = self;
    self.feedTableView.delegate = self.mainFeedDataSource;
    self.feedTableView.dataSource = self.mainFeedDataSource;
    
    [self.feedTableView registerNib:[UINib nibWithNibName:@"ChoozieFeedPostCell" bundle:nil] forCellReuseIdentifier:@"ChoozieFeedPostCell"];
    [self.feedTableView registerNib:[UINib nibWithNibName:@"ChoozieHeaderPostCell" bundle:nil] forCellReuseIdentifier:@"ChoozieHeaderPostCell"];
    
    [self getDataFromServer];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getDataFromServer
{
    
    [[ApiServices sharedInstance] callService:kFeedUrl withSuccessBlock:^(NSDictionary *json) {
        FeedResponse *response = [[FeedResponse alloc] initWithDictionary:json];
        
        self.mainFeedDataSource.feed = response.feed;
        [self.feedTableView reloadData];
        
        NSLog(@"Success");
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed;");
    }];
    
    
}


#pragma mark - MainFeedDataSourceDelegate Methods

- (void)didClickToShowProfileForUser:(ChoozieUser *)user
{
    [self performSegueWithIdentifier:@"UserProfileSegue" sender:user];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserProfileSegue"]) {
        UserProfileViewController *userProfileViewController = segue.destinationViewController;
        
        userProfileViewController.user = (ChoozieUser *)sender;
    }
}

@end
