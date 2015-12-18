//
//  AppDelegate.h
//  PeaceKeeper
//
//  Created by Francisco Ragland Jr on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@import Contacts;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) CNContactStore *contactStore;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (AppDelegate *)getAppDelegate;

@property (strong, nonatomic) NSMutableArray<UIImage *> *images;

@end

