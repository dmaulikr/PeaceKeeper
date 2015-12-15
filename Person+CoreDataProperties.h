//
//  Person+CoreDataProperties.h
//  PeaceKeeper
//
//  Created by Work on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<Chore *> *chores;
@property (nullable, nonatomic, retain) Household *household;

@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addChoresObject:(Chore *)value;
- (void)removeChoresObject:(Chore *)value;
- (void)addChores:(NSSet<Chore *> *)values;
- (void)removeChores:(NSSet<Chore *> *)values;

@end

NS_ASSUME_NONNULL_END
