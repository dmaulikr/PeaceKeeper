//
//  ImageArchiverService.m
//  PeaceKeeper
//
//  Created by Work on 12/17/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "ImageArchiverService.h"
#import "Constants.h"

@implementation ImageArchiverService

+ (NSMutableArray *)getMutableImagesArray {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentDirectory = paths.firstObject;
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:kChoreImagesMutableArrayName];
    NSArray *imageData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSMutableArray *images = [NSMutableArray arrayWithArray:[self convertNSDataArrayToUIImageArray:imageData]];
    return images;
}

+ (void)archiveMutableImagesArray:(NSMutableArray *)mutableImagesArray {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentDirectory = paths.firstObject;
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:kChoreImagesMutableArrayName];
    NSArray *imageData = [self convertUIImageArrayToNSDataArray:mutableImagesArray];
    BOOL success = [NSKeyedArchiver archiveRootObject:imageData toFile:filePath];
    if (success) {
        NSLog(@"Archive successful");
    } else {
        NSLog(@"Archive unsuccessful");
    }
}

+ (NSArray<NSData *> *)convertUIImageArrayToNSDataArray:(NSArray<UIImage *> *)imageArray {
    NSMutableArray *result = [NSMutableArray array];
    for (UIImage *image in imageArray) {
        [result addObject:UIImageJPEGRepresentation(image, 1.0)];
    }
    return result;
}

+ (NSArray<UIImage *> *)convertNSDataArrayToUIImageArray:(NSArray<NSData *> *)dataArray {
    NSMutableArray *result = [NSMutableArray array];
    for (NSData *data in dataArray) {
        [result addObject:[UIImage imageWithData:data]];
    }
    return result;
}

@end
