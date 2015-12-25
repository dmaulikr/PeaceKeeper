//
//  TimeService.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "TimeService.h"
#import "Constants.h"

@interface TimeService ()

@end

@implementation TimeService

+ (NSArray<NSDate *> * _Nonnull)alertDatesForChore:(Chore * _Nonnull)chore withStartIndex:(NSUInteger)startIndex {
    return [self alertDatesWithCount:chore.people.count startIndex:startIndex startDate:chore.startDate steppingInIntervalsOf:chore.repeatIntervalValue.integerValue calendarUnit:[self calendarUnitForString:chore.repeatIntervalUnit]];
}

+ (NSInteger)insertionIndexForLatestDateInAlertDates:(NSArray<NSDate *> * _Nonnull)alertDates {
    if (alertDates.count == 0) {
        return NSNotFound;
    }
    NSInteger earliest = [self indexOfEarliestDateInAlertDates:alertDates];
    if (earliest == 0) {
        return alertDates.count;
    }
    return earliest;
}

+ (NSInteger)indexOfEarliestDateInAlertDates:(NSArray<NSDate *> * _Nonnull)alertDates {
    if (alertDates.count == 0) {
        return NSNotFound;
    }
    if (alertDates.count == 1) {
        return 0;
    }
    NSInteger result = 0;
    for (NSUInteger i = 1; i < alertDates.count; i++) {
        if (alertDates[i].timeIntervalSinceReferenceDate < alertDates[result].timeIntervalSinceReferenceDate) {
            result = i;
        }
    }
    return result;
}

+ (NSInteger)indexOfLatestDateInAlertDates:(NSArray<NSDate *> * _Nonnull)alertDates {
    if (alertDates.count == 0) {
        return NSNotFound;
    }
    if (alertDates.count == 1) {
        return 0;
    }
    NSInteger result = 0;
    for (NSUInteger i = 1; i < alertDates.count; i++) {
        if (alertDates[i].timeIntervalSinceReferenceDate > alertDates[result].timeIntervalSinceReferenceDate) {
            result = i;
        }
    }
    return result;
}


+ (NSArray<NSDate *> * _Nonnull)advanceAlertDates:(NSArray<NSDate *> * _Nonnull)alertDates steppingInIntervalsOf:(NSUInteger)n calendarUnit:(NSCalendarUnit)calendarUnit {
    if (alertDates.count == 0) {
        return alertDates;
    }
    
    NSInteger earliest = [TimeService indexOfEarliestDateInAlertDates:alertDates];
    NSInteger latest = [TimeService indexOfLatestDateInAlertDates:alertDates];
    
    NSMutableArray *mutableResult = [NSMutableArray arrayWithArray:alertDates];
    
    mutableResult[earliest] = [[NSCalendar currentCalendar] dateByAddingUnit:calendarUnit value:n toDate:alertDates[latest] options:0];

    return mutableResult;
}

+ (NSArray<NSDate *> * _Nonnull)alertDatesWithCount:(NSUInteger)count startIndex:(NSUInteger)startIndex startDate:(NSDate * _Nonnull)startDate steppingInIntervalsOf:(NSUInteger)n calendarUnit:(NSCalendarUnit)calendarUnit {
    if (count == 0) {
        return @[];
    }
    if (startIndex > count - 1) {
        return @[];
    }
    
    NSMutableArray *mutableResult = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        [mutableResult addObject:[NSNull null]];
    }
        
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *alertDate = startDate;
    for (NSUInteger i = startIndex; i < (startIndex + count); i++) {
        NSUInteger index = i % count;
        mutableResult[index] = alertDate;
        alertDate = [cal dateByAddingUnit:calendarUnit value:n toDate:alertDate options:0];
    }
    
    // FIXME
    for (NSUInteger i = 0; i < count; i++) {
        NSLog(@"%@", mutableResult[i]);
        NSAssert([mutableResult[i] isKindOfClass:[NSDate class]], @"Resulting array must all be of type NSDate!");
    }
    
    return mutableResult;
}

+ (void)removeChoreNotificationsWithName:(NSString * _Nonnull)choreName {
    NSMutableArray<UILocalNotification *> *matches = [NSMutableArray array];
    for (UILocalNotification *ln in [UIApplication sharedApplication].scheduledLocalNotifications) {
        NSString *value = [ln.userInfo valueForKey:kChoreNameKey];
        if (value && [value isEqualToString:choreName]) {
            [matches addObject:ln];
        }
    }
    for (UILocalNotification *ln in matches) {
        [[UIApplication sharedApplication] cancelLocalNotification:ln];
    }
}

