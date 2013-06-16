//
//  RKObjectManager+GGClientConfiguration.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "RKObjectManager+GGClientConfiguration.h"
#import <objc/runtime.h>
#import "GGBook.h"


NSString* const GGAPI_ROUTE_ITEMS = @"GGAPI_ROUTE_ITEMS";

NSString* const GGAPI_PATH_ITEMS = @"items";
NSString* const GGAPI_PATH_ITEM  = @"items/:identifier";


static char MappingCatalogKey;


@implementation RKObjectManager (GGClientConfiguration)

- (id<INMappingCatalog>)mappingCatalog {
    return objc_getAssociatedObject(self, &MappingCatalogKey);
}

- (void)setMappingCatalog:(id<INMappingCatalog>)mappingCatalog {
    objc_setAssociatedObject(self, &MappingCatalogKey, mappingCatalog, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)applyCatalogAPIConfiguration {
    self.requestSerializationMIMEType = @"application/json";
    
    // Book list
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[self.mappingCatalog mappingForClass:[GGBook class]] pathPattern:GGAPI_PATH_ITEMS keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [self.router.routeSet addRoute:[RKRoute routeWithName:GGAPI_ROUTE_ITEMS pathPattern:GGAPI_PATH_ITEMS method:RKRequestMethodGET]];
    
    // Book
    [self addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[self.mappingCatalog mappingForClass:[GGBook class]] pathPattern:GGAPI_PATH_ITEM keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [self.router.routeSet addRoute:[RKRoute routeWithClass:[GGBook class] pathPattern:GGAPI_PATH_ITEM method:RKRequestMethodGET]];
}

@end
