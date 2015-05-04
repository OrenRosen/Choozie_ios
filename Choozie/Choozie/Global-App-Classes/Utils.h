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




-(NSArray *)setConstarintsForCenterInParent:(UIView *)view;

- (NSDictionary *)setConstraintsForItem:(UIView *)item withDistance:(CGFloat)distance underItem:(id)itemOnTop withHeight:(CGFloat)height inView:(UIView *)view;

- (NSDictionary *)setConstraintsForItem:(UIView *)item withDistance:(CGFloat)distanceFromView fromTopOfItem:(id)fromItem withHeight:(CGFloat)height inView:(UIView *)view;

- (NSDictionary *)setConstraintsForItem:(UIView *)item withDistance:(CGFloat)distance toBottomOf:(id)itemOnBottom withHeight:(CGFloat)height inView:(UIView *)view;

- (NSDictionary *)setConstraintsForItem:(UIView *)item withDistance:(CGFloat)distanceFromView ToFillItem:(id)itemToFill inView:(UIView *)view;

// Set constraints for UILabel, i.e - only for x and y position (without width and height)
- (void)setConstraintsForLabel:(UILabel *)label withDistance:(CGFloat)distanceFromView fromTopOfItem:(id)fromItem inView:(UIView *)view;

-(NSArray *)setConstarintsForCenterInParent:(UIView *)view;

FOUNDATION_EXPORT NSString *const kTopConstraintKey;
FOUNDATION_EXPORT NSString *const kBottomConstraintKey;
FOUNDATION_EXPORT NSString *const kLeftConstraintKey;
FOUNDATION_EXPORT NSString *const kRightConstraintKey;
FOUNDATION_EXPORT NSString *const kHeightConstraintKey;

@end
