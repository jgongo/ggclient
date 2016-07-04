//
//  INPaginator.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - Pagination state protocol

@protocol INPaginationState <NSObject>
- (BOOL)hasMorePages;
@optional
- (NSUInteger)count;
@end


#pragma mark - Block type definitions

typedef void (^PageRetrievalSuccessBlock) (NSArray *page, id<INPaginationState> paginationState);
typedef void (^PageSuccessBlock)          (NSArray *page);
typedef void (^PageErrorBlock)            (NSError *error);


#pragma mark - Page retriever protocol

@protocol INPageRetriever <NSObject>
- (void)retrieveFirstPageWithItems:(NSUInteger)itemsPerPage onSuccess:(PageRetrievalSuccessBlock)onSuccess onError:(PageErrorBlock)onError;
- (void)retrieveNextPageFrom:(id<INPaginationState>)paginationState onSuccess:(PageRetrievalSuccessBlock)onSuccess onError:(PageErrorBlock)onError;
@end


#pragma mark - Paginator class

@interface INPaginator : NSObject
- (id)initWithPageRetriever:(id<INPageRetriever>)pageRetriever itemsPerPage:(NSUInteger)itemsPerPage;
- (BOOL)hasMorePages;
- (void)retrieveFirstPageOnSucces:(PageSuccessBlock)onSuccess onError:(PageErrorBlock)onError;
- (void)retrieveNextPageOnSucces:(PageSuccessBlock)onSuccess onError:(PageErrorBlock)onError;
@end
