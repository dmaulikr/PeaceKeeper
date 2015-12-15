//
//  CompletedChore.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chore, Person;

NS_ASSUME_NONNULL_BEGIN

@interface CompletedChore : NSManagedObject

+ (NSString *)name;
+ (instancetype)completedChoreWithCompletionDate:(NSDate * _Nonnull)completionDate chore:(Chore * _Nonnull)chore person:(Person * _Nonnull)person;

@end

NS_ASSUME_NONNULL_END

#import "CompletedChore+CoreDataProperties.h"
