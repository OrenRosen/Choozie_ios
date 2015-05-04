//
//  Utils.m
//  ChoozieApp
//
//  Created by Oren Rosenblum on 11/23/13.
//  Copyright (c) 2013 ChoozieApp. All rights reserved.
//

#import "Utils.h"
#import "TTTAttributedLabel.h"
#import "AFHTTPRequestOperation.h"
#import "ChoozieMantle.h"
#import "UIView+Additions.h"

@interface Utils()

@property (nonatomic, strong) NSString *imagesDirectoryPath;

@end

NSString *const kTopConstraintKey = @"kTopConstraintKey";
NSString *const kBottomConstraintKey = @"kBottomConstraintKey";
NSString *const kLeftConstraintKey = @"kLeftConstraintKey";
NSString *const kRightConstraintKey = @"kRightConstraintKey";
NSString *const kHeightConstraintKey = @"kHeightConstraintKey";

NSString *const kCacheDirNameDictionaries = @"Dictionaries";
NSString *const kCacheDirNameImages = @"Images";


@implementation Utils

+ (id)sharedInstance {
    static Utils *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        
        _sharedInstance.imagesDirectoryPath = [self CacheDirDirectoryPath:@"Images"];
        // initialize parameters
        
    });
    return _sharedInstance;
}



- (void) setImageforView:(id)genericView withCachedImageFromURL:(NSString *)imageUrl
{
    [self getImagewithCachedImageFromURL:imageUrl withCompletion:^(UIImage *image) {
        BOOL isButton = [genericView isKindOfClass:[UIButton class]] ? YES : NO;
        if (isButton) {
            [(UIButton *)genericView setImage:image forState:UIControlStateNormal];
        }
        else {
            [(UIImageView *)genericView setImage:image];
        }
    }];
}



- (void) getImagewithCachedImageFromURL:(NSString *)imageUrl withCompletion:(void (^)(UIImage *image))onComplete
{
    [self getImagewithCachedImageFromURL:imageUrl isArticleImageURL:NO withCompletion:onComplete];
}


- (void) getImagewithCachedImageFromURL:(NSString *)imageUrl isArticleImageURL:(BOOL)isArticleImageURL withCompletion:(void (^)(UIImage *image))onComplete
{
    if (! imageUrl) {
        NSLog(@"warning... [Utils setImageforView:withCachedImageFromURL: is nil");
        return;
    }
    
    NSArray *comps = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imgName = [comps objectAtIndex:comps.count - 2];
    
    if (isArticleImageURL) {
        // Make a unique image name
        NSArray *pathsComponents = [imageUrl pathComponents];
        imgName = [NSString stringWithFormat:@"%@_%@", [pathsComponents objectAtIndex:[pathsComponents count]-2], imgName];
    }
    
    NSString *strImgPath = [self.imagesDirectoryPath stringByAppendingString:imgName];
    UIImage *imgFound = [UIImage imageNamed:imgName];
    
    if (imgFound) {
        onComplete(imgFound);
        return;
        // NSLog(@"file exists in Bundle: %@", imgName);
    }
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if(![fileManger fileExistsAtPath:strImgPath]) //Check wether image exits at Image Folder in Doc Dir
    {
        //file not exists
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            //            NSLog(@"dispatch_async: %@", imgName);
            NSData *data0 = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *image = [UIImage imageWithData:data0];
            if(image)
            {
                NSData *dataImg = UIImagePNGRepresentation(image);
                if(dataImg)
                {
                    [dataImg writeToFile:strImgPath atomically:YES];
                }
            }
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                onComplete(image);
            });
        });
        
        return;
    }
    else
    {
        //file exists in file-system
        //        NSLog(@"file exists in file-system: %@", imgName);
        NSData *imgData = [NSData dataWithContentsOfFile:strImgPath];
        imgFound = [UIImage imageWithData:imgData];
    }
    
    onComplete(imgFound);
}







+ (NSString *)CacheDirDirectoryPath:(NSString *)dirName
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);  // According to https://developer.apple.com/icloud/documentation/data-storage/
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    basePath = [basePath stringByAppendingFormat:@"/%@/", dirName];
    NSError *error;
    if(![fileManger fileExistsAtPath:basePath])
    {
        [fileManger createDirectoryAtPath:basePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return basePath;
}



- (CGFloat)getHeightForString:(NSString *)headlineString withMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGFloat height = 0;
    CGRect rect =  [headlineString boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraphStyle}
                                                context:nil];
    height = rect.size.height;
    
    return height + 10;
}


