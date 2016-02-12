//
//  Functions.m
//  PeaceKeeper
//
//  Created by Work on 1/15/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import "Functions.h"

UIImage *imageOfView(UIView *view) {
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

UIImage *iconImageFromImageName(NSString *imageName) {
    return [[UIImage imageNamed:[NSString stringWithFormat:@"%@Icon", imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}