//
//  CompletedChore.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "CompletedChore.h"
#import "Chore.h"
#import "Person.h"
#import "CoreDataStackManager.h"
#import "Household.h"

@implementation CompletedChore

+ (NSString * _Nonnull)name {
    return @"CompletedChore";
}

+ (instancetype _Nonnull)completedChoreWithCompletionDate:(NSDate * _Nonnull)completionDate alertDate:(NSDate * _Nonnull)alertDate chore:(Chore * _Nonnull)chore person:(Person * _Nonnull)person household:(Household * _Nonnull)household imageName:(NSString * _Nullable)imageName {
    CompletedChore *completedChore = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[[CoreDataStackManager sharedManager] managedObjectContext]];
    completedChore.completionDate = completionDate;
    completedChore.alertDate = alertDate;
    completedChore.chore = chore;
    completedChore.person = person;
    completedChore.household = household;
    completedChore.imageName = imageName;
    [[CoreDataStackManager sharedManager] saveContext];
    return completedChore;
}

@end
