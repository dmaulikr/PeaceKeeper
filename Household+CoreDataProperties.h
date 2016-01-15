//
//  Household+CoreDataProperties.h
//  PeaceKeeper
//
//  Created by Work on 1/15/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Household.h"

NS_ASSUME_NONNULL_BEGIN

@interface Household (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Chore *> *chores;
@property (nullable, nonatomic, retain) NSSet<CompletedChore *> *completedChores;
@property (nullable, nonatomic, retain) NSSet<Person *> *people;

@end

@interface Household (CoreDataGeneratedAccessors)

- (void)addChoresObject:(Chore *)value;
- (void)removeChoresObject:(Chore *)value;
- (void)addChores:(NSSet<Chore *> *)values;
- (void)removeChores:(NSSet<Chore *> *)values;

- (void)addCompletedChoresObject:(CompletedChore *)value;
- (void)removeCompletedChoresObject:(CompletedChore *)value;
- (void)addCompletedChores:(NSSet<CompletedChore *> *)values;
- (void)removeCompletedChores:(NSSet<CompletedChore *> *)values;

- (void)addPeopleObject:(Person *)value;
- (void)removePeopleObject:(Person *)value;
- (void)addPeople:(NSSet<Person *> *)values;
- (void)removePeople:(NSSet<Person *> *)values;

@end

NS_ASSUME_NONNULL_END
