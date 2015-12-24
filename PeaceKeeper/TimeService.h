//
//  TimeService.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

@import UIKit;
#import "Chore.h"

@interface TimeService : NSObject

+ (NSArray<NSDate *> * _Nonnull)alertDatesWithCount:(NSUInteger)count startIndex:(NSUInteger)startIndex startDate:(NSDate * _Nonnull)startDate steppingInIntervalsOf:(NSUInteger)n calendarUnit:(NSCalendarUnit)calendarUnit;

+ (void)removeChoreNotificationsWithName:(NSString * _Nonnull)choreName;

+ (void)scheduleNotificationForChore:(Chore * _Nonnull)chore;

+ (void)scheduleLocalNotificationInUsersTimeZoneAndCalendarWithFireDate:(NSDate * _Nonnull)fireDate repeatInterval:(NSCalendarUnit)repeatInterval alertTitle:(NSString * _Nonnull)alertTitle alertBody:(NSString * _Nonnull)alertBody userInfo:(NSDictionary * _Nonnull)userInfo category:(NSString * _Nonnull)category;

+ (NSCalendarUnit)calendarUnitForString:(NSString * _Nonnull)target;

+ (NSCalendarUnit)calendarUnitFromValue:(NSValue * _Nonnull)value;

+ (NSValue * _Nullable)calendarUnitValueForString:(NSString * _Nonnull)target;
+ (NSString * _Nullable)stringForCalendarUnit:(NSValue * _Nonnull)target;

+ (NSArray<NSString *> * _Nonnull)calendarUnitStrings;
+ (NSArray<NSValue *> * _Nonnull)calendarUnits;

+ (void)schedule:(NSUInteger)n localNotifications:(UILocalNotification * _Nonnull)localNotification every:(NSUInteger)m calendarUnit:(NSCalendarUnit)calendarUnit startingOn:(NSDate * _Nonnull)startDate;
+ (NSDate * _Nonnull)calculateMostRecentDateBySteppingInIntervalsOf:(NSUInteger)n unit:(NSCalendarUnit)unit fromStartDate:(NSDate * _Nonnull)startDate;

@end