+ (void)scheduleNotificationForChore:(Chore * _Nonnull)chore {
    NSCalendarUnit repeatInterval = [TimeService calendarUnitForString:chore.repeatIntervalUnit];
    NSString *alertTitle = [NSString stringWithFormat:@"“%@” Due", chore.name];
    NSString *alertBody = [NSString stringWithFormat:@"“%@” is due today. Next alert in one %@", chore.name, [chore.repeatIntervalUnit lowercaseString]];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:chore.name forKey:kChoreNameKey];
    [TimeService scheduleLocalNotificationInUsersTimeZoneAndCalendarWithFireDate:chore.startDate repeatInterval:repeatInterval alertTitle:alertTitle alertBody:alertBody userInfo:userInfo category:kChoreNotificationCategoryIdentifier];
}

+ (void)scheduleLocalNotificationInUsersTimeZoneAndCalendarWithFireDate:(NSDate * _Nonnull)fireDate repeatInterval:(NSCalendarUnit)repeatInterval alertTitle:(NSString * _Nonnull)alertTitle alertBody:(NSString * _Nonnull)alertBody userInfo:(NSDictionary * _Nonnull)userInfo category:(NSString * _Nonnull)category {
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    ln.timeZone = [NSTimeZone localTimeZone];
    ln.repeatCalendar = [NSCalendar currentCalendar];
    ln.fireDate = fireDate;
    ln.repeatInterval = repeatInterval;
    ln.alertTitle = alertTitle;
    ln.alertBody = alertBody;
    ln.userInfo = userInfo;
    ln.category = category;
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
}

+ (NSCalendarUnit)calendarUnitForString:(NSString * _Nonnull)target {
    NSCalendarUnit result;
    NSValue *calendarValue = [self calendarUnitValueForString:target];
    if (calendarValue) {
        result = [TimeService calendarUnitFromValue:calendarValue];
    } else {
        NSLog(@"Error: no calendar value retrieved for string %@. The result of this method may be garbage. Result as unsigned long: %lu.", target, (unsigned long)result);
    }
    return result;
}

+ (NSCalendarUnit)calendarUnitFromValue:(NSValue * _Nonnull)valueObject {
    NSCalendarUnit buffer;
    [valueObject getValue:&buffer];
    return buffer;
}

+ (NSValue * _Nullable)calendarUnitValueForString:(NSString * _Nonnull)target {
    NSArray<NSString *> *calendarUnitStrings = [self calendarUnitStrings];
    NSUInteger index = [calendarUnitStrings indexOfObject:target];
    if (index == NSNotFound) {
        return nil;
    }
    return [self calendarUnits][index];
}

+ (NSString * _Nullable)stringForCalendarUnit:(NSValue * _Nonnull)target {
    NSArray<NSValue *> *calendarUnits = [self calendarUnits];
    NSUInteger index = [calendarUnits indexOfObject:target];
    if (index == NSNotFound) {
        return nil;
    }
    return [self calendarUnitStrings][index];
}

+ (NSArray<NSString *> * _Nonnull)calendarUnitStrings {
    return @[@"Minute", // FIXME
             @"Hour", // FIXME
             @"Day",
             @"Week",
             @"Month",
             @"Year"];
}

+ (NSArray<NSValue *> * _Nonnull)calendarUnits {
    NSCalendarUnit minute = NSCalendarUnitMinute; // FIXME
    NSCalendarUnit hour = NSCalendarUnitHour; // FIXME
    NSCalendarUnit day = NSCalendarUnitDay;
    NSCalendarUnit week = NSCalendarUnitWeekOfYear;
    NSCalendarUnit month = NSCalendarUnitMonth;
    NSCalendarUnit year = NSCalendarUnitYear;

    return @[[NSValue value:&minute withObjCType:@encode(NSCalendarUnit)], // FIXME
             [NSValue value:&hour withObjCType:@encode(NSCalendarUnit)], // FIXME
             [NSValue value:&day withObjCType:@encode(NSCalendarUnit)],
             [NSValue value:&week withObjCType:@encode(NSCalendarUnit)],
             [NSValue value:&month withObjCType:@encode(NSCalendarUnit)],
             [NSValue value:&year withObjCType:@encode(NSCalendarUnit)]];
}

+ (void)schedule:(NSUInteger)n localNotifications:(UILocalNotification * _Nonnull)localNotification every:(NSUInteger)m calendarUnit:(NSCalendarUnit)calendarUnit startingOn:(NSDate * _Nonnull)startDate {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    for (NSUInteger i = 0; i < n; i++) {
        UILocalNotification *notification = localNotification.copy;
        notification.fireDate = startDate;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        startDate = [calendar dateByAddingUnit:calendarUnit value:m toDate:startDate options:0];
    }
}

+ (NSDate * _Nonnull)calculateMostRecentDateBySteppingInIntervalsOf:(NSUInteger)n unit:(NSCalendarUnit)unit fromStartDate:(NSDate * _Nonnull)startDate {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *previousDate = startDate;
    NSDate *nextDate = [calendar dateByAddingUnit:unit value:n toDate:startDate options:0];
    while (nextDate.timeIntervalSinceNow < 0) {
        previousDate = nextDate;
        nextDate = [calendar dateByAddingUnit:unit value:n toDate:previousDate options:0];
    }
    return previousDate;
}

@end
