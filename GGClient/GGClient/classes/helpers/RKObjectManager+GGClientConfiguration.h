//
//  RKObjectManager+GGClientConfiguration.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "RKObjectManager.h"
#import "INMappingCatalog.h"


extern NSString* const GGAPI_ROUTE_ITEMS;


@interface RKObjectManager (GGClientConfiguration)
@property (nonatomic, strong) id<INMappingCatalog> mappingCatalog;
- (void)applyCatalogAPIConfiguration;
@end
