//
//  UILabelImproved.m
//  fiddme
//
//  Created by Yosi Taguri on 14/11/09.
//  Copyright 2009 fiddme. All rights reserved.
//

#import "UILabelImproved.h"


@implementation UILabelImproved
@synthesize verticalAlignment = _verticalAlignment, maximumFontSize= _maximumFontSize;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
        self.maximumFontSize = 30;
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    // start with maxSize and keep reducing until it doesn't clip
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}
-(void)setText:(NSString *)text {
    [super setText:text];
    UIFont *font = self.font;

    for(int i = self.maximumFontSize; i > self.minimumScaleFactor; i--) {
        font = [self.font fontWithSize:i];
        CGSize constraintSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
        
        // This step checks how tall the label would be with the desired font.
        CGSize labelSize = [self.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:self.lineBreakMode];
        if(labelSize.height <= self.frame.size.height)
            break;
    }
    // Set the UILabel's font to the newly adjusted font.
    self.font = font;
}

@end