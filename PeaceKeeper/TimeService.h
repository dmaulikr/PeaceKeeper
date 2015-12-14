//
//  TimeService.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeService : NSObject

+ (void)timer;
+ (NSDate *)calculateMostRecentDateFrom:(NSDate *)startDate steppingInIntervalsOf:(NSNumber *)n unit:(NSCalendarUnit)unit;

@end
