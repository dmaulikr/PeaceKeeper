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
#import "NSManagedObjectContext+Category.h"
#import "Household.h"

@implementation CompletedChore

+ (NSString *)name {
    return @"CompletedChore";
}

+ (instancetype)completedChoreWithCompletionDate:(NSDate * _Nonnull)completionDate chore:(Chore * _Nonnull)chore person:(Person * _Nonnull)person household:(Household *)household {
    CompletedChore *completedChore = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[NSManagedObjectContext managedObjectContext]];
    completedChore.completionDate = completionDate;
    completedChore.chore = chore;
    completedChore.person = person;
    [household addArchiveObject:completedChore];
    [NSManagedObjectContext saveManagedObjectContext];
    return completedChore;
}

@end
