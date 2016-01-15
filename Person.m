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
#import "CoreDataStackManager.h"

@implementation Person

+ (NSString * _Nonnull)name {
    return @"Person";
}

+ (instancetype _Nonnull)personFromContact:(CNContact * _Nonnull)contact withHousehold:(Household * _Nonnull)household {
    CNLabeledValue *emailAddressValue = (CNLabeledValue *)contact.emailAddresses.firstObject;
    CNLabeledValue *phoneNumberValue = (CNLabeledValue *)contact.phoneNumbers.firstObject;
    
    CNPhoneNumber *number = (CNPhoneNumber *)phoneNumberValue.value;
    
    NSLog(@"%@", emailAddressValue.value);
    NSLog(@"%@", number.stringValue);
    
    return [self personWithFirstName:contact.givenName lastName:contact.familyName phoneNumber:number.stringValue email:emailAddressValue.value household:household];
}

+ (instancetype _Nonnull)personWithFirstName:(NSString * _Nonnull)firstName lastName:(NSString * _Nullable)lastName phoneNumber:(NSString * _Nullable)phoneNumber email:(NSString *_Nullable)email household:(Household * _Nonnull)household {
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[[CoreDataStackManager sharedManager] managedObjectContext]];
    person.firstName = firstName;
    person.lastName = lastName;
    person.phoneNumber = phoneNumber;
    person.email = email;
    person.household = household;
    // FIXME?
//    [household addPeopleObject:person];
    [[CoreDataStackManager sharedManager] saveContext];
    return person;
}

- (NSString * _Nonnull)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
