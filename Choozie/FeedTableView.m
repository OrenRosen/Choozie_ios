//
//  FeedTableView.m
//  Choozie
//
//  Created by Oren Rosenblum on 01/08/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "FeedTableView.h"
#import "MainFeedDataSource.h"


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


#pragma mark - MainFeedDataSourceSelegate Methods

- (void)didClickToShowProfileForUser:(ChoozieUser *)user
{
    if ([self.feedTableViewDelegate respondsToSelector:@selector(didClickToShowProfileForUser:)]) {
        [self.feedTableViewDelegate didClickToShowProfileForUser:user];
    }
}

@end
