//
//  HeroButton.h
//  Choozie
//
//  Created by admin on 4/20/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroButton : UIButton

@property (nonatomic, weak) IBOutlet UIImageView *heroImageView;
@property (nonatomic, weak) IBOutlet UILabel *heroLabel;

@property (nonatomic) NSString *disabledImageName;
@property (nonatomic) NSString *chosenImageName;

@property (nonatomic) BOOL disableTouches;

- (void)setAsChosen;
- (void)setAsNotChosen;


@end
