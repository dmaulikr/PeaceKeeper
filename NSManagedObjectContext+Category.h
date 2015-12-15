//
//  NSManagedObjectContext+Category.h
//  HotelManager
//
//  Created by Work on 12/2/15.
//  Copyright © 2015 JB. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Category)

+ (NSManagedObjectContext *)managedObjectContext;
+ (BOOL)saveManagedObjectContext;

@end
