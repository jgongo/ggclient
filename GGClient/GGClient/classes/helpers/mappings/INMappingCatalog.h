//
//  GGMappingCatalog.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@protocol INMappingCatalog <NSObject>
- (RKMapping *)mappingForClass:(Class)class;
- (RKObjectMapping *)inverseMappingForClass:(Class)class;
@end
