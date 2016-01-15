//
//  Chore+CoreDataProperties.h
//  PeaceKeeper
//
//  Created by Work on 1/15/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chore.h"
#import "Choree.h"
#import "CompletedChore.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chore (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *alertsEnabled;
@property (nullable, nonatomic, retain) NSString *imageName;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *repeatIntervalUnit;
@property (nullable, nonatomic, retain) NSNumber *repeatIntervalValue;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSOrderedSet<Choree *> *chorees;
@property (nullable, nonatomic, retain) NSSet<CompletedChore *> *completedChores;
@property (nullable, nonatomic, retain) Household *household;

@end

@interface Chore (CoreDataGeneratedAccessors)

- (void)insertObject:(Choree *)value inChoreesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChoreesAtIndex:(NSUInteger)idx;
- (void)insertChorees:(NSArray<Choree *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChoreesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChoreesAtIndex:(NSUInteger)idx withObject:(Choree *)value;
- (void)replaceChoreesAtIndexes:(NSIndexSet *)indexes withChorees:(NSArray<Choree *> *)values;
- (void)addChoreesObject:(Choree *)value;
- (void)removeChoreesObject:(Choree *)value;
- (void)addChorees:(NSOrderedSet<Choree *> *)values;
- (void)removeChorees:(NSOrderedSet<Choree *> *)values;

- (void)addCompletedChoresObject:(CompletedChore *)value;
- (void)removeCompletedChoresObject:(CompletedChore *)value;
- (void)addCompletedChores:(NSSet<CompletedChore *> *)values;
- (void)removeCompletedChores:(NSSet<CompletedChore *> *)values;

@end

NS_ASSUME_NONNULL_END
