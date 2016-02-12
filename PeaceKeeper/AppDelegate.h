//
//  AppDelegate.h
//  PeaceKeeper
//
//  Created by Francisco Ragland Jr on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataStackManager.h"

@import Contacts;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CoreDataStackManager *coreDataStackManager;

- (NSInteger)fetchUpdatedApplicationIconBadgeNumber;

@end

