//
//  ChooseValueViewControllerDelegate.h
//  PeaceKeeper
//
//  Created by Work on 1/14/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseValueViewControllerDelegate <NSObject>

- (void)chooseValueViewControllerDidSelectIntegerNumber:(NSNumber *)number;
- (void)chooseValueViewControllerDidCancel;

@end
