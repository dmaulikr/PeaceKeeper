//
//  ChevronView.m
//  PeaceKeeper
//
//  Created by Work on 1/7/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import "ChevronView.h"

@implementation ChevronView

+ (UIImage *)imageOfChevronViewWithSize:(CGSize)size {
    UIView *cv = [[ChevronView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIGraphicsBeginImageContext(size);
    [cv.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawRect:(CGRect)rect {
    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    CGPoint center = CGPointMake(centerX, centerY);
    CGPoint topLeft = rect.origin;
    CGPoint bottomLeft = CGPointMake(rect.origin.x, rect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    UIBezierPath *chevron = [[UIBezierPath alloc] init];
    [chevron moveToPoint:topLeft];
    [chevron addLineToPoint:center];
    [chevron addLineToPoint:bottomLeft];
    chevron.lineWidth = 5.0;
    chevron.lineCapStyle = kCGLineCapSquare;
    [[UIColor blackColor] setStroke];
    [chevron stroke];
}

@end
