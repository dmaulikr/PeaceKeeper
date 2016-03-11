//
//  AlertDates.m
//  PeaceKeeper
//
//  Created by Work on 12/25/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "AlertDates.h"
#import "TimeService.h"

@implementation AlertDates

+ (instancetype _Nullable)alertDatesForChore:(Chore * _Nonnull)chore withCount:(NSUInteger)count startIndex:(NSUInteger)startIndex {
    return [self alertDatesWithCount:count startIndex:startIndex startDate:chore.startDate steppingInIntervalsOf:chore.repeatIntervalValue.integerValue calendarUnit:[TimeService calendarUnitForString:chore.repeatIntervalUnit]];
}

+ (instancetype _Nullable)alertDatesWithCount:(NSUInteger)count startIndex:(NSUInteger)startIndex startDate:(NSDate * _Nonnull)startDate steppingInIntervalsOf:(NSUInteger)n calendarUnit:(NSCalendarUnit)calendarUnit {
    if (count == 0) {
        return nil;
    }
    if (startIndex > count - 1) {
        return nil;
    }
    
    NSMutableArray *mutableDates = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        [mutableDates addObject:[NSNull null]];
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *alertDate = startDate;
    for (NSUInteger i = startIndex; i < (startIndex + count); i++) {
        NSUInteger index = i % count;
        mutableDates[index] = alertDate;
        alertDate = [cal dateByAddingUnit:calendarUnit value:n toDate:alertDate options:0];
    }
        
    return [[AlertDates alloc] initWithDates:mutableDates];
}

- (instancetype _Nonnull)initWithDates:(NSArray<NSDate *> * _Nonnull)dates {
    self = [super init];
    if (self) {
        _dates = dates;
    }
    return self;
}

- (void)advanceByByIntervalAndUnitInChore:(Chore * _Nonnull)chore {
    [self advanceBySteppingInIntervalOf:chore.repeatIntervalValue.integerValue calendarUnit:[TimeService calendarUnitForString:chore.repeatIntervalUnit]];
}

- (void)advanceBySteppingInIntervalOf:(NSUInteger)n calendarUnit:(NSCalendarUnit)calendarUnit {
    if (self.dates.count == 0) {
        return;
    }
    
    NSInteger earliest = [self indexOfEarliestDate];
    NSInteger latest = [self indexOfLatestDate];
    
    NSMutableArray *mutableDates = [NSMutableArray arrayWithArray:self.dates];
    
    mutableDates[earliest] = [[NSCalendar currentCalendar] dateByAddingUnit:calendarUnit value:n toDate:self.dates[latest] options:0];
    
    self.dates = mutableDates;
}

- (NSInteger)indexOfEarliestDate {
    if (self.dates.count == 0) {
        return NSNotFound;
    }
    if (self.dates.count == 1) {
        return 0;
    }
    NSInteger result = 0;
    for (NSUInteger i = 1; i < self.dates.count; i++) {
        if (self.dates[i].timeIntervalSinceReferenceDate < self.dates[result].timeIntervalSinceReferenceDate) {
            result = i;
        }
    }
    return result;
}

- (NSInteger)indexOfLatestDate {
    if (self.dates.count == 0) {
        return NSNotFound;
    }
    if (self.dates.count == 1) {
        return 0;
    }
    NSInteger result = 0;
    for (NSUInteger i = 1; i < self.dates.count; i++) {
        if (self.dates[i].timeIntervalSinceReferenceDate > self.dates[result].timeIntervalSinceReferenceDate) {
            result = i;
        }
    }
    return result;
}

- (NSInteger)insertionIndexForLatestDate {
    if (self.dates.count == 0) {
        return NSNotFound;
    }
    NSInteger earliest = [self indexOfEarliestDate];
    if (earliest == 0) {
        return self.dates.count;
    }
    return earliest;
}

- (NSDate *)alertDateAtIndex:(NSUInteger)index {
    if (index > self.dates.count - 1) {
        return nil;
    }
    return self.dates[index];
}

@end
