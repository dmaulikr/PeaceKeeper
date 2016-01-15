//
//  Person+CoreDataProperties.h
//  PeaceKeeper
//
//  Created by Work on 1/15/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"
#import "Choree.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSSet<Choree *> *chorees;
@property (nullable, nonatomic, retain) NSSet<CompletedChore *> *completedChores;
@property (nullable, nonatomic, retain) Household *household;

@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addChoreesObject:(Choree *)value;
- (void)removeChoreesObject:(Choree *)value;
- (void)addChorees:(NSSet<Choree *> *)values;
- (void)removeChorees:(NSSet<Choree *> *)values;

- (void)addCompletedChoresObject:(CompletedChore *)value;
- (void)removeCompletedChoresObject:(CompletedChore *)value;
- (void)addCompletedChores:(NSSet<CompletedChore *> *)values;
- (void)removeCompletedChores:(NSSet<CompletedChore *> *)values;

@end

NS_ASSUME_NONNULL_END
