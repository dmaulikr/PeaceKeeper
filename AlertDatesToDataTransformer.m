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
    return [NSAr]
    
    ((AlertDates *)value).dates;
//    return UIImagePNGRepresentation(value);
}


- (id)reverseTransformedValue:(id)value {
    return [AlertDates alloc]
//    return [[UIImage alloc] initWithData:value];
}

@end
