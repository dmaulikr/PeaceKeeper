//
//  CompletedChore.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chore, Person, Household;

NS_ASSUME_NONNULL_BEGIN

@interface CompletedChore : NSManagedObject

+ (NSString * _Nonnull)name;
+ (instancetype _Nonnull)completedChoreWithCompletionDate:(NSDate * _Nonnull)completionDate alertDate:(NSDate * _Nonnull)alertDate chore:(Chore * _Nonnull)chore person:(Person * _Nonnull)person household:(Household * _Nonnull)household imageName:(NSString * _Nullable)imageName;

@end

NS_ASSUME_NONNULL_END

#import "CompletedChore+CoreDataProperties.h"
