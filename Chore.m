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
#import "CoreDataStackManager.h"
#import "AlertDates.h"
#import "TimeService.h"
#import "Choree.h"
#import "UIApplication+Convenience.h"

@implementation Chore

#pragma mark - Interface methods

+ (NSString * _Nonnull)name {
    return @"Chore";
}

+ (instancetype _Nonnull)choreWithName:(NSString * _Nonnull)name startDate:(NSDate * _Nonnull)startDate repeatIntervalValue:(NSNumber * _Nonnull)repeatIntervalValue repeatIntervalUnit:(NSString * _Nonnull)repeatIntervalUnit household:(Household * _Nonnull)household people:(NSOrderedSet *)people imageName:(NSString * _Nullable)imageName {
    Chore *chore = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[[CoreDataStackManager sharedManager] managedObjectContext]];
    chore.name = name;
    chore.startDate = startDate;
    chore.repeatIntervalValue = repeatIntervalValue;
    chore.repeatIntervalUnit = repeatIntervalUnit;
    chore.household = household;
    [chore updateChoreesWithPeople:people startingPerson:people.firstObject];
    chore.imageName = imageName;
    [[CoreDataStackManager sharedManager] saveContext];
    return chore;
}

- (NSMutableOrderedSet<Person *> * _Nonnull)mutablePeople {
    NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSet];
    for (Choree *choree in self.chorees) {
        [result addObject:choree.person];
    }
    return result;
}

- (void)updateChoreesWithPeople:(NSOrderedSet<Person *> * _Nonnull)updatedPeople startingPerson:(Person * _Nonnull)startingPerson {
    [self deleteCurrentChorees];
    [self choreesWithPeople:updatedPeople startingPerson:startingPerson];
    [[CoreDataStackManager sharedManager] saveContext];
    [self rescheduleNotificationsIfAllowedAndUpdateAppBadgeNumber];
}

- (Person * _Nullable)currentPerson {
    return [self earliestChoree].person;
}

- (NSNumber * _Nullable)currentPersonIndex {
    NSInteger i = [[self alertDates] indexOfEarliestDate];
    if (i == NSNotFound) {
        return nil;
    }
    return @(i);
}

- (void)completeChore {
    Choree *currentChoree = [self.chorees objectAtIndex:[self currentPersonIndex].integerValue];
    
    [CompletedChore completedChoreWithCompletionDate:[NSDate date] alertDate:currentChoree.alertDate chore:self person:currentChoree.person household:self.household imageName:self.imageName];
    
    AlertDates *alertDates = [self alertDates];
    [alertDates advanceByByIntervalAndUnitInChore:self];
    
    [self updateChoreesWithPeople:[self mutablePeople] alertDates:alertDates];
}

- (NSOrderedSet<Choree *> *_Nonnull)unrolledChorees {
    NSMutableOrderedSet<Choree *> *result = [NSMutableOrderedSet orderedSet];
    AlertDates *alertDates = [self alertDates];
    NSInteger startIndex = [alertDates indexOfEarliestDate];
    NSUInteger count = alertDates.dates.count;
    if (startIndex == NSNotFound || count == 0) {
        return result;
    }
    for (NSInteger i = startIndex; i < (startIndex + count); i++) {
        NSUInteger index = i % count;
        [result addObject:[self.chorees objectAtIndex:index]];
    }
    return result;
}

- (NSDate * _Nullable)earliestAlertDate {
    return [[self earliestChoree] alertDate];
}

// FIXME TEST ME!
- (Choree * _Nullable)earliestChoree {
    Choree *earliest;
    for (Choree *choree in self.chorees) {
        if (!earliest) {
            earliest = choree;
        }
        if (choree.alertDate.timeIntervalSinceReferenceDate < earliest.alertDate.timeIntervalSinceReferenceDate) {
            earliest = choree;
        }
    }
    return earliest;
}


#pragma mark - Internal methods

- (void)rescheduleNotificationsIfAllowedAndUpdateAppBadgeNumber {
    if (self.alertsEnabled) {
        [TimeService rescheduleNotificationsForChore:self];
    }
    [[UIApplication sharedApplication] updateApplicationIconBadgeNumber];
}

- (AlertDates * _Nonnull)alertDates {
    NSMutableArray<NSDate *> *dates = [NSMutableArray array];
    for (Choree *choree in self.chorees) {
        [dates addObject:choree.alertDate];
    }
    return [[AlertDates alloc] initWithDates:dates];
}

- (void)deleteCurrentChorees {
    NSMutableOrderedSet *mutableChorees = [self mutableOrderedSetValueForKey:@"chorees"];
    NSManagedObjectContext *managedObjectContext = [[CoreDataStackManager sharedManager] managedObjectContext];
    for (NSInteger i = mutableChorees.count - 1; i >= 0; i--) {
        [managedObjectContext deleteObject:mutableChorees[i]];
    }
}

- (void)updateChoreesWithPeople:(NSOrderedSet<Person *> * _Nonnull)people alertDates:(AlertDates * _Nonnull)alertDates {
    [self deleteCurrentChorees];
    [self choreesWithPeople:people alertDates:alertDates];
    [[CoreDataStackManager sharedManager] saveContext];
    
    [self rescheduleNotificationsIfAllowedAndUpdateAppBadgeNumber];
}

- (NSOrderedSet<Choree *> * _Nullable)choreesWithPeople:(NSOrderedSet<Person *> * _Nonnull)people startingPerson:(Person * _Nonnull)startingPerson {
    NSInteger startIndex = [people indexOfObject:startingPerson];
    if (startIndex == NSNotFound) {
        return nil;
    }
    AlertDates *alertDates = [AlertDates alertDatesForChore:self withCount:people.count startIndex:startIndex];
    return [self choreesWithPeople:people alertDates:alertDates];
}

- (NSOrderedSet<Choree *> * _Nullable)choreesWithPeople:(NSOrderedSet<Person *> * _Nonnull)people alertDates:(AlertDates * _Nonnull)alertDates {
    if (people.count == 0 || alertDates.dates.count == 0 || people.count != alertDates.dates.count) {
        return nil;
    }
    NSMutableOrderedSet<Choree *> *result = [NSMutableOrderedSet orderedSet];
    for (NSUInteger i = 0; i < alertDates.dates.count; i++) {
        [result addObject:[Choree choreeWithoutSaveWithPerson:people[i] chore:self alertDate:alertDates.dates[i]]];
    }
    return result;
}

@end
