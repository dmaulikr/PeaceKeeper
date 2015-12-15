//
//  TimeService.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "TimeService.h"

@implementation TimeService

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
