//
//  ChoreOrderViewController.h
//  PeaceKeeper
//
//  Created by Work on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface ChoreOrderViewController : UIViewController

@property (strong, nonatomic) NSDictionary *tempDictionary;
@property (strong, nonatomic) NSMutableArray<Person *> *selectedPeople;

@end
