//
//  AlertDatesToDataTransformer.m
//  PeaceKeeper
//
//  Created by Work on 12/25/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "AlertDatesToDataTransformer.h"
#import "AlertDates.h"

@implementation AlertDatesToDataTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}


+ (Class)transformedValueClass {
    return [AlertDates class];
}


- (id)transformedValue:(id)value {
    return [NSKeyedArchiver archivedDataWithRootObject:((AlertDates *)value).dates];
}


- (id)reverseTransformedValue:(id)value {
    NSArray<NSDate *> *dates = [NSKeyedUnarchiver unarchiveObjectWithData:value];
    return [[AlertDates alloc] initWithDates:dates];
}

@end
