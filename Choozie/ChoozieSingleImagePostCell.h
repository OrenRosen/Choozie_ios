//
//  ChoozieSingleImagePostCell.h
//  Choozie
//
//  Created by admin on 4/17/15.
//  Copyright (c) 2015 ROKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NINetworkImageView.h"
#import "ChoozieBasicPostCell.h"

@interface ChoozieSingleImagePostCell : ChoozieBasicPostCell

@property (weak, nonatomic) IBOutlet NINetworkImageView *centerImageView;

@end
