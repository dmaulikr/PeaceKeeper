//
//  TimeServiceTests.m
//  PeaceKeeper
//
//  Created by Work on 12/23/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TimeService.h"

@interface TimeServiceTests : XCTestCase

@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation TimeServiceTests

- (void)setUp {
    [super setUp];
    self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.calendar = nil;
}

- (void)alwaysTrueTest {
    XCTAssertTrue(true);
}

#pragma mark - calculateMostRecentDateByStepping... class method

- (void)testThatCalculateMostRecentDateBySteppingClassMethodReturnsStartDateIfStartDateIsAfterToCurrentDate {
    NSDate *oneYearFromToday = [self.calendar dateByAddingUnit:NSCalendarUnitYear value:1 toDate:[NSDate date] options:0];
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitYear fromStartDate:oneYearFromToday];
    XCTAssertTrue([oneYearFromToday isEqualToDate:result]);
}

- (void)testThatCalculateMostRecentDateBySteppingClassMethodReturnsStartDateIfStartDateIsEqualToCurrentDate {
    NSDate *rightNow = [NSDate date];
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitYear fromStartDate:rightNow];
    XCTAssertTrue([rightNow isEqualToDate:result]);
}

- (void)testThatCalculateMostRecentDateBySteppingClassMethodReturnsStartDateIfTheDifferenceBetweenStartDateAndNowIsSmallerThanTheUnit {
    NSDate *oneDayAgo = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0];
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitWeekOfYear fromStartDate:oneDayAgo];
    XCTAssertTrue([oneDayAgo isEqualToDate:result]);
}

- (void)testThatCalculateMostRecentDateBySteppingClassMethodReturnsTheCorrectDateInOneInstance {
    NSDate *oneDayAgo = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0];
    NSDate *oneDayAndFourMonthsAgo = [self.calendar dateByAddingUnit:NSCalendarUnitMonth value:-4 toDate:oneDayAgo options:0];
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitMonth fromStartDate:oneDayAndFourMonthsAgo];
    XCTAssertTrue([oneDayAgo isEqualToDate:result]);
}

#pragma mark - alertDatesWith... class method

//+ (NSArray<NSDate *> * _Nonnull)alertDatesWithCount:(NSUInteger)count startIndex:(NSUInteger)startIndex startDate:(NSDate * _Nonnull)startDate steppingInIntervalsOf:(NSUInteger)n calendarUnit:(NSCalendarUnit)calendarUnit

- (void)testThatAlertDatesWithClassMethodsCountParameterReturnsASameSizedArray {
    NSUInteger count = 5;
    NSArray<NSDate *> *result = [TimeService alertDatesWithCount:count startIndex:0 startDate:[NSDate date] steppingInIntervalsOf:1 calendarUnit:NSCalendarUnitDay];
    XCTAssertEqual(count, result.count);
}

- (void)testThatAlertDatesWithClassMethodsValueAtStartIndexIsTheSameAsStartDate {
    NSUInteger count = 5;
    NSUInteger startIndex = 2;
    NSDate *startDate = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0];
    NSArray<NSDate *> *result = [TimeService alertDatesWithCount:count startIndex:startIndex startDate:startDate steppingInIntervalsOf:1 calendarUnit:NSCalendarUnitDay];
    XCTAssertTrue([startDate isEqualToDate:result[startIndex]]);
}

@end
