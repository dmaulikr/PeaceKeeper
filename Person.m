//
//  Person.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "Person.h"
#import "Chore.h"
#import "Household.h"
#import "NSManagedObjectContext+Category.h"

@implementation Person

+ (NSString *)name {
    return @"Person";
}

+ (instancetype)personWithName:(NSString * _Nonnull)name chore:(Chore * _Nullable)chore household:(Household * _Nonnull)household {
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[NSManagedObjectContext managedObjectContext]];
    person.name = name;
    if (chore) {
        person.chores = [NSSet setWithObject:chore];
    } else {
        person.chores = [NSSet set];
    }
    person.household = household;
    return person;
}

@end
