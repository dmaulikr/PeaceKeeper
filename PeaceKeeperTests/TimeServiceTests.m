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

@end
