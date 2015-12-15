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

+ (instancetype)personWithFirstName:(NSString * _Nonnull)firstName lastName:(NSString * _Nullable)lastName phoneNumber:(NSString * _Nullable)phoneNumber email:(NSString *_Nullable)email chore:(Chore * _Nullable)chore household:(Household * _Nonnull)household {
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[NSManagedObjectContext managedObjectContext]];
    person.firstName = firstName;
    person.lastName = lastName;
    person.phoneNumber = phoneNumber;
    person.email = email;
    if (chore) {
        person.chores = [NSSet setWithObject:chore];
    } else {
        person.chores = [NSSet set];
    }
    person.household = household;
    [NSManagedObjectContext saveManagedObjectContext];
    return person;
}

@end
