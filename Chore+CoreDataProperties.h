//
//  Chore+CoreDataProperties.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chore.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chore (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *currentPersonIndex;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *repeatIntervalUnit;
@property (nullable, nonatomic, retain) NSNumber *repeatIntervalValue;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) Household *household;
@property (nullable, nonatomic, retain) NSOrderedSet<Person *> *people;

@end

@interface Chore (CoreDataGeneratedAccessors)

- (void)insertObject:(Person *)value inPeopleAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPeopleAtIndex:(NSUInteger)idx;
- (void)insertPeople:(NSArray<Person *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePeopleAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPeopleAtIndex:(NSUInteger)idx withObject:(Person *)value;
- (void)replacePeopleAtIndexes:(NSIndexSet *)indexes withPeople:(NSArray<Person *> *)values;
- (void)addPeopleObject:(Person *)value;
- (void)removePeopleObject:(Person *)value;
- (void)addPeople:(NSOrderedSet<Person *> *)values;
- (void)removePeople:(NSOrderedSet<Person *> *)values;

@end

NS_ASSUME_NONNULL_END