- (void)setLinkInLabel:(TTTAttributedLabel *)label withText:(NSString *)text inRange:(NSRange)range
{
    label.linkAttributes = [self getLinkAttributes];
    label.activeLinkAttributes = [self getActiveLinkAttributes];
    [label setText: text];
}





- (void) getImagewithCachedImageFromURL:(NSString *)imageUrl postId:(NSString *)postId withCompletion:(void (^)(UIImage *image))onComplete
{
    NSString *imgName = postId ? postId : [[[imageUrl lastPathComponent] componentsSeparatedByString:@"?"] objectAtIndex:0];
    
    UIImage *imgFound = [UIImage imageNamed:imgName];
    
    if (imgFound) {
        onComplete(imgFound);
        return;
        // NSLog(@"file exists in Bundle: %@", imgName);
    }
    NSString *strImgPath = [self.imagesDirectoryPath stringByAppendingString:imgName];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if(![fileManger fileExistsAtPath:strImgPath]) //Check wether image exits at Image Folder in Doc Dir
    {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0f];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIImage *image = responseObject;
            onComplete(image);
            
            NSData *dataImg = UIImagePNGRepresentation(image);
            if(dataImg){
                [dataImg writeToFile:strImgPath atomically:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            onComplete([UIImage imageWithData:nil]);
        }];
        
        [requestOperation start];
        
        return;
    } else {
        //file exists in file-system
        //        NSLog(@"file exists in file-system: %@", imgName);
        NSData *imgData = [NSData dataWithContentsOfFile:strImgPath];
        imgFound = [UIImage imageWithData:imgData];
        onComplete(imgFound);
    }
    
}


- (void)saveJsonObjectToCache:(NSString *)fileName rootObject:(ChoozieMantle *)rootObject
{
    NSString *dictionariesPath = [[self class] cacheJsonDirDirectoryPath:kCacheDirNameDictionaries];
    [self saveFileName:fileName withDictionariesPath:dictionariesPath forRootObject:rootObject];
}


- (void)saveFileName:(NSString *)fileName withDictionariesPath:(NSString *)dictionariesPath forRootObject:(ChoozieMantle *)rootObject
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSString *filePath = [dictionariesPath stringByAppendingString:fileName];
        
        // Serialize dictionary
        [NSKeyedArchiver archiveRootObject:rootObject toFile:filePath];
    });
}


- (id) getJsonObjectFromCache:(NSString *)fileName type:(Class)type
{
    NSString *dictionariesPath = [[self class] cacheJsonDirDirectoryPath:kCacheDirNameDictionaries];
    ChoozieMantle *jsonObject = [self getObjectFromCacheWithDictionariesPath:dictionariesPath fileName:fileName forClassType:type];
    
    return jsonObject;
}


#pragma mark - Private Methods

+ (NSString *)cacheJsonDirDirectoryPath:(NSString *)dirName
{
    return [self cacheDirDirectoryForSearchPath:NSCachesDirectory withDirName:dirName];
}


+ (NSString *)cacheUserGeneratedDirDirectoryPath:(NSString *)dirName
{
    return [self cacheDirDirectoryForSearchPath:NSDocumentDirectory withDirName:dirName];
}


+ (NSString *)cacheDirDirectoryForSearchPath:(NSSearchPathDirectory)searchPath withDirName:(NSString *)dirName
{
    NSString *basePath = [self basePathForSearchPath:searchPath withDirName:dirName];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if(![fileManger fileExistsAtPath:basePath])
    {
        NSError *error;
        [fileManger createDirectoryAtPath:basePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return basePath;
}


+ (NSString *)basePathForSearchPath:(NSSearchPathDirectory)searchPath withDirName:(NSString *)dirName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPath, NSUserDomainMask, YES);  // According to https://developer.apple.com/icloud/documentation/data-storage/
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    basePath = [basePath stringByAppendingFormat:@"/%@/", dirName];
    
    return basePath;
}


- (id)getObjectFromCacheWithDictionariesPath:(NSString *)dictionariesPath fileName:(NSString *)fileName forClassType:(Class)type
{
    NSString *filePath = [dictionariesPath stringByAppendingString:fileName];
    
    ChoozieMantle *jsonObject = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        jsonObject = [MTLJSONAdapter modelOfClass:type fromJSONDictionary:(NSDictionary *)jsonObject error:&error];
    }
    
    return jsonObject;
}



