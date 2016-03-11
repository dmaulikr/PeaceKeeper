//
//  AppDelegate.m
//  PeaceKeeper
//
//  Created by Francisco Ragland Jr on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "AppDelegate.h"
#import "TimeService.h"
#import "Household.h"
#import "CoreDataStackManager.h"
#import "CreateHouseholdViewController.h"
#import "Constants.h"
#import "Chore.h"
#import "Choree.h"
#import "UIApplication+Convenience.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.viewControllers[0].tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"HomeBarButtonIcon"] selectedImage:[UIImage imageNamed:@"HomeBarButtonIconSelected"]];
    
    self.coreDataStackManager = [CoreDataStackManager sharedManager];
    [self registerForNotifications];
    [application updateApplicationIconBadgeNumber];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [application updateApplicationIconBadgeNumber];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {

    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        NSString *choreName = (NSString *)userInfo[kChoreNameKey];
        Chore *chore = [[CoreDataStackManager sharedManager] fetchChoreWithName:choreName];
        if (chore) {
            if ([identifier isEqualToString:kChoreNotificationActionIdentifierCompleteChore]) {
                [chore completeChore];
            } else if ([identifier isEqualToString:kChoreNotificationActionIdentifierNotifyChoree]) {
                // TODO
            }
        }
    }
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self.coreDataStackManager saveContext];
}

- (void)registerForNotifications {
    UIMutableUserNotificationAction *completeChoreAction = [[UIMutableUserNotificationAction alloc] init];
    completeChoreAction.identifier = kChoreNotificationActionIdentifierCompleteChore;
    completeChoreAction.title = kChoreNotificationActionTitleCompleteChore;
    completeChoreAction.activationMode = UIUserNotificationActivationModeBackground;
    completeChoreAction.authenticationRequired = NO;

    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = kChoreNotificationCategoryIdentifier;
    NSArray *actions = @[completeChoreAction];
    [notificationCategory setActions:actions forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:actions forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObject:notificationCategory];
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:categories];

    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (NSInteger)fetchUpdatedApplicationIconBadgeNumber {
    return [self.coreDataStackManager fetchAndCountChoreeAlertDatesInThePast];
}

@end
