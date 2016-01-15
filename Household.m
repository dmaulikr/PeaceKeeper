//
//  Household.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "Household.h"
#import "Chore.h"
#import "Person.h"
#import "CoreDataStackManager.h"

@implementation Household

+ (NSString * _Nonnull)name {
    return @"Household";
}

+ (instancetype _Nonnull)householdWithName:(NSString * _Nonnull)name {
    Household *household = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[[CoreDataStackManager sharedManager] managedObjectContext]];
    household.name = name;
    // FIXME?
//    household.chores = [NSSet set];
//    household.people = [NSSet set];
//    household.completedChores = [NSSet set]; 
    [[CoreDataStackManager sharedManager] saveContext];
    return household;
}

@end
