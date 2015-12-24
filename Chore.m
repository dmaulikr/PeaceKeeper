//
//  Chore.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "Chore.h"
#import "Household.h"
#import "Person.h"
#import "CompletedChore.h"
#import "NSManagedObjectContext+Category.h"
#import "TimeService.h"

@implementation Chore

#pragma mark - Interface methods

+ (NSString *)name {
    return @"Chore";
}

+ (instancetype)fetchChoreWithName:(NSString * _Nonnull)name {
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Chore name]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching %@ objects: %@", [Chore name], error.localizedDescription);
    } else {
        NSLog(@"Successfully fetched %@ object!", [Chore name]);
    }
    if (results.count > 0) {
        return results.firstObject;
    }
    return nil;
}

+ (instancetype)choreWithName:(NSString * _Nonnull)name startDate:(NSDate * _Nonnull)startDate repeatIntervalValue:(NSNumber * _Nonnull)repeatIntervalValue repeatIntervalUnit:(NSString * _Nonnull)repeatIntervalUnit household:(Household * _Nonnull)household people:(NSOrderedSet *)people {
    Chore *chore = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[NSManagedObjectContext managedObjectContext]];
    chore.name = name;
    chore.startDate = startDate;
    chore.repeatIntervalValue = repeatIntervalValue;
    chore.repeatIntervalUnit = repeatIntervalUnit;
    chore.household = household;
    chore.currentPersonIndex = @(0);
    chore.people = people;
    // FIXME
//    chore.alertDates = [TimeService alertDatesForChore:self];
    [household addChoresObject:chore];
    [NSManagedObjectContext saveManagedObjectContext];
    return chore;
}

- (void)replacePeople:(NSOrderedSet<Person *> * _Nonnull)updatedPeople currentPersonIndex:(NSNumber * _Nonnull)updatedCurrentPersonIndex {
    for (Person *person in self.people) {
        if (![updatedPeople containsObject:person]) {
            [self removePerson:person];
        }
    }
    for (Person *person in updatedPeople) {
        if (![self.people containsObject:person]) {
            [self addPerson:person];
        }
    }
    self.people = updatedPeople;
    self.currentPersonIndex = updatedCurrentPersonIndex;
    // FIXME
//    self.alertDates = [TimeService alertDatesForChore:self];
    [NSManagedObjectContext saveManagedObjectContext];
}

- (void)replaceStartDate:(NSDate *)startDate repeatIntervalUnit:(NSString *)repeatIntervalUnit {
    self.startDate = startDate;
    self.repeatIntervalUnit = repeatIntervalUnit;
    // FIXME
//    self.alertDates = [TimeService alertDatesForChore:self];
    [NSManagedObjectContext saveManagedObjectContext];
    
}

- (Person *)currentPerson {
    NSOrderedSet *people = self.people;
    return [people objectAtIndex:self.currentPersonIndex.integerValue];
}

- (void)completeChore {
    [CompletedChore completedChoreWithCompletionDate:[NSDate date] chore:self person:[self.people objectAtIndex:self.currentPersonIndex.integerValue] household:self.household];
    
    NSInteger currentPersonIndexValue = self.currentPersonIndex.integerValue;
    
    // FIXME
//    self.alertDates = [TimeService updateAlertDates:self.alertDates forCompletedDateAtIndex:currentPersonIndexValue];
    
    if (currentPersonIndexValue >= [self.people count] - 1) {
        self.currentPersonIndex = @(0);
    } else {
        currentPersonIndexValue++;
        self.currentPersonIndex = @(currentPersonIndexValue);
    }
    [NSManagedObjectContext saveManagedObjectContext];
}

#pragma mark - Internal methods

- (void)removePerson:(Person * _Nonnull)person {
    // Remove the person from the chore
    NSMutableOrderedSet *mutablePeople = [NSMutableOrderedSet orderedSetWithOrderedSet:self.people];
    [mutablePeople removeObject:person];
    self.people = mutablePeople;
    
    // Remove the chore from the person
    NSMutableSet *mutableChores = [NSMutableSet setWithSet:person.chores];
    [mutableChores removeObject:self];
    person.chores = mutableChores;
    
    [NSManagedObjectContext saveManagedObjectContext];
}

- (void)addPerson:(Person * _Nonnull)person {
    // Add the person to the chore
    NSMutableOrderedSet *mutablePeople = [NSMutableOrderedSet orderedSetWithOrderedSet:self.people];
    [mutablePeople addObject:person];
    self.people = mutablePeople;
    
    // Add the chore to the person
    NSMutableSet *mutableChores = [NSMutableSet setWithSet:person.chores];
    [mutableChores addObject:self];
    person.chores = mutableChores;
    
    [NSManagedObjectContext saveManagedObjectContext];
}

@end
