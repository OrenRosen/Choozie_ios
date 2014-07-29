//
//  MainFeedDataSource.m
//  Choozie
//
//  Created by Oren Rosenblum on 20/07/2014.
//  Copyright (c) 2014 ROKY. All rights reserved.
//

#import "MainFeedDataSource.h"
#import "ChooziePost.h"
#import "Utils.h"
#import "Constants.h"
#import "ChoozieComment.h"
#import "ApiServices.h"
#import "ChoozieHeaderPostCell.h"


@implementation MainFeedDataSource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.feed.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooziePost *post = [self.feed objectAtIndex:indexPath.section];
    
    CGFloat heightToRet;
    if ([post.post_type integerValue] == 2) {
        // One photo
        heightToRet = 360.0;
    } else {
        // Two photos
        heightToRet = 180;
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




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ChoozieHeaderPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoozieHeaderPostCell"];
    
    ChooziePost *post = [self.feed objectAtIndex:section];
    
    // User
    [[Utils sharedInstance] setImageforView:cell.userImageButton withCachedImageFromURL:post.user.avatar];
    cell.userNameLabel.text = post.user.display_name;
    cell.userQuestion.text = post.question;
    

    return cell;
    
    
//    
//    UILabel *l = [[UILabel alloc] init];
//    l.text = @"HIIIII";
//    l.backgroundColor = [UIColor redColor];
//    
//    return l;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoozieFeedPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoozieFeedPostCell"];
    
    if (!cell.delegate) {
        cell.delegate = self;
    }
    
    ChooziePost *post = [self.feed objectAtIndex:indexPath.section];
    
    // User
//    [[Utils sharedInstance] setImageforView:cell.userImageButton withCachedImageFromURL:post.user.avatar];
//    cell.userNameLabel.text = post.user.display_name;
//    cell.userQuestionLabel.text = post.question;
    
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
    

    
    cell.votes1Label.text = [NSString stringWithFormat:@"%d votes", post.votes1.count];
    cell.votes2Label.text = [NSString stringWithFormat:@"%d votes", post.votes2.count];
    
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
    
    cell.leftVoteButton.transform = CGAffineTransformIdentity;
    cell.tag = indexPath.row;
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
    
//    [mutableActiveLinkAttributes setValue: [UIFont systemFontOfSize: 15]
//                                   forKey: (NSString *) kCTFontAttributeName];
    
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



#pragma mark - ChoozoePostCellDelegate Methods

- (void)chooziePostCell:(ChoozieFeedPostCell *)cell didVoteOnPhotoNumber:(NSInteger)number
{
    ChooziePost *post = [self.feed objectAtIndex:cell.tag];
    NSString *voteUrl = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:kVoteUrl, @"100004161394098", number, post.key]];
    
    [[ApiServices sharedInstance] callHttpGetForUrl:voteUrl withSuccessBlock:nil failureBlock:nil];
    
////    cell.constraintLeftVoteHeight.constant = 50;
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.leftVoteButton.center = cell.photo1ImageView.center;
//        cell.leftVoteButton.transform = CGAffineTransformMakeScale(5, 5);
////        [cell layoutIfNeeded];
//    }];
//    
//    [UIView animateWithDuration:0.2 delay:0.3 options:0 animations:^{
//        cell.leftVoteButton.alpha = 0;
//    } completion:nil];
}


//- (void)chooziePostCelldidClickOnUserImageView:(ChooziePostCell *)cell
//{
//    ChooziePost *post = [self.feed objectAtIndex:cell.tag];
//    [self.mainFeedDataSourceDelegate didClickToShowProfileForUser:post.user];
//}

@end
