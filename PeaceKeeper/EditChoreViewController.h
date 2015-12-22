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

@property (strong, nonatomic) Chore *chore;
@property (weak, nonatomic) id<EditChoreViewControllerDelegate> delegate;

@end
