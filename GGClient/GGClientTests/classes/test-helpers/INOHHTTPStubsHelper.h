//
//  INOHHTTPStubsHelper.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface INOHHTTPStubsHelper : NSObject
+ (void)stubHTTPResponseForPathPattern:(NSString *)pathPattern method:(NSString *)method withFixtureName:(NSString *)fixtureName;
+ (void)stubHTTPErrorResponseForPathPattern:(NSString *)pathPattern method:(NSString *)method withStatusCodes:(NSUInteger)statusCode;
@end
