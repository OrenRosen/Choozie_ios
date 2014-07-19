//
//  UIImage+MakeThumbnail.h
//  FTBpro-Mobile
//
//  Created by Oded Regev on 1/16/13.
//  Copyright (c) 2013 FTBpro. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 This category adds methods to the UIKit framework's `UIImageView` class. The methods in this category provide support resizing image into thumbnail size
 */
@interface UIImage (MakeThumbnail)

- (UIImage *) makeThumbnailOfSize:(CGSize)size;

@end
