//
//  EditAlertViewController.h
//  PeaceKeeper
//
//  Created by Work on 12/22/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditAlertViewControllerDelegate.h"

@interface EditAlertViewController : UIViewController

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSNumber *repeatIntervalValue;
@property (strong, nonatomic) NSString *repeatIntervalUnit;
@property (weak, nonatomic) id<EditAlertViewControllerDelegate> delegate;

@end
