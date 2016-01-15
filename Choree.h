//
//  Choree.h
//  PeaceKeeper
//
//  Created by Work on 12/31/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AlertDates.h"

@class Chore, Person;

NS_ASSUME_NONNULL_BEGIN

@interface Choree : NSManagedObject

+ (NSString * _Nonnull)name;
+ (instancetype _Nonnull)choreeWithPerson:(Person * _Nonnull)person chore:(Chore * _Nonnull)chore alertDate:(NSDate * _Nonnull)alertDate;
+ (instancetype _Nonnull)choreeWithoutSaveWithPerson:(Person * _Nonnull)person chore:(Chore * _Nonnull)chore alertDate:(NSDate * _Nonnull)alertDate;

@end

NS_ASSUME_NONNULL_END

#import "Choree+CoreDataProperties.h"
