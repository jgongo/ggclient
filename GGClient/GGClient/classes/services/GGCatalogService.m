//
//  GGCatalogService.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGCatalogService.h"
#import "RKObjectManager+GGClientConfiguration.h"


#pragma mark Constant definitions

NSString* const GGRKObjectRequestOperationKey = @"GGRKObjectRequestOperationKey";

NSString* const GGRequestModifierCountKey  = @"count";
NSString* const GGRequestModifierOffsetKey = @"offset";


#pragma mark - Class implementation

@implementation GGCatalogService

#pragma mark - Helper methods

- (NSError *)errorWithError:(NSError *)error failedOperation:(RKObjectRequestOperation *)operation
{
    NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
    [userInfo setObject:operation forKey:GGRKObjectRequestOperationKey];
    
    return [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
}

- (NSDictionary *)buildRequestParameters:(NSDictionary *)modifiers {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if ([[modifiers objectForKey:GGRequestModifierCountKey] integerValue] > 0) {
        [params setObject:[modifiers objectForKey:GGRequestModifierCountKey] forKey:GGRequestModifierCountKey];
    }
    
    if ([[modifiers objectForKey:GGRequestModifierOffsetKey] integerValue] > 0) {
        [params setObject:[modifiers objectForKey:GGRequestModifierOffsetKey] forKey:GGRequestModifierOffsetKey];
    }
    
    return params;
}

#pragma mark - Book retrieval

- (void)getBookListWithModifiers:(NSDictionary *)modifiers onSuccess:(BookListSuccessBlock)onSuccess onError:(ErrorBlock)onError {
    NSAssert(onSuccess, @"Success block must be present in order to get list of books");
    [self.objectManager getObjectsAtPathForRouteNamed:GGAPI_ROUTE_ITEMS object:nil parameters:[self buildRequestParameters:modifiers] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        DDLogVerbose(@"List of books correctly retrieved: %@", [mappingResult array]);
        onSuccess([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        DDLogWarn(@"Error while retrieving list of books: %@", error);
        if (onError) { onError([self errorWithError:error failedOperation:operation]); }
    }];
}

- (void)getBookWithId:(NSString *)bookId onSuccess:(BookSuccessBlock)onSuccess onError:(ErrorBlock)onError {
    NSAssert(bookId,    @"Can't retrieve a book without its id");
    NSAssert(onSuccess, @"Success block must be present in order to get list of books");
    GGBook *book = [[GGBook alloc] init];
    book.identifier = bookId;
    [self.objectManager getObject:book path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        DDLogVerbose(@"Book correctly retrieved: %@", [mappingResult firstObject]);
        onSuccess([mappingResult firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        DDLogWarn(@"Error while retrieving book: %@", error);
        if (onError) { onError([self errorWithError:error failedOperation:operation]); }
    }];
}

@end
