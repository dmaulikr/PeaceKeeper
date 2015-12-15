//
//  Household+CoreDataProperties.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Household.h"
#import "CompletedChore.h"

NS_ASSUME_NONNULL_BEGIN

@interface Household (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Chore *> *chores;
@property (nullable, nonatomic, retain) NSSet<Person *> *people;
@property (nullable, nonatomic, retain) NSSet<CompletedChore *> *archive;

@end

@interface Household (CoreDataGeneratedAccessors)

- (void)addChoresObject:(Chore *)value;
- (void)removeChoresObject:(Chore *)value;
- (void)addChores:(NSSet<Chore *> *)values;
- (void)removeChores:(NSSet<Chore *> *)values;

- (void)addPeopleObject:(Person *)value;
- (void)removePeopleObject:(Person *)value;
- (void)addPeople:(NSSet<Person *> *)values;
- (void)removePeople:(NSSet<Person *> *)values;

- (void)addArchiveObject:(CompletedChore *)value;
- (void)removeArchiveObject:(CompletedChore *)value;
- (void)addArchive:(NSSet<CompletedChore *> *)values;
- (void)removeArchive:(NSSet<CompletedChore *> *)values;

@end

NS_ASSUME_NONNULL_END
