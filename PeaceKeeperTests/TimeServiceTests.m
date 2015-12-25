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
@property (strong, nonatomic) NSDate *today;
@property (strong, nonatomic) NSDate *oneDayAgo;
@property (strong, nonatomic) NSDate *twoDaysAgo;
@property (strong, nonatomic) NSDate *threeDaysAgo;
@property (strong, nonatomic) NSDate *fourDaysAgo;

@end

@implementation TimeServiceTests

- (void)setUp {
    [super setUp];
    self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.today = [NSDate date];
    self.oneDayAgo = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:self.today options:0];
    self.twoDaysAgo = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:self.today options:0];
    self.threeDaysAgo = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-3 toDate:self.today options:0];
    self.fourDaysAgo = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-4 toDate:self.today options:0];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.calendar = nil;
    self.today = nil;
    self.oneDayAgo = nil;
    self.twoDaysAgo = nil;
    self.threeDaysAgo = nil;
    self.fourDaysAgo = nil;
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
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitWeekOfYear fromStartDate:self.oneDayAgo];
    XCTAssertTrue([self.oneDayAgo isEqualToDate:result]);
}

- (void)testThatCalculateMostRecentDateBySteppingClassMethodReturnsTheCorrectDateInOneInstance {
    NSDate *oneDayAndFourMonthsAgo = [self.calendar dateByAddingUnit:NSCalendarUnitMonth value:-4 toDate:self.oneDayAgo options:0];
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitMonth fromStartDate:oneDayAndFourMonthsAgo];
    XCTAssertTrue([self.oneDayAgo isEqualToDate:result]);
}

#pragma mark - alertDatesWith... class method

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

#pragma mark - indexOfEarliest/LatestDateInAlertDates: class methods

- (void)testThatIndexOfEarliestDateInAlertDateFindsTheEarliestDate {
    NSInteger indexOfEarliest = 2;
    NSArray<NSDate *> *alertDates = @[self.oneDayAgo, self.twoDaysAgo, self.threeDaysAgo];
    NSInteger result = [TimeService indexOfEarliestDateInAlertDates:alertDates];
    XCTAssertEqual(result, indexOfEarliest);
}

- (void)testThatIndexOfLatestDateInAlertDateFindsTheLatestDate {
    NSInteger indexOfLatest = 2;
    NSArray<NSDate *> *alertDates = @[self.threeDaysAgo, self.twoDaysAgo, self.oneDayAgo];
    NSInteger result = [TimeService indexOfLatestDateInAlertDates:alertDates];
    XCTAssertEqual(result, indexOfLatest);
}

#pragma mark - advanceAlertDates... class method

- (void)testThatAdvanceAlertDatesAdvances {
    NSUInteger n = 1;
    NSCalendarUnit unit = NSCalendarUnitDay;
    NSArray<NSDate *> *initialDates = @[self.twoDaysAgo, self.threeDaysAgo, self.fourDaysAgo];
    NSArray<NSDate *> *targetDates = @[self.twoDaysAgo, self.threeDaysAgo, self.oneDayAgo];
    NSArray<NSDate *> *resultDates = [TimeService advanceAlertDates:initialDates steppingInIntervalsOf:n calendarUnit:unit];
    for (NSUInteger i = 0; i < targetDates.count; i++) {
        XCTAssertTrue([resultDates[i] isEqualToDate: targetDates[i]]);
    }
}

#pragma mark - insertionIndexForLatestDateInAlertDates: class method

- (void)testThatInsertionIndexForLatestDateInAlertDatesChoosesCorrectIndexWhenIndexIsInMiddleOfAlertDates {
    NSArray<NSDate *> *alertDates = @[self.oneDayAgo, self.today, self.fourDaysAgo, self.threeDaysAgo, self.twoDaysAgo];
    NSInteger target = 2;
    NSInteger result = [TimeService insertionIndexForLatestDateInAlertDates:alertDates];
    XCTAssertEqual(result, target);
}

- (void)testThatInsertionIndexForLatestDateInAlertDatesChoosesCorrectIndexWhenIndexIsAfterLastIndex {
    NSArray<NSDate *> *alertDates = @[self.fourDaysAgo, self.threeDaysAgo, self.twoDaysAgo, self.oneDayAgo, self.today];
    NSInteger target = 5;
    NSInteger result = [TimeService insertionIndexForLatestDateInAlertDates:alertDates];
    XCTAssertEqual(result, target);
}

@end
