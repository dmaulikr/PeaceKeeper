//
//  Person.m
//  PeaceKeeper
//
//  Created by Work on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "Person.h"
#import "Chore.h"
#import "Household.h"
#import "NSManagedObjectContext+Category.h"

@implementation Person

+ (NSString *)name {
    return @"Person";
}

+ (instancetype)personFromContact:(CNContact * _Nonnull)contact withHousehold:(Household * _Nonnull)household {
    CNLabeledValue *emailAddressValue = (CNLabeledValue *)contact.emailAddresses.firstObject;
    CNLabeledValue *phoneNumberValue = (CNLabeledValue *)contact.phoneNumbers.firstObject;
    
    CNPhoneNumber *number = (CNPhoneNumber *)phoneNumberValue.value;
    
    NSLog(@"%@", emailAddressValue.value);
    NSLog(@"%@", number.stringValue);
    
    return [self personWithFirstName:contact.givenName lastName:contact.familyName phoneNumber:number.stringValue email:emailAddressValue.value chore:nil household:household];
}

+ (instancetype)personWithFirstName:(NSString * _Nonnull)firstName lastName:(NSString * _Nullable)lastName phoneNumber:(NSString * _Nullable)phoneNumber email:(NSString *_Nullable)email chore:(Chore * _Nullable)chore household:(Household * _Nonnull)household {
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[NSManagedObjectContext managedObjectContext]];
    person.firstName = firstName;
    person.lastName = lastName;
    person.phoneNumber = phoneNumber;
    person.email = email;
    if (chore) {
        person.chores = [NSSet setWithObject:chore];
    } else {
        person.chores = [NSSet set];
    }
    person.household = household;
    [household addPeopleObject:person];
    [NSManagedObjectContext saveManagedObjectContext];
    return person;
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
