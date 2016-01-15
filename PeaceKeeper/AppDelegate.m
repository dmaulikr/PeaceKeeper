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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotification) {
        NSLog(@"Inside application:didFinishLaunchingWithOptions:");
        NSLog(@"Local notification user info: %@", localNotification.userInfo);
    }
    */
    
    // DELETE ME
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // DELETE ME
    
    self.coreDataStackManager = [CoreDataStackManager sharedManager];
    application.applicationIconBadgeNumber = [self fetchUpdatedApplicationIconBadgeNumber];
        
    [self registerForNotifications];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /*
    NSLog(@"Inside application:didReceiveLocalNotification:");
    NSLog(@"Local notification user info: %@", notification.userInfo);
     */
    application.applicationIconBadgeNumber = [self fetchUpdatedApplicationIconBadgeNumber];
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
                
                // Get a pointer to ViewController
                    // Get the root view controller
                    // Get the tab bar controller
                    // Get the selected controller
                    // Check that it's the right class
                        // Perform the segue from ViewController to ChoreDetailViewController with the Chore as sender
                // Get a pointer to ChoreDetailViewController an activate the contact pop-up
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
    
    /*
    UIMutableUserNotificationAction *notifyChoreeAction = [[UIMutableUserNotificationAction alloc] init];
    notifyChoreeAction.identifier = kChoreNotificationActionIdentifierNotifyChoree;
    notifyChoreeAction.title = kChoreNotificationActionTitleNotifyChoree;
    notifyChoreeAction.activationMode = UIUserNotificationActivationModeForeground;
    notifyChoreeAction.authenticationRequired = YES;
     */

    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = kChoreNotificationCategoryIdentifier;
    NSArray *actions = @[completeChoreAction/*, notifyChoreeAction*/];
    [notificationCategory setActions:actions forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:actions forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObject:notificationCategory];
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:categories];

    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (NSInteger)fetchUpdatedApplicationIconBadgeNumber {
    // FIXME
    // Implement way to get badge count from objects in memory
    return [self.coreDataStackManager fetchAndCountChoreeAlertDatesInThePast];
}

@end
