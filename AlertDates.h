//
//  AlertDates.h
//  PeaceKeeper
//
//  Created by Work on 12/25/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chore.h"

@interface AlertDates : NSObject

@property (strong, nonatomic) NSArray<NSDate *> * _Nonnull dates;

+ (instancetype _Nullable)alertDatesForChore:(Chore * _Nonnull)chore withCount:(NSUInteger)count startIndex:(NSUInteger)startIndex;
+ (instancetype _Nullable)alertDatesWithCount:(NSUInteger)count startIndex:(NSUInteger)startIndex startDate:(NSDate * _Nonnull)startDate steppingInIntervalsOf:(NSUInteger)n calendarUnit:(NSCalendarUnit)calendarUnit;

- (instancetype _Nonnull)initWithDates:(NSArray<NSDate *> * _Nonnull)dates;
- (void)advanceByByIntervalAndUnitInChore:(Chore * _Nonnull)chore;
- (void)advanceBySteppingInIntervalOf:(NSUInteger)n calendarUnit:(NSCalendarUnit)calendarUnit;
- (NSInteger)indexOfEarliestDate;
- (NSInteger)indexOfLatestDate;
- (NSInteger)insertionIndexForLatestDate;
- (NSDate * _Nullable)alertDateAtIndex:(NSUInteger)index;

@end
