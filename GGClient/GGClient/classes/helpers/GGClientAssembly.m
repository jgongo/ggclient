//
//  GGClientAssembly.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGClientAssembly.h"
#import <Typhoon/Typhoon.h>
#import "INMappedEntitiesCatalog.h"
#import "RKObjectManager+GGClientConfiguration.h"
#import "GGCatalogService.h"


@implementation GGClientAssembly

- (id)mappingCatalog {
    return [TyphoonDefinition withClass:[INMappedEntitiesCatalog class]];
}

- (id)webServiceBaseURL {
    return [TyphoonDefinition withClass:[NSURL class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(URLWithString:);
        [initializer injectParameterAtIndex:0 withValueAsText:@"${webservice.baseURL}" requiredTypeOrNil:[NSString class]];
    }];
}

- (id)objectManager {
    return [TyphoonDefinition withClass:[RKObjectManager class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(managerWithBaseURL:);
        [initializer injectWithDefinition:[self webServiceBaseURL]];
    } properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(mappingCatalog) withDefinition:[self mappingCatalog]];
        definition.afterPropertyInjection = @selector(applyCatalogAPIConfiguration);
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)catalogService {
    return [TyphoonDefinition withClass:[GGCatalogService class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(objectManager) withDefinition:[self objectManager]];
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end
