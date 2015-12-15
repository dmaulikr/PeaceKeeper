//
//  NSManagedObjectContext+Category.m
//  HotelManager
//
//  Created by Work on 12/2/15.
//  Copyright © 2015 JB. All rights reserved.
//

#import "NSManagedObjectContext+Category.h"
#import "AppDelegate.h"

@implementation NSManagedObjectContext (Category)

+ (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

+ (BOOL)saveManagedObjectContext {
    NSError *saveError;
    BOOL success = [[NSManagedObjectContext managedObjectContext] save:&saveError];
    if (success) {
        NSLog(@"Successful managedObjectContext save.");
    } else {
        NSLog(@"Error saving managedObjectContext. Error: %@", saveError.localizedDescription);
    }
    return success;
}

@end
