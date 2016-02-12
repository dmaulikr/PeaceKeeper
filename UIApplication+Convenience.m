//
//  UIApplication+Convenience.m
//  PeaceKeeper
//
//  Created by Work on 1/16/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import "UIApplication+Convenience.h"
#import "AppDelegate.h"

@implementation UIApplication (Convenience)

- (void)updateApplicationIconBadgeNumber {
    self.applicationIconBadgeNumber = [(AppDelegate *)self.delegate fetchUpdatedApplicationIconBadgeNumber];
}

@end
