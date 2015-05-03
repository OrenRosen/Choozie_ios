//
//  Utils.h
//  ChoozieApp
//
//  Created by Oren Rosenblum on 11/23/13.
//  Copyright (c) 2013 ChoozieApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChoozieMantle;
@class TTTAttributedLabel;

@interface Utils : NSObject


+ (id)sharedInstance;


- (CGFloat)getHeightForString:(NSString *)headlineString withMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight font:(UIFont *)font;

- (void)setImageforView:(id)genericView withCachedImageFromURL:(NSString *)imageUrl;

- (void)setLinkInLabel:(TTTAttributedLabel *)label withText:(NSString *)text inRange:(NSRange)range;

- (void) getImagewithCachedImageFromURL:(NSString *)imageUrl withCompletion:(void (^)(UIImage *image))onComplete;

- (void) saveJsonObjectToCache:(NSString *)fileName rootObject:(ChoozieMantle *)rootObject;

- (id) getJsonObjectFromCache:(NSString *)fileName type:(Class)type;



@end
