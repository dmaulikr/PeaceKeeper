//
//  TimeService.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "TimeService.h"
@import UIKit;

@implementation TimeService

+ (void)schedule:(NSUInteger)n notificationsEvery:(NSNumber *)m calendarUnit:(NSCalendarUnit)calendarUnit starting:(NSDate *)startDate {
    
}

+ (NSDate *)calculateMostRecentDateFrom:(NSDate *)startDate steppingInIntervalsOf:(NSNumber *)n unit:(NSCalendarUnit)unit {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *previousDate = startDate;
    NSDate *nextDate = [calendar dateByAddingUnit:unit value:n.integerValue toDate:startDate options:0];
    while (nextDate.timeIntervalSince1970 < startDate.timeIntervalSince1970) {
        previousDate = nextDate;
        nextDate = [calendar dateByAddingUnit:unit value:n.integerValue toDate:previousDate options:0];
    }
    return previousDate;
}


+ (void)timer {
    NSLog(@"Y");
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.0 target:self selector:@selector(printX) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

+ (void)printX {
    NSLog(@"X");
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertTitle = @"Timer Fired";
    notification.alertBody = @"OMG SRSLY!!!";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
