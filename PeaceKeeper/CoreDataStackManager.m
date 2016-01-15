//
//  CoreDataController.m
//  PeaceKeeper
//
//  Created by Work on 1/12/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import "CoreDataStackManager.h"
#import "NSDate+Category.h"
#import "Choree.h"

@implementation CoreDataStackManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedManager {
    static CoreDataStackManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

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
        
        // FIXME
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

#pragma mark - Fetch Methods

- (NSUInteger)fetchAndCountChoreeAlertDatesInThePast {
    NSString *entityName = [Choree name];
    NSString *propertyName = @"alertDate";
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    request.propertiesToFetch = @[propertyName];
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    [self processFetchError:error entityName:entityName];
    
    NSUInteger count = 0;
    
    for (NSUInteger i = 0; i < results.count; i++) {
        if ([results[i][propertyName] isInThePast]) {
            count++;
        }
    }
    return count;
}


- (Chore * _Nullable)fetchChoreWithName:(NSString * _Nonnull)name {
    NSString *entityName = [Chore name];
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    [self processFetchError:error entityName:entityName];
    if (results.count > 0) {
        return results.firstObject;
    }
    return nil;
}

- (Household * _Nullable)fetchHousehold {
    NSString *entityName = [Household name];
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    [self processFetchError:error entityName:entityName];
    if (results.count > 0) {
        return results.firstObject;
    }
    return nil;
}

- (NSArray<NSManagedObjectID *> * _Nonnull)fetchHouseholdsAsObjectIDs {
    NSString *entityName = [Household name];
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.resultType = NSManagedObjectIDResultType;
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    [self processFetchError:error entityName:entityName];
    return results;
}

#pragma mark - Internal Methods

- (void)processFetchError:(NSError *)error entityName:(NSString *)entityName {
    if (error) {
        NSLog(@"Error fetching %@: %@, %@", entityName, error.localizedDescription, error.userInfo);
    } else {
        NSLog(@"Successfully fetched %@!", entityName);
    }
}

@end
