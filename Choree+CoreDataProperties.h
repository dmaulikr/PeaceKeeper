//
//  Choree+CoreDataProperties.h
//  PeaceKeeper
//
//  Created by Work on 1/15/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Choree.h"

NS_ASSUME_NONNULL_BEGIN

@interface Choree (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *alertDate;
@property (nullable, nonatomic, retain) Chore *chore;
@property (nullable, nonatomic, retain) Person *person;

@end

NS_ASSUME_NONNULL_END
