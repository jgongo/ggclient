//
//  GGRestKitHelper.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/Testing.h>
#import "INMappingCatalog.h"


@interface INRestKitHelper : NSObject

@property (nonatomic, strong) id<INMappingCatalog> mappingCatalog;

+ (INRestKitHelper *)helperWithCatalog:(id<INMappingCatalog>)mappingCatalog;

- (id)initWithCatalog:(id<INMappingCatalog>)mappingCatalog;
- (RKMappingTest *)setupMappingTestForClass:(Class)class withFixture:(NSString *)fixture;

@end
