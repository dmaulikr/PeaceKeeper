//
//  ImageArchiverService.h
//  PeaceKeeper
//
//  Created by Work on 12/17/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageArchiverService : UIViewController

+ (NSMutableArray *)getMutableImagesArray;
+ (void)archiveMutableImagesArray:(NSMutableArray *)mutableImagesArray;

@end
