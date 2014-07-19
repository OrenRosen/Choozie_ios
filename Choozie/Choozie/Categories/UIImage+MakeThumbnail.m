//
//  UIImage+MakeThumbnail.m
//  FTBpro-Mobile
//
//  Created by Oded Regev on 1/16/13.
//  Copyright (c) 2013 FTBpro. All rights reserved.
//

#import "UIImage+MakeThumbnail.h"

@implementation UIImage (MakeThumbnail)

- (UIImage *) makeThumbnailOfSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    // draw scaled image into thumbnail context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    return newThumbnail;
}


@end
