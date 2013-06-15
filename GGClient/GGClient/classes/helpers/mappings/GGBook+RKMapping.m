//
//  GGBook+RKMapping.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGBook+RKMapping.h"


@implementation GGBook (RKMapping)

+ (RKMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[GGBook class]];
    [mapping addAttributeMappingsFromDictionary:@{@"id": @"identifier", @"image": @"imageURL"}];
    [mapping addAttributeMappingsFromArray:@[@"title", @"author", @"price"]];
    return mapping;
}

@end
