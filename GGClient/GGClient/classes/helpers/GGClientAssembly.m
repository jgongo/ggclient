//
//  GGClientAssembly.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGClientAssembly.h"
#import <Typhoon/Typhoon.h>
#import "GGClientMappingCatalog.h"


@implementation GGClientAssembly

- (id)mappingCatalog {
    return [TyphoonDefinition withClass:[GGClientMappingCatalog class]];
}

@end
