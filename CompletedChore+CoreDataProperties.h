//
//  CompletedChore+CoreDataProperties.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompletedChore.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompletedChore (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *completionDate;
@property (nullable, nonatomic, retain) Chore *chore;
@property (nullable, nonatomic, retain) Person *person;

@end

NS_ASSUME_NONNULL_END
