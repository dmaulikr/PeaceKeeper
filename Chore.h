//
//  Chore.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Household, Person, AlertDates, Choree;

NS_ASSUME_NONNULL_BEGIN

@interface Chore : NSManagedObject

+ (NSString * _Nonnull)name;
+ (instancetype _Nonnull)choreWithName:(NSString * _Nonnull)name startDate:(NSDate * _Nonnull)startDate repeatIntervalValue:(NSNumber * _Nonnull)repeatIntervalValue repeatIntervalUnit:(NSString * _Nonnull)repeatIntervalUnit household:(Household * _Nonnull)household people:(NSOrderedSet *)people imageName:(NSString * _Nullable)imageName;
- (NSMutableOrderedSet<Person *> * _Nonnull)mutablePeople;
- (void)updateChoreesWithPeople:(NSOrderedSet<Person *> * _Nonnull)updatedPeople startingPerson:(Person * _Nonnull)startingPerson;
- (Person * _Nullable)currentPerson;
- (NSNumber * _Nullable)currentPersonIndex;
- (void)completeChore;
- (NSOrderedSet<Choree *> *_Nonnull)unrolledChorees;
- (NSDate * _Nullable)earliestAlertDate;
- (Choree * _Nullable)earliestChoree;

@end

NS_ASSUME_NONNULL_END

#import "Chore+CoreDataProperties.h"
