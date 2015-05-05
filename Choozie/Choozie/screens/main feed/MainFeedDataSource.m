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
#import "BlurViewHeader.h"
#import "FeedTableView.h"
#import "ChoozieSingleImagePostCell.h"
#import "ChoozieTwoImagesPostCell.h"
#import "UIView+Additions.h"



@interface MainFeedDataSource() <TTTAttributedLabelDelegate>

@property (nonatomic, strong) NSMutableDictionary *userVotesToPostsDictionary;

@property (nonatomic, strong) NSMutableArray *headersStash;

@end

@implementation MainFeedDataSource


- (instancetype)init
{
    if (self = [super init]) {
        
        self.headersStash = [[NSMutableArray alloc] init];
        self.userVotesToPostsDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

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
    
    
    
    return 360.0;
    return heightToRet;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ChoozieHeaderPostCell *header = [self dequeHeader];

    if (!header.delegate) {
        header.delegate = self;
    }
    
    ChooziePost *post = [self.feed objectAtIndex:section];
    [header prepareHeaderForPost:post];

//    header.blurEnabled = NO;
    return header.realBlurView;
}


- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(BlurViewHeader *)view forSection:(NSInteger)section
{
    [self.headersStash addObject:view.header];
}


- (ChoozieHeaderPostCell *)dequeHeader
{
    ChoozieHeaderPostCell *header;
    if (self.headersStash.count == 0) {
        header = [[NSBundle mainBundle] loadNibNamed:kChoozieHeaderPostCellIdentifier owner:nil options:nil][0];
        header.realBlurView.dynamic = YES;
    } else {
        header = self.headersStash[0];
        [header prepareForReuse];
        [self.headersStash removeObject:header];
    }
    
    return header;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    [view setNeedsDisplay];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ChoozieTwoImagesPostCell class]]) {
        ChoozieTwoImagesPostCell *asd = (ChoozieTwoImagesPostCell *)cell;
//        NSLog(@"****** container = %@, stv = %@", NSStringFromCGRect(asd.slideToVoteContainer.frame), NSStringFromCGRect(asd.slideToVoteView.frame));
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}


