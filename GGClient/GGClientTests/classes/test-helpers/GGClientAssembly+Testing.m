//
//  GGClientAssembly+Testing.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGClientAssembly+Testing.h"
#import <Typhoon/Typhoon.h>


@implementation GGClientAssembly (Testing)

- (id)restkitHelper {
    return [TyphoonDefinition withClass:[INRestKitHelper class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(mappingCatalog) withDefinition:[self mappingCatalog]];
    }];
}

@end
