//
//  ChooseUnitViewController.h
//  PeaceKeeper
//
//  Created by Work on 1/14/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseUnitViewControllerDelegate.h"

@interface ChooseUnitViewController : UIViewController

@property (weak, nonatomic) id<ChooseUnitViewControllerDelegate> delegate;

@end
