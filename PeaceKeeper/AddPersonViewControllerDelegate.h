//
//  AddPersonViewControllerDelegate.h
//  PeaceKeeper
//
//  Created by Work on 12/21/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@protocol AddPersonViewControllerDelegate <NSObject>

- (void)addPersonViewControllerDidSelectPerson:(Person *)selectedPerson;
- (void)addPersonViewControllerDidCancel;

@end
