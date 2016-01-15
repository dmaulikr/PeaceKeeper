//
//  ChooseUnitViewControllerDelegate.h
//  PeaceKeeper
//
//  Created by Work on 1/14/16.
//  Copyright © 2016 Francisco Ragland. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseUnitViewControllerDelegate <NSObject>

- (void)chooseUnitViewControllerDidSelectUnit:(NSString *)unit;
- (void)chooseUnitViewControllerDidCancel;

@end
