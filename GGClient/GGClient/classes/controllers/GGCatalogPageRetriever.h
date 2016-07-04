//
//  GGCatalogPageRetriever.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INPaginator.h"
#import "GGCatalogService.h"


@interface GGCatalogPageRetriever : NSObject <INPageRetriever>
@property (nonatomic        ) NSUInteger        itemsPerPage;
@property (nonatomic, strong) GGCatalogService *catalogService;
- (id)initWithCatalogService:(GGCatalogService *)catalogService;
@end
