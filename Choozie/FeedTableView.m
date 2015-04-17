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

NSString *const kChoozieHeaderPostCellIdentifier = @"ChoozieHeaderPostCell";
NSString *const kChoozieSingleImageCellIdentifier = @"ChoozieSingleImagePostCell";
NSString *const kChoozieTwoImagesPostCellIdentifier = @"ChoozieTwoImagesPostCell";

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
    [self registerNib:[UINib nibWithNibName:kChoozieHeaderPostCellIdentifier bundle:nil] forCellReuseIdentifier:kChoozieHeaderPostCellIdentifier];
    [self registerNib:[UINib nibWithNibName:kChoozieTwoImagesPostCellIdentifier bundle:nil] forCellReuseIdentifier:kChoozieTwoImagesPostCellIdentifier];
    [self registerNib:[UINib nibWithNibName:kChoozieSingleImageCellIdentifier bundle:nil] forCellReuseIdentifier:kChoozieSingleImageCellIdentifier];
    
    
    
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
