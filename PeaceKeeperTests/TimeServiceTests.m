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

- (void)testThatCalculateMostRecentDateBySteppingClassMethodReturnsStartDateIfStartDateIsAfterOrEqualToCurrentDate {
    NSDate *oneYearFromToday = [self.calendar dateByAddingUnit:NSCalendarUnitYear value:1 toDate:[NSDate date] options:0];
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitYear fromStartDate:oneYearFromToday];
    XCTAssertTrue([oneYearFromToday isEqualToDate:result]);
}

- (void)testThatCalculateMostRecentDateBySteppingClassMethodReturnsStartDateIfTheDifferenceBetweenStartDateAndNowIsSmallerThanTheUnit {
    NSDate *oneDayAgo = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0];
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitWeekOfYear fromStartDate:oneDayAgo];
    XCTAssertTrue([oneDayAgo isEqualToDate:result]);
}

- (void)testThatCalculateMostRecentDateBySteppingClassMethodReturnsTheCorrectDate {
    NSDate *oneDayAgo = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0];
    NSDate *oneDayAndFourMonthsAgo = [self.calendar dateByAddingUnit:NSCalendarUnitMonth value:-4 toDate:oneDayAgo options:0];
    NSDate *result = [TimeService calculateMostRecentDateBySteppingInIntervalsOf:1 unit:NSCalendarUnitMonth fromStartDate:oneDayAndFourMonthsAgo];
    XCTAssertTrue([oneDayAgo isEqualToDate:result]);
}

@end
