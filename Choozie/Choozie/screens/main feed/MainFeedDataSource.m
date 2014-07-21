//
//  MainFeedDataSource.m
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "MainFeedDataSource.h"
#import "ChooziePost.h"
#import "ChooziePostCell.h"
#import "Utils.h"
#import "Constants.h"

@implementation MainFeedDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feed.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 353;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooziePostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooziePostCell"];
    
    ChooziePost *post = [self.feed objectAtIndex:indexPath.row];
    
    // User
    [[Utils sharedInstance] setImageforView:cell.userImageView withCachedImageFromURL:post.user.avatar];
    cell.userNameLabel.text = post.user.display_name;
    cell.userQuestionLabel.text = post.question;
    
    [cell.photo1ImageView setPathToNetworkImage:[kBaseUrl stringByAppendingString:post.photo1]];
    [cell.photo2ImageView setPathToNetworkImage:[kBaseUrl stringByAppendingString:post.photo2]];
    
    
    
    return cell;
}


@end
