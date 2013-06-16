//
//  INPaginator.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "INPaginator.h"


#pragma mark - INPaginator class extension

@interface INPaginator ()
@property (nonatomic, strong) id<INPageRetriever>   pageRetriever;
@property (nonatomic,       ) NSUInteger            itemsPerPage;
@property (nonatomic, copy  ) NSDictionary         *modifiers;
@property (nonatomic, strong) id<INPaginationState> paginationState;
@end


#pragma mark - INPaginator class implementation

@implementation INPaginator

- (id)initWithPageRetriever:(id<INPageRetriever>)pageRetriever itemsPerPage:(NSUInteger)itemsPerPage {
    NSAssert(pageRetriever,    @"Can't create a paginator without a data source");
    NSAssert(itemsPerPage > 0, @"Items per page should be greater than zero");
    self = [super init];
    if (self) {
        _pageRetriever = pageRetriever;
        _itemsPerPage  = itemsPerPage;
    }
    return self;
}

- (BOOL)hasMorePages {
    if (self.paginationState) {
        return [self.paginationState hasMorePages];
    } else {
        return YES;
    }
}

- (void)retrieveFirstPageOnSucces:(PageSuccessBlock)onSuccess onError:(PageErrorBlock)onError {
    NSAssert(onSuccess, @"It doesn't make sense to retrieve a page without a success block");
    self.paginationState = nil;
    [self.pageRetriever retrieveFirstPageWithItems:self.itemsPerPage onSuccess:^(NSArray *page, id<INPaginationState> paginationState) {
        DDLogVerbose(@"Page successfully retrieved for %@", self.pageRetriever);
        self.paginationState = paginationState;
        onSuccess(page);
    } onError:^(NSError *error) {
        DDLogWarn(@"Error while retrieving page for %@: %@", self.pageRetriever, error);
        if (onError) { onError(error); }
    }];
}

- (void)retrieveNextPageOnSucces:(PageSuccessBlock)onSuccess onError:(PageErrorBlock)onError {
    NSAssert(onSuccess, @"It doesn't make sense to retrieve a page without a success block");
    if (!self.paginationState) {
        [self retrieveFirstPageOnSucces:onSuccess onError:onError];
    } else if ([self hasMorePages]) {
        [self.pageRetriever retrieveNextPageFrom:self.paginationState onSuccess:^(NSArray *page, id<INPaginationState> paginationState) {
            DDLogVerbose(@"Page successfully retrieved for %@", self.pageRetriever);
            self.paginationState = paginationState;
            onSuccess(page);
        } onError:^(NSError *error) {
            DDLogWarn(@"Error while retrieving page for %@: %@", self.pageRetriever, error);
            if (onError) { onError(error); }
        }];
    } else {
        onSuccess(nil);
    }
}

@end
