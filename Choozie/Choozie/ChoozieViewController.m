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

@interface ChoozieViewController ()

@property (weak, nonatomic) IBOutlet FeedTableView *feedTableView;
@property (nonatomic, weak) IBOutlet FXBlurView *topBar;

@end

@implementation ChoozieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.feedTableView.feedTableViewDelegate = self;
    
    self.feedTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:self.topBar.frame];
//    [self.topBar addSubview:tb];
    tb.barTintColor = [UIColor colorWithRed:40/255.0 green:120/255.0 blue:255/255.0 alpha:0.1];
//    [UIColor colorWithRed:139/255.0 green:166/255.0 blue:255/255.0 alpha:0.0];
    tb.alpha = 0.8;
    tb.translucent = YES;
    
    self.topBar.tintColor = [UIColor colorWithRed:40/255.0 green:120/255.0 blue:255/255.0 alpha:0.5];
    self.topBar.blurRadius = 50;
    self.topBar.backgroundColor = [UIColor clearColor];
    
    
//    tb.barTintColor = [UIColor clearColor];
//    tb.tintColor = [UIColor clearColor];
//    tb.backgroundColor = [UIColor redColor];
//    [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
//    tb.alpha = 0.5;
    
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
