//
//  GGCatalogPageRetriever.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGCatalogPageRetriever.h"
#import "INOffsetBasedPaginationState.h"


@implementation GGCatalogPageRetriever

- (id)initWithCatalogService:(GGCatalogService *)catalogService {
    self = [super init];
    if (self) {
        _catalogService = catalogService;
    }
    return self;
}

- (void)retrieveFirstPageWithItems:(NSUInteger)itemsPerPage onSuccess:(PageRetrievalSuccessBlock)onSuccess onError:(PageErrorBlock)onError {
    NSAssert(itemsPerPage > 0, @"Items per page should be greater than 0.");
    self.itemsPerPage = itemsPerPage;
    NSDictionary *modifiers = @{GGRequestModifierCountKey: @(self.itemsPerPage)};
    [self.catalogService getBookListWithModifiers:modifiers onSuccess:^(NSArray *books) {
        if (onSuccess) {
            INOffsetBasedPaginationState *paginationState = [[INOffsetBasedPaginationState alloc] initWithTotal:books.count <= self.itemsPerPage ? books.count : NSUIntegerMax offset:books.count];
            onSuccess(books, paginationState);
        }
    } onError:^(NSError *error) {
        if (onError) { onError(error); }
    }];
}

- (void)retrieveNextPageFrom:(id<INPaginationState>)paginationState onSuccess:(PageRetrievalSuccessBlock)onSuccess onError:(PageErrorBlock)onError {
    NSAssert(self.itemsPerPage > 0, @"Items per page should be greater than 0. Maybe you haven't invoked first page?");
    INOffsetBasedPaginationState *offsetBasedState = paginationState;
    NSDictionary *modifiers = @{GGRequestModifierCountKey: @(self.itemsPerPage), GGRequestModifierOffsetKey: @(offsetBasedState.offset)};
    [self.catalogService getBookListWithModifiers:modifiers onSuccess:^(NSArray *books) {
        if (onSuccess) {
            INOffsetBasedPaginationState *paginationState = [[INOffsetBasedPaginationState alloc] initWithTotal:books.count <= self.itemsPerPage ? offsetBasedState.offset + books.count : NSUIntegerMax
                                                                                                         offset:offsetBasedState.offset + books.count];
            onSuccess(books, paginationState);
        }
    } onError:^(NSError *error) {
        if (onError) { onError(error); }
    }];
}

@end
