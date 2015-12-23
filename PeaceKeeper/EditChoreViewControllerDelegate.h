//
//  EditChoreViewControllerDelegate.h
//  PeaceKeeper
//
//  Created by Work on 12/22/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@protocol EditChoreViewControllerDelegate <NSObject>

- (void)editChoreViewControllerDidSaveWithPeople:(NSOrderedSet * _Nonnull)updatedPeople
                                   currentPerson:(Person * _Nonnull)updatedCurrentPerson
                                       startDate:(NSDate * _Nonnull)updatedStartDate
                             repeatIntervalValue:(NSNumber * _Nonnull)updatedRepeatIntervalValue
                              repeatIntervalUnit:(NSString * _Nonnull)updatedRepeatIntervalUnit;
- (void)editChoreViewControllerDidCancel;

@end
