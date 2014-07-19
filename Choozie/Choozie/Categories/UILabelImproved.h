//
//  UILabelImproved.h
//

#import <Foundation/Foundation.h>


typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface UILabelImproved : UILabel {
@private
    VerticalAlignment _verticalAlignment;
    NSInteger _maximumFontSize;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;
@property (nonatomic, assign) NSInteger maximumFontSize;
@end