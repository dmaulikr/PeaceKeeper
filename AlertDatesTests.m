//
//  AlertDatesTests.m
//  PeaceKeeper
//
//  Created by Work on 12/25/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AlertDates.h"

@interface AlertDatesTests : XCTestCase

@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDate *today;
@property (strong, nonatomic) NSDate *oneDayAgo;
@property (strong, nonatomic) NSDate *twoDaysAgo;
@property (strong, nonatomic) NSDate *threeDaysAgo;
@property (strong, nonatomic) NSDate *fourDaysAgo;

@end

@implementation AlertDatesTests

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

#pragma mark - Convenience initializer

- (void)testThatConvenienceIntiailzersCountParameterReturnsASameSizedDates {
    NSUInteger count = 5;
    AlertDates *result = [AlertDates alertDatesWithCount:count startIndex:0 startDate:[NSDate date] steppingInIntervalsOf:1 calendarUnit:NSCalendarUnitDay];
    XCTAssertEqual(count, result.dates.count);
}

- (void)testThatConvenienceIntiailzersValueAtStartIndexIsTheSameAsStartDate {
    NSUInteger count = 5;
    NSUInteger startIndex = 2;
    NSDate *startDate = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0];
    AlertDates *result = [AlertDates alertDatesWithCount:count startIndex:startIndex startDate:startDate steppingInIntervalsOf:1 calendarUnit:NSCalendarUnitDay];
    XCTAssertTrue([startDate isEqualToDate:result.dates[startIndex]]);
}

#pragma mark - indexOfEarliest/LatestDate:

- (void)testThatIndexOfEarliestDateFindsTheEarliestDate {
    NSInteger indexOfEarliest = 2;
    AlertDates *alertDates = [[AlertDates alloc] initWithDates:@[self.oneDayAgo, self.twoDaysAgo, self.threeDaysAgo]];
    NSInteger result = [alertDates indexOfEarliestDate];
    XCTAssertEqual(result, indexOfEarliest);
}

- (void)testThatIndexOfLatestDateFindsTheLatestDate {
    NSInteger indexOfLatest = 2;
    AlertDates *alertDates = [[AlertDates alloc] initWithDates:@[self.threeDaysAgo, self.twoDaysAgo, self.oneDayAgo]];
    NSInteger result = [alertDates indexOfLatestDate];
    XCTAssertEqual(result, indexOfLatest);
}

#pragma mark - advance...

- (void)testThatAdvanceAlertDatesAdvances {
    NSUInteger n = 1;
    NSCalendarUnit unit = NSCalendarUnitDay;
    NSArray<NSDate *> *targetDates = @[self.twoDaysAgo, self.threeDaysAgo, self.oneDayAgo];
    AlertDates *alertDates = [[AlertDates alloc] initWithDates:@[self.twoDaysAgo, self.threeDaysAgo, self.fourDaysAgo]];
    [alertDates advanceBySteppingInIntervalOf:n calendarUnit:unit];
    for (NSUInteger i = 0; i < targetDates.count; i++) {
        XCTAssertTrue([alertDates.dates[i] isEqualToDate: targetDates[i]]);
    }
}

#pragma mark - insertionIndexForLatestDate

- (void)testThatInsertionIndexForLatestDateInAlertDatesChoosesCorrectIndexWhenIndexIsInMiddleOfAlertDates {
    AlertDates *alertDates = [[AlertDates alloc] initWithDates:@[self.oneDayAgo, self.today, self.fourDaysAgo, self.threeDaysAgo, self.twoDaysAgo]];
    NSInteger target = 2;
    NSInteger result = [alertDates insertionIndexForLatestDate];
    XCTAssertEqual(result, target);
}

- (void)testThatInsertionIndexForLatestDateInAlertDatesChoosesCorrectIndexWhenIndexIsAfterLastIndex {
    AlertDates *alertDates = [[AlertDates alloc] initWithDates:@[self.fourDaysAgo, self.threeDaysAgo, self.twoDaysAgo, self.oneDayAgo, self.today]];
    NSInteger target = 5;
    NSInteger result = [alertDates insertionIndexForLatestDate];
    XCTAssertEqual(result, target);
}

@end
