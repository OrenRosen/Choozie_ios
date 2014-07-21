//
//  Utils.m
//  ChoozieApp
//
//  Created by Oren Rosenblum on 11/23/13.
//  Copyright (c) 2013 ChoozieApp. All rights reserved.
//

#import "Utils.h"

@interface Utils()

@property (nonatomic, strong) NSString *imagesDirectoryPath;

@end


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
    
    NSString *imgName = [[[imageUrl lastPathComponent] componentsSeparatedByString:@"?"] objectAtIndex:0];
    
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





@end
