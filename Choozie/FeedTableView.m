//
//  FeedTableView.m
//  Choozie
//
//  Created by Oren Rosenblum on 01/08/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "FeedTableView.h"
#import "ApiServices.h"


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
    [self registerNib:[UINib nibWithNibName:@"ChoozieFeedPostCell" bundle:nil] forCellReuseIdentifier:@"ChoozieFeedPostCell"];
    [self registerNib:[UINib nibWithNibName:@"ChoozieHeaderPostCell" bundle:nil] forCellReuseIdentifier:@"ChoozieHeaderPostCell"];
    
    [self addInfScroll];
}



#pragma mark - Private Methods

- (void)addInfScroll
{
    __weak FeedTableView *weakSelf = self;
    [self addInfiniteScrollingWithActionHandler:^{
        [weakSelf.feedTableViewDelegate feedTableViewDidDropForInfScroll:weakSelf];
    }];
}


@end
