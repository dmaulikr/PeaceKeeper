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
#import "NSManagedObjectContext+Category.h"

@implementation Household

+ (NSString *)name {
    return @"Household";
}

+ (instancetype)householdWithName:(NSString * _Nonnull)name {
    Household *household = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[NSManagedObjectContext managedObjectContext]];
    household.name = name;
    household.chores = [NSSet set];
    household.people = [NSSet set];
    household.archive = [NSSet set];
    return household;
}

@end
