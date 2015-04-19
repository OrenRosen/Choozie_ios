//
//  ChoozieBasicPostCell.m
//  Choozie
//
//  Created by admin on 4/17/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import "ChoozieBasicPostCell.h"
#import "UIView+Borders.h"

@implementation ChoozieBasicPostCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addBorderToView:(UIView *)view
{
    [view addBottomBorderWithHeight:1.0 andColor:[UIColor blackColor]];
    [view addLeftBorderWithWidth:1.0 andColor:[UIColor blackColor]];
    [view addRightBorderWithWidth:1.0 andColor:[UIColor blackColor]];
    [view addTopBorderWithHeight:1.0 andColor:[UIColor blackColor]];
}

@end
