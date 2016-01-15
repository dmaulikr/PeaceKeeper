//
//  CoreDataController.h
//  PeaceKeeper
//
//  Created by Work on 1/12/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chore.h"
#import "Household.h"

@import CoreData;

@interface CoreDataStackManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSUInteger)fetchAndCountChoreeAlertDatesInThePast;
- (Chore * _Nullable)fetchChoreWithName:(NSString * _Nonnull)name;
- (Household * _Nullable)fetchHousehold;
- (NSArray<NSManagedObjectID *> * _Nonnull)fetchHouseholdsAsObjectIDs;

@end
