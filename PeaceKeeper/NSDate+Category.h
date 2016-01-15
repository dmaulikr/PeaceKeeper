//
//  NSDate+Category.h
//  PeaceKeeper
//
//  Created by Work on 12/25/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

- (BOOL)isInThePast;
- (NSString *)descriptionOfTimeToNowInDays;
- (NSString *)descriptionOfTimeToNowInDaysHoursOrMinutes;

@end
