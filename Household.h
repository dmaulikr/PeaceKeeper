//
//  Household.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chore, Person;

NS_ASSUME_NONNULL_BEGIN

@interface Household : NSManagedObject

+ (NSString * _Nonnull)name;
+ (instancetype _Nonnull)householdWithName:(NSString * _Nonnull)name;

@end

NS_ASSUME_NONNULL_END

#import "Household+CoreDataProperties.h"
