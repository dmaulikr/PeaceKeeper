//
//  PeaceKeeperTests.m
//  PeaceKeeperTests
//
//  Created by Francisco Ragland Jr on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TimeService.h"

@interface PeaceKeeperTests : XCTestCase

@end

@implementation PeaceKeeperTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatMostRecentDateMethodReturnsAnIntervalLessThanGivenUnitAndValue {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit weekUnit = NSWeekCalendarUnit;
    NSDate *today = [NSDate date];
    NSDate *twoWeeksAgo = [calendar dateByAddingUnit:weekUnit value:-2 toDate:today options:0];
    NSDate *fiveWeeksAgo = [calendar dateByAddingUnit:weekUnit value:-5 toDate:today options:0];
    NSDate *mostRecentDateMethodResult = [TimeService calculateMostRecentDateFrom:fiveWeeksAgo steppingInIntervalsOf:@(2) unit:weekUnit];
    XCTAssertGreaterThanOrEqual(mostRecentDateMethodResult.timeIntervalSince1970, twoWeeksAgo.timeIntervalSince1970);
}

@end
