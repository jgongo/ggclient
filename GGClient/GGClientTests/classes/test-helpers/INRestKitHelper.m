//
//  GGRestKitHelper.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "INRestKitHelper.h"


@implementation INRestKitHelper

+ (INRestKitHelper *)helperWithCatalog:(id<INMappingCatalog>)mappingCatalog {
    return [[INRestKitHelper alloc] initWithCatalog:mappingCatalog];
}

- (id)initWithCatalog:(id<INMappingCatalog>)mappingCatalog {
    self = [super init];
    if (self) {
        _mappingCatalog = mappingCatalog;
    }
    return self;
}

- (RKMappingTest *)setupMappingTestForClass:(Class)class withFixture:(NSString *)fixture {
    [RKTestFactory setUp];
    id parsedObject = [RKTestFixture parsedObjectWithContentsOfFixture:fixture];
    return [RKMappingTest testForMapping:[self.mappingCatalog mappingForClass:class] sourceObject:parsedObject destinationObject:nil];
}

@end
