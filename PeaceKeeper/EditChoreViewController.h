//
//  EditChoreViewController.h
//  PeaceKeeper
//
//  Created by Work on 12/21/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"
#import "EditChoreViewControllerDelegate.h"

@interface EditChoreViewController : UIViewController

@property (strong, nonatomic) NSMutableOrderedSet<Person *> *mutablePeople;
@property (strong, nonatomic) Person *currentPerson;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSNumber *repeatIntervalValue;
@property (strong, nonatomic) NSString *repeatIntervalUnit;

@property (weak, nonatomic) id<EditChoreViewControllerDelegate> delegate;

@end
