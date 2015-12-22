//
//  AddPersonViewController.h
//  PeaceKeeper
//
//  Created by Work on 12/21/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Household.h"
#import "AddPersonViewControllerDelegate.h"

@interface AddPersonViewController : UIViewController

@property (strong, nonatomic) Household *household;
@property (strong, nonatomic) NSMutableOrderedSet<Person *> *peopleMutableCopy;
@property (weak, nonatomic) id<AddPersonViewControllerDelegate> delegate;

@end