- (UITableViewCell *)tableView:(FeedTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooziePost *post = [self.feed objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [self isPostKindOfSingleImage:post] ? [self feedTableView:tableView singleImagePostCell:post] : [self feedTableView:tableView twoImagesPostCell:post];
    
//    if (!cell.delegate) {
//        cell.delegate = self;
//    }
    
//    cell.votes1Label.text = [NSString stringWithFormat:@"%d votes", post.votes1.count];
//    cell.votes2Label.text = [NSString stringWithFormat:@"%d votes", post.votes2.count];
//
//    cell.leftVoteButton.transform = CGAffineTransformIdentity;
    cell.tag = indexPath.section;
    return cell;
}


- (ChoozieSingleImagePostCell *)feedTableView:(FeedTableView *)tableView singleImagePostCell:(ChooziePost *)post
{
    ChoozieSingleImagePostCell *cell = [tableView dequeueReusableCellWithIdentifier:kChoozieSingleImageCellIdentifier];
    [cell.centerImageView setPathToNetworkImage:[kBaseUrl stringByAppendingString:post.photo1]];
    
    return cell;
}


- (ChoozieTwoImagesPostCell *)feedTableView:(FeedTableView *)tableView twoImagesPostCell:(ChooziePost *)post
{
    ChoozieTwoImagesPostCell *cell = [tableView dequeueReusableCellWithIdentifier:kChoozieTwoImagesPostCellIdentifier];
    
    if (!cell.choozieTwoImagesCelldelegate) {
        cell.choozieTwoImagesCelldelegate = self;
    }
    
    [cell preparePost:post];
    
    NSNumber *userVote = [self.userVotesToPostsDictionary objectForKey:post.key];
//    if (!userVote) {
//        cell.votesButtonLeft.disableTouches = NO;
//        cell.votesButtonRight.disableTouches = NO;
//        cell.votesLabelLeft.hidden = YES;
//        cell.votesLabelRight.hidden = YES;
//    } else {
//        cell.votesLabelLeft.hidden = NO;
//        cell.votesLabelRight.hidden = NO;
//        
//        if ([userVote integerValue] == 1) {
//            [cell.votesButtonLeft setAsNotChosen];
//            [cell.votesButtonRight setAsChosen];
//        } else {
//            [cell.votesButtonLeft setAsChosen];
//            [cell.votesButtonRight setAsNotChosen];
//        }
//    }
    
    cell.contentView.frame = CGRectMake(cell.contentView.left+5, cell.contentView.top+5, cell.contentView.width-10, cell.contentView.height-10);
    
    return cell;
}



- (void)configureAttributedLabel:(TTTAttributedLabel *)label withComment:(ChoozieComment *)comment
{
    NSString *text = [comment getBasicCommentString];
    NSRange userNameRange = [text rangeOfString:comment.user.first_name];

    [[Utils sharedInstance] setLinkInLabel:label withText:text inRange:userNameRange];
    label.delegate = self;
    [label addLinkToAddress: @{@"user": comment.user}
                  withRange: userNameRange];
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


- (void)choozieHeaderPostCelldidClickOnUserImageView:(ChoozieHeaderPostCell *)cell
{
    ChooziePost *post = [self.feed objectAtIndex:cell.tag];
    [self.mainFeedDataSourceDelegate didClickToShowProfileForUser:post.user];
}



#pragma mark - Private Methods


- (BOOL)isPostKindOfSingleImage:(ChooziePost *)post
{
    return ([post.post_type integerValue] == 2);
}


#pragma mark - TableViewScrollView Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.mainFeedDataSourceDelegate respondsToSelector:@selector(feedTableviewScrollViewDidScroll:)]) {
        [self.mainFeedDataSourceDelegate feedTableviewScrollViewDidScroll:scrollView];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.mainFeedDataSourceDelegate respondsToSelector:@selector(feedTableScrollViewDidEndDragging:willDecelerate:)]) {
        [self.mainFeedDataSourceDelegate feedTableScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.mainFeedDataSourceDelegate respondsToSelector:@selector(feedTableScrollViewDidEndDecelerating:)]) {
        [self.mainFeedDataSourceDelegate feedTableScrollViewDidEndDecelerating:scrollView];
    }
}


#pragma mark - ChoozieTwoImagesPostCellDelegate Methods

- (void)votedLeftInChoozieCell:(ChoozieTwoImagesPostCell *)cell
{
    [self showLeftVotesForCell:cell];
}


- (void)votedRightInChoozieCell:(ChoozieTwoImagesPostCell *)cell
{
    [self showRightVotesForCell:cell];
}


- (void)showLeftVotesForCell:(ChoozieTwoImagesPostCell *)cell
{
    ChooziePost *post = [self getPostForCell:cell];
    if ([self.userVotesToPostsDictionary objectForKey:post.key]) {
        return;
    } else {
        [self.userVotesToPostsDictionary setValue:[NSNumber numberWithInteger:2] forKey:post.key];
        [cell.votesLabelLeft fadeInWithDuration:0.3];
        [cell.votesLabelRight fadeInWithDuration:0.3];
//        [cell.votesButtonRight setAsNotChosen];
//        [cell.votesButtonLeft setAsChosen];
    }
}


- (void)showRightVotesForCell:(ChoozieTwoImagesPostCell *)cell
{
    ChooziePost *post = [self getPostForCell:cell];
    if ([self.userVotesToPostsDictionary objectForKey:post.key]) {
        return;
    } else {
        [self.userVotesToPostsDictionary setValue:[NSNumber numberWithInteger:1] forKey:post.key];
        [cell.votesLabelRight fadeInWithDuration:0.3];
        [cell.votesLabelLeft fadeInWithDuration:0.3];
//        [cell.votesButtonRight setAsChosen];
//        [cell.votesButtonLeft setAsNotChosen];
    }
}


- (ChooziePost *)getPostForCell:(ChoozieTwoImagesPostCell *)cell
{
    return [self.feed objectAtIndex:cell.tag];
}


@end
