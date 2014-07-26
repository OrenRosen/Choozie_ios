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
#import "ChoozieComment.h"

@implementation MainFeedDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feed.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 380;
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
    
    cell.votes1Label.text = [NSString stringWithFormat:@"%d", post.votes1.count];
    cell.votes2Label.text = [NSString stringWithFormat:@"%d", post.votes2.count];
    
    cell.commentName1.hidden = YES;
    cell.commentName2.hidden = YES;
    cell.commentName3.hidden = YES;
    cell.commentTest1.hidden = YES;
    cell.commentTest2.hidden = YES;
    cell.commentTest3.hidden = YES;
    cell.seeAllCommentsButton.hidden = YES;
    
    if (post.comments.count >= 1) {
        cell.commentName1.hidden = NO;
        cell.commentTest1.hidden = NO;
        
        ChoozieComment *comment = [post.comments objectAtIndex:0];
        cell.commentName1.titleLabel.text = comment.user.first_name;
        cell.commentTest1.text = comment.text;
    }
    
    if (post.comments.count >= 2) {
        cell.commentName2.hidden = NO;
        cell.commentTest2.hidden = NO;
        
        ChoozieComment *comment = [post.comments objectAtIndex:1];
        cell.commentName2.titleLabel.text = comment.user.first_name;
        cell.commentTest2.text = comment.text;
    }
    
    if (post.comments.count >= 3) {
        cell.commentName3.hidden = NO;
        cell.commentTest3.hidden = NO;
        
        ChoozieComment *comment = [post.comments objectAtIndex:2];
        cell.commentName3.titleLabel.text = comment.user.first_name;
        cell.commentTest3.text = comment.text;
    }
    
    if (post.comments.count >= 4) {
        cell.seeAllCommentsButton.hidden = NO;
    }
    
    
    
    return cell;
}


@end
