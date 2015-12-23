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
#import "NSManagedObjectContext+Category.h"
#import "CreateHouseholdViewController.h"
#import "Constants.h"
#import "Chore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


+ (AppDelegate *)getAppDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // DELETE ME
    NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *firstOf2015Components = [[NSDateComponents alloc] init];
    firstOf2015Components.year = 2015;
    firstOf2015Components.month = 1;
    firstOf2015Components.day = 1;
    firstOf2015Components.hour = 0;
    firstOf2015Components.minute = 1;
    firstOf2015Components.second = 1;
    NSDate *firstOf2015 = [cal dateFromComponents:firstOf2015Components];
    // DELETE ME
    
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotification) {
        NSLog(@"Inside application:didFinishLaunchingWithOptions:");
        NSLog(@"Local notification user info: %@", localNotification.userInfo);
    }
    
    self.contactStore = [[CNContactStore alloc] init];
    
    [self registerForNotifications];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Inside application:didReceiveLocalNotification:");
    NSLog(@"Local notification user info: %@", notification.userInfo);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {

    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        NSString *choreName = (NSString *)userInfo[kChoreNameKey];
        Chore *chore = [Chore fetchChoreWithName:choreName];
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
    [self saveContext];
}

- (BOOL)userHasCreatedAHousehold {
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Household name]];
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching count of %@ objects: %@", [Household name], error.localizedDescription);
    } else {
        NSLog(@"Successfully fetched count of %@ objects: %lu", [Household name], (unsigned long)count);
    }
    if (count == 0) {
        return NO;
    }
    return YES;
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.franciscoragland.PeaceKeeper" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PeaceKeeper" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PeaceKeeper.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
