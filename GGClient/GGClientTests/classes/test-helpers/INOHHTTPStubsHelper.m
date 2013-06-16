//
//  INOHHTTPStubsHelper.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "INOHHTTPStubsHelper.h"
#import <OHHTTPStubs/OHHTTPStubs.h>


@implementation INOHHTTPStubsHelper

+ (BOOL)url:(NSURL *)url matches:(NSString *)pathPattern {
    NSArray *urlComponents  = url.pathComponents;
    NSArray *pathComponents = [[pathPattern componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject length] > 0;
    }]];
    
    if ([urlComponents count] >= [pathComponents count]) {
        NSArray *componentsToCheck = [urlComponents subarrayWithRange:NSMakeRange([urlComponents count] - [pathComponents count], [pathComponents count])];
        __block BOOL match = YES;
        [pathComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![obj hasPrefix:@":"] && ![obj isEqual:[componentsToCheck objectAtIndex:idx]]) {
                match = NO;
                *stop = YES;
            }
        }];
        return match;
    } else {
        return NO;
    }
}

+ (void)stubHTTPResponseForPathPattern:(NSString *)pathPattern method:(NSString *)method withFixtureName:(NSString *)fixtureName {
    [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [INOHHTTPStubsHelper url:request.URL matches:pathPattern];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFile:fixtureName contentType:@"application/json" responseTime:0.0];
    }];
}

+ (void)stubHTTPErrorResponseForPathPattern:(NSString *)pathPattern method:(NSString *)method withStatusCodes:(NSUInteger)statusCode {
    [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [INOHHTTPStubsHelper url:request.URL matches:pathPattern];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:error];
    }];
}

@end
