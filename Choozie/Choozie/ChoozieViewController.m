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

@property (weak, nonatomic) IBOutlet FeedTableView *feedTableView;

@end

@implementation ChoozieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.feedTableView.feedTableViewDelegate = self;
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
        
        NSError *error = nil;
        FeedResponse *response = [MTLJSONAdapter modelOfClass:[FeedResponse class] fromJSONDictionary:json error:&error];
        
        self.feedTableView.feedResponse = response;
    } failureBlock:^(NSError *error) {
    }];
    
    
}


#pragma mark - FeedTableViewDelegate Methods

- (void)didClickToShowProfileForUser:(ChoozieUser *)user
{
    [self performSegueWithIdentifier:@"UserProfileSegue" sender:user];
}



- (NSString *)getFeedUrlForInfScrollWithCurrentCursor:(NSString *)curser
{
    return [kFeedUrl stringByAppendingString:[NSString stringWithFormat:kCurserAdditionToFeedUrl, curser]];
}







#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserProfileSegue"]) {
        UserProfileViewController *userProfileViewController = segue.destinationViewController;
        
        userProfileViewController.user = (ChoozieUser *)sender;
    }
}



@end
