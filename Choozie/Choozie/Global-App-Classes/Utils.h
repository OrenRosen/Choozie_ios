//
//  Utils.h
//  ChoozieApp
//
//  Created by Oren Rosenblum on 11/23/13.
//  Copyright (c) 2013 ChoozieApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTTAttributedLabel;

@interface Utils : NSObject


+ (id)sharedInstance;


- (CGFloat)getHeightForString:(NSString *)headlineString withMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight font:(UIFont *)font;

- (void)setImageforView:(id)genericView withCachedImageFromURL:(NSString *)imageUrl;

- (void)setLinkInLabel:(TTTAttributedLabel *)label withText:(NSString *)text inRange:(NSRange)range;

@end