- (NSDictionary *)getLinkAttributes
{
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    
    [mutableActiveLinkAttributes setValue: [UIColor colorWithRed:90/255.0 green:129/255.0 blue:255/255.0 alpha:1.0] forKey: (NSString *) kCTForegroundColorAttributeName];
    
//    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0] forKey: (NSString *) kCTStrokeWidthAttributeName];
    
//    [mutableActiveLinkAttributes setValue:[UIColor colorWithRed:250/255.0 green:235/255.0 blue:215/255.0 alpha:1.0] forKey: (NSString *) kCTStrokeColorAttributeName];

    [mutableActiveLinkAttributes setValue:[UIColor blackColor] forKey: (NSString *) kCTStrokeColorAttributeName];
    
    
    [mutableActiveLinkAttributes setValue: [NSNumber numberWithBool: NO]
                                   forKey: (NSString *) kCTUnderlineStyleAttributeName];
    
    return [NSDictionary dictionaryWithDictionary: mutableActiveLinkAttributes];
}

- (NSDictionary *)getActiveLinkAttributes
{
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    
    [mutableActiveLinkAttributes setValue: [UIColor purpleColor]
                                   forKey: (NSString *) kCTForegroundColorAttributeName];
    
    [mutableActiveLinkAttributes setValue: [NSNumber numberWithBool: NO]
                                   forKey: (NSString *) kCTUnderlineStyleAttributeName];
    
    return [NSDictionary dictionaryWithDictionary: mutableActiveLinkAttributes];
}



#pragma mark -
#pragma mark - Autolayout Methods
-(NSArray *)setConstarintsForCenterInParent:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerXconstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:view.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    
    NSLayoutConstraint *centerYconstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:view.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:0 multiplier:1 constant:view.width];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:0 multiplier:1 constant:view.height];
    
    NSArray *constraints = [NSArray arrayWithObjects:centerXconstraint, centerYconstraint, widthConstraint, heightConstraint, nil];
    [view.superview addConstraints:constraints];
    
    return constraints;
}

- (NSDictionary *)setConstraintsForItem:(UIView *)item withDistance:(CGFloat)distance underItem:(id)itemOnTop withHeight:(CGFloat)height inView:(UIView *)view
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:itemOnTop attribute:NSLayoutAttributeBottom multiplier:1.0f constant:distance];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *heightConstraint;
    if (height > 0) {
        heightConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
        
    } else {
        heightConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0];
    }
    
    [view addConstraints:@[topConstraint, leftConstraint, rightConstraint, heightConstraint]];
    
    NSDictionary *constraintsDictionary = [NSMutableDictionary dictionaryWithObjects:@[topConstraint, leftConstraint, rightConstraint, heightConstraint] forKeys:@[kTopConstraintKey, kLeftConstraintKey, kRightConstraintKey, kHeightConstraintKey]];
    
    return constraintsDictionary;
}

- (NSDictionary *)setConstraintsForItem:(UIView *)item withDistance:(CGFloat)distanceFromView fromTopOfItem:(id)fromItem withHeight:(CGFloat)height inView:(UIView *)view
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:fromItem attribute:NSLayoutAttributeTop multiplier:1.0f constant:distanceFromView];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:fromItem attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight  relatedBy:NSLayoutRelationEqual toItem:fromItem attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *heightConstraint;
    
    if (height > 0) {
        heightConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    } else {
        heightConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    }
    
    [view addConstraints:@[topConstraint, leftConstraint, rightConstraint, heightConstraint]];
    
    NSDictionary *constraintsDictionary = [NSMutableDictionary dictionaryWithObjects:@[topConstraint, leftConstraint, rightConstraint, heightConstraint] forKeys:@[kTopConstraintKey, kLeftConstraintKey, kRightConstraintKey, kHeightConstraintKey]];
    
    return constraintsDictionary;
}


- (NSDictionary *)setConstraintsForItem:(UIView *)item withDistance:(CGFloat)distanceFromView ToFillItem:(id)itemToFill inView:(UIView *)view
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:item
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:itemToFill
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:distanceFromView];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:item
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:itemToFill
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:distanceFromView];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:item
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:itemToFill
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f
                                                                        constant:distanceFromView];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:item
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:itemToFill
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:distanceFromView];
    
    [view addConstraints:@[topConstraint, leftConstraint, rightConstraint, bottomConstraint]];
    
    NSDictionary *constraintsDictionary = [NSMutableDictionary dictionaryWithObjects:@[topConstraint, leftConstraint, rightConstraint, bottomConstraint] forKeys:@[kTopConstraintKey, kLeftConstraintKey, kRightConstraintKey, kBottomConstraintKey]];
    
    return constraintsDictionary;
}


- (void)setConstraintsForLabel:(UILabel *)label withDistance:(CGFloat)distanceFromView fromTopOfItem:(id)fromItem inView:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:fromItem attribute:NSLayoutAttributeTop multiplier:1.0f constant:distanceFromView]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:fromItem attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
}



@end
