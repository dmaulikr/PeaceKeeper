//
//  TimeService.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface TimeService : NSObject

+ (void)scheduleLocalNotificationInUsersTimeZoneAndCalendarWithFireDate:(NSDate * _Nonnull)fireDate repeatInterval:(NSCalendarUnit)repeatInterval alertTitle:(NSString * _Nonnull)alertTitle alertBody:(NSString * _Nonnull)alertBody userInfo:(NSDictionary * _Nonnull)userInfo;

+ (NSCalendarUnit)calendarUnitForString:(NSString * _Nonnull)target;

+ (NSCalendarUnit)calendarUnitFromValue:(NSValue * _Nonnull)value;

+ (NSValue * _Nullable)calendarUnitValueForString:(NSString * _Nonnull)target;
+ (NSString * _Nullable)stringForCalendarUnit:(NSValue * _Nonnull)target;

+ (NSArray<NSString *> *_Nonnull)calendarUnitStrings;
+ (NSArray<NSValue *> * _Nonnull)calendarUnits;

+ (void)schedule:(NSUInteger)n localNotifications:(UILocalNotification * _Nonnull)localNotification every:(NSUInteger)m calendarUnit:(NSCalendarUnit)calendarUnit starting:(NSDate * _Nonnull)startDate;
+ (NSDate * _Nullable)calculateMostRecentDateFrom:(NSDate * _Nonnull)startDate steppingInIntervalsOf:(NSUInteger)n unit:(NSCalendarUnit)unit;

@end
