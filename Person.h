//
//  Person.h
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@import Contacts;

@class Chore, Household;

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSManagedObject

+ (NSString * _Nonnull)name;
+ (instancetype _Nonnull)personFromContact:(CNContact * _Nonnull)contact withHousehold:(Household * _Nonnull)household;
+ (instancetype _Nonnull)personWithFirstName:(NSString * _Nonnull)firstName lastName:(NSString * _Nullable)lastName phoneNumber:(NSString * _Nullable)phoneNumber email:(NSString *_Nullable)email chore:(Chore * _Nonnull)chore household:(Household * _Nonnull)household;
- (NSString * _Nonnull)fullName;

@end

NS_ASSUME_NONNULL_END

#import "Person+CoreDataProperties.h"
