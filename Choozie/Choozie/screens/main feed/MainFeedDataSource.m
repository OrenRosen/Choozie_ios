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
    ChooziePost *post = [self.feed objectAtIndex:indexPath.row];
    
    CGFloat heightToRet;
    if ([post.post_type integerValue] == 2) {
        // One photo
        heightToRet = 390.0;
    } else {
        // Two photos
        heightToRet = 234.0;
    }
    
    if (post.comments.count == 0) {
        heightToRet += 40;
    }
    
    if (post.comments.count >= 1) {
        heightToRet += [self getHeightForComment:post.comments[0]];
    }
    
    if (post.comments.count >= 2) {
        heightToRet += [self getHeightForComment:post.comments[1]];
    }
    
    if (post.comments.count >= 3) {
        heightToRet += [self getHeightForComment:post.comments[2]];
    }
    
    if (post.comments.count >= 4) {
        heightToRet += 20;
    }
    
    
    
    
    return heightToRet;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooziePostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooziePostCell"];
    
    ChooziePost *post = [self.feed objectAtIndex:indexPath.row];
    
    // User
    [[Utils sharedInstance] setImageforView:cell.userImageView withCachedImageFromURL:post.user.avatar];
    cell.userNameLabel.text = post.user.display_name;
    cell.userQuestionLabel.text = post.question;
    
    if ([post.post_type integerValue] == 2) {
        // One photo
        cell.centerPhotoImageView.hidden = NO;
        cell.photo1ImageView.hidden = YES;
        cell.photo2ImageView.hidden = YES;
        cell.constraintVoteLeftToCenterImageView.priority = 750;
        cell.constraintVoteLeftToLeftImageView.priority = 250;
        [cell.centerPhotoImageView setPathToNetworkImage:[kBaseUrl stringByAppendingString:post.photo1]];
    } else {
        // Two photos
        cell.centerPhotoImageView.hidden = YES;
        cell.photo1ImageView.hidden = NO;
        cell.photo2ImageView.hidden = NO;
        cell.constraintVoteLeftToCenterImageView.priority = 250;
        cell.constraintVoteLeftToLeftImageView.priority = 750;
        [cell.photo1ImageView setPathToNetworkImage:[kBaseUrl stringByAppendingString:post.photo1]];
        [cell.photo2ImageView setPathToNetworkImage:[kBaseUrl stringByAppendingString:post.photo2]];
    }
    

    
    cell.votes1Label.text = [NSString stringWithFormat:@"%d", post.votes1.count];
    cell.votes2Label.text = [NSString stringWithFormat:@"%d", post.votes2.count];
    
    cell.comment1.hidden = YES;
    cell.comment2.hidden = YES;
    cell.comment3.hidden = YES;
    cell.seeAllCommentsButton.hidden = YES;
    cell.writeCommentButton.hidden = (post.comments.count > 0);
    
    if (post.comments.count >= 1) {
        cell.comment1.hidden = NO;
        [self configureAttributedLabel:cell.comment1 withComment:[post.comments objectAtIndex:0]];
    }
    
    if (post.comments.count >= 2) {
        cell.comment2.hidden = NO;
        [self configureAttributedLabel:cell.comment2 withComment:[post.comments objectAtIndex:1]];
    }
    
    if (post.comments.count >= 3) {
        cell.comment3.hidden = NO;
        [self configureAttributedLabel:cell.comment3 withComment:[post.comments objectAtIndex:2]];
    }
    
    if (post.comments.count >= 4) {
        cell.seeAllCommentsButton.hidden = NO;
    }
    
    
    
    return cell;
}




- (void)configureAttributedLabel:(TTTAttributedLabel *)label withComment:(ChoozieComment *)comment
{
    NSString *text = [comment getBasicCommentString];
    
    NSRange userNameRange = [text rangeOfString: comment.user.first_name];
    
    label.linkAttributes = [self _getLinkAttributes];
    label.activeLinkAttributes = [self _getActiveLinkAttributes];
    label.delegate = self;
    
    [label setText: text];
    
    [label addLinkToAddress: @{@"user": comment.user}
                  withRange: userNameRange];
}


- (NSDictionary *)_getLinkAttributes
{
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    
    [mutableActiveLinkAttributes setValue: [UIFont boldSystemFontOfSize: 15]
                                   forKey: (NSString *) kCTFontAttributeName];
    
    [mutableActiveLinkAttributes setValue: [UIColor blueColor]
                                   forKey: (NSString *) kCTForegroundColorAttributeName];
    
    [mutableActiveLinkAttributes setValue: [NSNumber numberWithBool: NO]
                                   forKey: (NSString *) kCTUnderlineStyleAttributeName];
    
    return [NSDictionary dictionaryWithDictionary: mutableActiveLinkAttributes];
}

- (NSDictionary *)_getActiveLinkAttributes
{
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    
    [mutableActiveLinkAttributes setValue: [UIColor purpleColor]
                                   forKey: (NSString *) kCTForegroundColorAttributeName];
    
    [mutableActiveLinkAttributes setValue: [NSNumber numberWithBool: NO]
                                   forKey: (NSString *) kCTUnderlineStyleAttributeName];
    
    return [NSDictionary dictionaryWithDictionary: mutableActiveLinkAttributes];
}



- (CGFloat)getHeightForComment:(ChoozieComment *)comment
{
    CGFloat maxWidth = 273;
    
    CGFloat height = [[Utils sharedInstance] getHeightForString:[comment getBasicCommentString] withMaxWidth:maxWidth maxHeight:100 font:[UIFont systemFontOfSize:15.0]];
    
    return height;
}


#pragma mark - TTTAttributedLabelDelegate

- (void) attributedLabel: (TTTAttributedLabel *)label
didSelectLinkWithAddress: (NSDictionary *)addressComponents
{
    ChoozieUser *user = [addressComponents objectForKey:@"user"];
}



@end
