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

@implementation Chore

+ (NSString *)name {
    return @"Chore";
}

+ (instancetype)choreWithName:(NSString * _Nonnull)name startDate:(NSDate * _Nonnull)startDate repeatIntervalValue:(NSNumber * _Nonnull)repeatIntervalValue repeatIntervalUnit:(NSString * _Nonnull)repeatIntervalUnit household:(Household * _Nonnull)household {
    Chore *chore = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[NSManagedObjectContext managedObjectContext]];
    chore.name = name;
    chore.startDate = startDate;
    chore.repeatIntervalValue = repeatIntervalValue;
    chore.repeatIntervalUnit = repeatIntervalUnit;
    chore.household = household;
    chore.currentPersonIndex = @(0);
    chore.people = [NSOrderedSet orderedSet];
    [NSManagedObjectContext saveManagedObjectContext];
    return chore;
}

- (void)completeChore {
    [self.household addArchiveObject:[CompletedChore completedChoreWithCompletionDate:[NSDate date] chore:self person:[self.people objectAtIndex:self.currentPersonIndex.integerValue]]];
    
    NSInteger currentPersonIndexValue = self.currentPersonIndex.integerValue;
    if (currentPersonIndexValue >= [self.people count] - 1) {
        self.currentPersonIndex = @(0);
    } else {
        self.currentPersonIndex = @(currentPersonIndexValue++);
    }
    [NSManagedObjectContext saveManagedObjectContext];
}

@end
