//
//  NSDate+Category.m
//  PeaceKeeper
//
//  Created by Work on 12/25/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

- (BOOL)isInThePast {
    if (self.timeIntervalSinceNow < 0) {
        return YES;
    }
    return NO;
}

- (NSString *)descriptionOfTimeToNowInDays {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];
    if ([cal isDate:self equalToDate:today toUnitGranularity:NSCalendarUnitDay]) {
        return @"Today";
    }
    
    NSDate *tomorrow = [cal dateByAddingUnit:NSCalendarUnitDay value:1 toDate:today options:0];
    if ([cal isDate:self equalToDate:tomorrow toUnitGranularity:NSCalendarUnitDay]) {
        return @"Tomorrow";
    }
    
    NSDate *yesterday = [cal dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:today options:0];
    if ([cal isDate:self equalToDate:yesterday toUnitGranularity:NSCalendarUnitDay]) {
        return @"Yesterday";
    }
    
    NSUInteger flags = NSCalendarUnitDay;
    NSDateComponents *components = [cal components:flags fromDate:today toDate:self options:0];
    if (!components) {
        return @"ERROR";
    }
    
    if (ABS(components.day) == 1) {
        return [NSString stringWithFormat:@"%ld day", (long)components.day];

    }
    return [NSString stringWithFormat:@"%ld days", (long)components.day];
}

- (NSString *)descriptionOfTimeToNowInDaysHoursOrMinutes {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger flags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [cal components:flags fromDate:[NSDate date] toDate:self options:0];
    
    if (components.day == 0 && components.hour == 0) {
        if (ABS(components.minute) == 1) {
            return [NSString stringWithFormat:@"%ld minute", (long)components.minute];
        }
        return [NSString stringWithFormat:@"%ld minutes", (long)components.minute];
    }
    
    if (components.day == 0) {
        if (ABS(components.hour) == 1) {
            return [NSString stringWithFormat:@"%ld hour", (long)components.hour];
        }
        return [NSString stringWithFormat:@"%ld hours", (long)components.hour];
    }
    
    if (ABS(components.day) == 1) {
        return [NSString stringWithFormat:@"%ld day", (long)components.day];
    }
    return [NSString stringWithFormat:@"%ld days", (long)components.day];
}

@end
