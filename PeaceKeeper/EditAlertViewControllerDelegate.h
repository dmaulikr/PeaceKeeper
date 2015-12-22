//
//  MakeChoreViewControllerDelegate.h
//  PeaceKeeper
//
//  Created by Work on 12/22/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditAlertViewControllerDelegate <NSObject>

- (void)editAlertViewControllerDidSelectStartDate:(NSDate *)startDate repeatIntervalString:(NSString *)repeatIntervalString;
- (void)editAlertViewControllerDidCancel;

@end
