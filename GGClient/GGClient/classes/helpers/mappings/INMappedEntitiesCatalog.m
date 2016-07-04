//
//  INMappedEntitiesCatalog.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "INMappedEntitiesCatalog.h"
#import "INMappedEntity.h"


@implementation INMappedEntitiesCatalog

- (RKMapping *)mappingForClass:(Class)class
{
    if ([class conformsToProtocol:@protocol(INMappedEntity)]) {
        return [class mapping];
    } else {
        return nil;
    }
}

- (RKObjectMapping *)inverseMappingForClass:(Class)class {
    RKMapping *mapping = [self mappingForClass:class];
    return [mapping isKindOfClass:[RKObjectMapping class]] ? [(RKObjectMapping *)mapping inverseMapping] : nil;
}

@end
