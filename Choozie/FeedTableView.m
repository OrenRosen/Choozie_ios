//
//  FeedTableView.m
//  Choozie
//
//  Created by Oren Rosenblum on 01/08/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "FeedTableView.h"
#import "MainFeedDataSource.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ApiServices.h"


@interface FeedTableView()

@property (nonatomic, strong) MainFeedDataSource *mainFeedDataSource;

@end



@implementation FeedTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)awakeFromNib
{
    self.mainFeedDataSource = [[MainFeedDataSource alloc] init];
    self.mainFeedDataSource.mainFeedDataSourceDelegate = self;
    self.delegate = self.mainFeedDataSource;
    self.dataSource = self.mainFeedDataSource;
    
    [self registerNib:[UINib nibWithNibName:@"ChoozieFeedPostCell" bundle:nil] forCellReuseIdentifier:@"ChoozieFeedPostCell"];
    [self registerNib:[UINib nibWithNibName:@"ChoozieHeaderPostCell" bundle:nil] forCellReuseIdentifier:@"ChoozieHeaderPostCell"];
    
    [self addInfScroll];
}



- (void)setFeedResponse:(FeedResponse *)feedResponse
{
    _feedResponse = feedResponse;
    self.mainFeedDataSource.feed = feedResponse.feed;
    [self reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark - Private Methods

- (void)addInfScroll
{
    __weak FeedTableView *weakSelf = self;
    [self addInfiniteScrollingWithActionHandler:^{
        
        
        NSString *feedUrl = [weakSelf.feedTableViewDelegate getFeedUrlForInfScrollWithCurrentCursor:weakSelf.feedResponse.cursor];
        [[ApiServices sharedInstance] callService:feedUrl withSuccessBlock:^(NSDictionary *json) {
            
            
            NSError *error = nil;
            FeedResponse *response = [MTLJSONAdapter modelOfClass:[FeedResponse class] fromJSONDictionary:json error:&error];
            
            if (response.feed.count == 0) {
                return;
            }
            
            weakSelf.feedResponse.cursor = response.cursor;
            NSInteger before = weakSelf.feedResponse.feed.count;
            NSMutableArray *feed = [weakSelf.feedResponse.feed mutableCopy];
            [feed addObjectsFromArray:response.feed];
            weakSelf.feedResponse.feed = [feed copy];
            
            weakSelf.mainFeedDataSource.feed = weakSelf.feedResponse.feed;
            
            [weakSelf reloadData];
//            
//            [weakSelf beginUpdates];
//            
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, weakSelf.feedResponse.feed.count - before)];
//            
//            [weakSelf insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//            
//            [weakSelf endUpdates];
            
            [[weakSelf infiniteScrollingView] stopAnimating];
            
            
        } failureBlock:^(NSError *error) {
            
        }];
        
        
    }];

}



#pragma mark - MainFeedDataSourceSelegate Methods

- (void)didClickToShowProfileForUser:(ChoozieUser *)user
{
    if ([self.feedTableViewDelegate respondsToSelector:@selector(didClickToShowProfileForUser:)]) {
        [self.feedTableViewDelegate didClickToShowProfileForUser:user];
    }
}

@end
