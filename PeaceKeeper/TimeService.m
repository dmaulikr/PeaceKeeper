//
//  TimeService.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "TimeService.h"

@interface TimeService ()

@end

@implementation TimeService

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
    return @[@"Day",
             @"Week",
             @"Month",
             @"Year"];
}

+ (NSArray<NSValue *> * _Nonnull)calendarUnits {
    NSCalendarUnit day = NSCalendarUnitDay;
    NSCalendarUnit week = NSCalendarUnitWeekOfYear;
    NSCalendarUnit month = NSCalendarUnitMonth;
    NSCalendarUnit year = NSCalendarUnitYear;

    return @[[NSValue value:&day withObjCType:@encode(NSCalendarUnit)],
             [NSValue value:&week withObjCType:@encode(NSCalendarUnit)],
             [NSValue value:&month withObjCType:@encode(NSCalendarUnit)],
             [NSValue value:&year withObjCType:@encode(NSCalendarUnit)]];
}

+ (void)schedule:(NSUInteger)n localNotifications:(UILocalNotification * _Nonnull)localNotification every:(NSUInteger)m calendarUnit:(NSCalendarUnit)calendarUnit starting:(NSDate * _Nonnull)startDate {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    for (NSUInteger i = 0; i < n; i++) {
        UILocalNotification *notification = localNotification.copy;
        notification.fireDate = startDate;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        startDate = [calendar dateByAddingUnit:calendarUnit value:m toDate:startDate options:0];
    }
}

+ (NSDate * _Nullable)calculateMostRecentDateFrom:(NSDate * _Nonnull)startDate steppingInIntervalsOf:(NSUInteger)n unit:(NSCalendarUnit)unit {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *previousDate = startDate;
    NSDate *nextDate = [calendar dateByAddingUnit:unit value:n toDate:startDate options:0];
    while (nextDate.timeIntervalSince1970 < startDate.timeIntervalSince1970) {
        previousDate = nextDate;
        nextDate = [calendar dateByAddingUnit:unit value:n toDate:previousDate options:0];
    }
    return previousDate;
}

@end
