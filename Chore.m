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
    NSString *entityName = [Chore name];
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching %@ objects: %@", entityName, error.localizedDescription);
    } else {
        NSLog(@"Successfully fetched %@ object!", entityName);
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
    chore.people = people;
    chore.alertDates = [TimeService alertDatesForChore:chore withStartIndex:0];
    [household addChoresObject:chore];
    [NSManagedObjectContext saveManagedObjectContext];
    return chore;
}

- (void)personAtIndexHasCompletedChore:(NSUInteger)targetIndex {
    NSMutableOrderedSet *mutablePeople = [NSMutableOrderedSet orderedSetWithOrderedSet:self.people];
    NSMutableArray<NSDate *> *mutableAlertDates = [NSMutableArray arrayWithArray:self.alertDates];
    
    Person *targetPerson = [mutablePeople objectAtIndex:targetIndex];
    [mutablePeople removeObjectAtIndex:targetIndex];

    NSDate *latestDate = mutableAlertDates[[TimeService indexOfLatestDateInAlertDates:mutableAlertDates]];
    latestDate = [[NSCalendar currentCalendar] dateByAddingUnit:[TimeService calendarUnitForString:self.repeatIntervalUnit] value:self.repeatIntervalValue.integerValue toDate:latestDate options:0];
    [mutableAlertDates removeObjectAtIndex:targetIndex];
    
    NSInteger insertionIndex = [TimeService insertionIndexForLatestDateInAlertDates:mutableAlertDates];
    [mutableAlertDates insertObject:latestDate atIndex:insertionIndex];
    [mutablePeople insertObject:targetPerson atIndex:insertionIndex];
    
    self.people = mutablePeople;
    self.alertDates = mutableAlertDates;
}

- (void)replacePeople:(NSOrderedSet<Person *> * _Nonnull)updatedPeople startIndex:(NSUInteger)startIndex {
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
    self.alertDates = [TimeService alertDatesForChore:self withStartIndex:startIndex];
    [NSManagedObjectContext saveManagedObjectContext];
}

- (void)replaceStartDate:(NSDate *)startDate repeatIntervalUnit:(NSString *)repeatIntervalUnit {
    self.startDate = startDate;
    self.repeatIntervalUnit = repeatIntervalUnit;
    NSUInteger startIndex = [TimeService indexOfEarliestDateInAlertDates:self.alertDates];
    self.alertDates = [TimeService alertDatesForChore:self withStartIndex:startIndex];
    [NSManagedObjectContext saveManagedObjectContext];
    
}

- (Person *)currentPerson {
    NSInteger earliest = [TimeService indexOfEarliestDateInAlertDates:self.alertDates];
    return [self.people objectAtIndex:earliest];
}

- (void)completeChore {
    [CompletedChore completedChoreWithCompletionDate:[NSDate date] chore:self person:[self.people objectAtIndex:self.currentPersonIndex.integerValue] household:self.household];
    self.alertDates = [TimeService advanceAlertDates:self.alertDates
                               steppingInIntervalsOf:self.repeatIntervalValue.integerValue
                                        calendarUnit:[TimeService calendarUnitForString:self.repeatIntervalUnit]];
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
