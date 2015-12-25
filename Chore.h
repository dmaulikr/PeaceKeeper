//
//  Chore.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Household, Person;

NS_ASSUME_NONNULL_BEGIN

@interface Chore : NSManagedObject

+ (NSString *)name;
+ (instancetype)fetchChoreWithName:(NSString * _Nonnull)name;
+ (instancetype)choreWithName:(NSString * _Nonnull)name startDate:(NSDate * _Nonnull)startDate repeatIntervalValue:(NSNumber * _Nonnull)repeatIntervalValue repeatIntervalUnit:(NSString * _Nonnull)repeatIntervalUnit household:(Household * _Nonnull)household people:(NSOrderedSet *)people;
- (void)replacePeople:(NSOrderedSet<Person *> * _Nonnull)updatedPeople startIndex:(NSUInteger)startIndex;
- (void)replaceStartDate:(NSDate *)startDate repeatIntervalUnit:(NSString *)repeatIntervalUnit;
- (Person *)currentPerson;
- (void)completeChore;

@end

NS_ASSUME_NONNULL_END

#import "Chore+CoreDataProperties.h"
