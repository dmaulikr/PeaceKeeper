//
//  EllipsisView.m
//  PeaceKeeper
//
//  Created by Work on 1/6/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import "EllipsisView.h"

@implementation EllipsisView

+ (UIView *)ellipsisViewWithSize:(CGSize)size leftMargin:(CGFloat)leftMargin color:(UIColor *)color {
    CGFloat centerX = size.width / 2 + leftMargin;
    CGFloat centerY = size.height / 2;
    CGFloat dotDiameter = size.width / 5;
    CGFloat halfDiameter = dotDiameter / 2;
    CGFloat spacerWidth = dotDiameter * 0.8;
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width + leftMargin, size.height)];
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(centerX - (spacerWidth + dotDiameter + halfDiameter), centerY - halfDiameter, dotDiameter, dotDiameter)];
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(centerX + halfDiameter + spacerWidth, centerY - halfDiameter, dotDiameter, dotDiameter)];
    UIView *center = [[UIView alloc] initWithFrame:CGRectMake(centerX - halfDiameter, centerY - halfDiameter, dotDiameter, dotDiameter)];
    
    left.backgroundColor = color;
    right.backgroundColor = color;
    center.backgroundColor = color;
    
    left.layer.cornerRadius = halfDiameter;
    right.layer.cornerRadius = halfDiameter;
    center.layer.cornerRadius = halfDiameter;

    [mainView addSubview:left];
    [mainView addSubview:right];
    [mainView addSubview:center];
        
    return mainView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
