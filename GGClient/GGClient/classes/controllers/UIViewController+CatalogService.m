//
//  UIViewController+CatalogService.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "UIViewController+CatalogService.h"
#import <objc/runtime.h>
#import <Typhoon/Typhoon.h>


static char CatalogServiceKey;


@implementation UIViewController (CatalogService)

- (GGCatalogService *)catalogService
{
    GGCatalogService *catalogService = objc_getAssociatedObject(self, &CatalogServiceKey);
    if (!catalogService) {
        catalogService = [[TyphoonComponentFactory defaultFactory] componentForType:[GGCatalogService class]];
        self.catalogService = catalogService;
    }
    return catalogService;
}

- (void)setCatalogService:(GGCatalogService *)flowService
{
    objc_setAssociatedObject(self, &CatalogServiceKey, flowService, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
