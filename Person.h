//
//  Person.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chore, Household;

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSManagedObject

+ (NSString *)name;
+ (instancetype)personWithName:(NSString * _Nonnull)name chore:(Chore * _Nullable)chore household:(Household * _Nonnull)household;

@end

NS_ASSUME_NONNULL_END

#import "Person+CoreDataProperties.h"
