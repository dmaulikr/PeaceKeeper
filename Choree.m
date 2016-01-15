//
//  Choree.m
//  PeaceKeeper
//
//  Created by Work on 12/31/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "Choree.h"
#import "Chore.h"
#import "Person.h"
#import "CoreDataStackManager.h"
#import "NSDate+Category.h"

@implementation Choree

+ (NSString * _Nonnull)name {
    return @"Choree";
}

+ (instancetype _Nonnull)choreeWithPerson:(Person * _Nonnull)person chore:(Chore * _Nonnull)chore alertDate:(NSDate * _Nonnull)alertDate {
    Choree *choree = [self choreeWithoutSaveWithPerson:person chore:chore alertDate:alertDate];
    [[CoreDataStackManager sharedManager] saveContext];
    return choree;
}

+ (instancetype _Nonnull)choreeWithoutSaveWithPerson:(Person * _Nonnull)person chore:(Chore * _Nonnull)chore alertDate:(NSDate * _Nonnull)alertDate {
    Choree *choree = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[[CoreDataStackManager sharedManager] managedObjectContext]];
    choree.person = person;
    choree.chore = chore;
    choree.alertDate = alertDate;
    return choree;
}

@end
