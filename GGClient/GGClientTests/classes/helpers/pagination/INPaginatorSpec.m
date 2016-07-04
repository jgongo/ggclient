//
//  INPaginatorSpec.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright 2013 OPEN input. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "INPaginator.h"
#import "INOffsetBasedPaginationState.h"


@interface PageRetrieverStub : NSObject <INPageRetriever>
@property (nonatomic, strong) NSArray   *items;
@property (nonatomic        ) NSUInteger itemsPerPage;
@property (nonatomic        ) BOOL       forceError;
@end


@implementation PageRetrieverStub

- (void)retrieveFirstPageWithItems:(NSUInteger)itemsPerPage onSuccess:(PageRetrievalSuccessBlock)onSuccess onError:(PageErrorBlock)onError {
    self.itemsPerPage = itemsPerPage;
    [self retrieveNextPageFrom:[[INOffsetBasedPaginationState alloc] initWithTotal:self.items.count offset:0] onSuccess:onSuccess onError:onError];
}

- (void)retrieveNextPageFrom:(id<INPaginationState>)paginationState onSuccess:(PageRetrievalSuccessBlock)onSuccess onError:(PageErrorBlock)onError {
    INOffsetBasedPaginationState *state = paginationState;
    if ([state hasMorePages] && !self.forceError) {
        if (state.offset + self.itemsPerPage <= self.items.count) {
            onSuccess([self.items subarrayWithRange:NSMakeRange(state.offset, self.itemsPerPage)], [[INOffsetBasedPaginationState alloc] initWithTotal:self.items.count offset:state.offset + self.itemsPerPage]);
        } else {
            onSuccess([self.items subarrayWithRange:NSMakeRange(state.offset, self.items.count - state.offset)], [[INOffsetBasedPaginationState alloc] initWithTotal:self.items.count offset:self.items.count]);
        }
    } else {
        onError([NSError errorWithDomain:@"EMTestDomain" code:1 userInfo:nil]);
    }
}

@end



SPEC_BEGIN(INPaginatorSpec)

describe(@"INPaginator", ^{
    __block INPaginator       *paginator;
    __block PageRetrieverStub *pageRetriever;
    
    beforeEach(^{
        pageRetriever       = [[PageRetrieverStub alloc] init];
        pageRetriever.items = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
        paginator           = [[INPaginator alloc] initWithPageRetriever:pageRetriever itemsPerPage:4];
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    it(@"should raise exception when created without a page retriever", ^{
        [[theBlock(^{ [[INPaginator alloc] initWithPageRetriever:nil itemsPerPage:10]; }) should] raise];
    });
    
    it(@"should raise exception when created with 0 items per page", ^{
        [[theBlock(^{ [[INPaginator alloc] initWithPageRetriever:pageRetriever itemsPerPage:0]; }) should] raise];
    });
#pragma clang diagnostic pop
    
    context(@"when newly created", ^{
        it(@"should raise exception when retrieving first page without success block", ^{
            [[theBlock(^{ [paginator retrieveFirstPageOnSucces:nil onError:nil]; }) should] raise];
        });
        
        it(@"should raise exception when retrieving next page without success block", ^{
            [[theBlock(^{ [paginator retrieveNextPageOnSucces:nil onError:nil]; }) should] raise];
        });
        
        it(@"should always return that has more pages", ^{
            [[theValue([paginator hasMorePages]) should] equal:theValue(YES)];
        });
        
        it(@"should return the first page when retrieving next page", ^{
            __block NSArray *firstNextPage;
            __block NSArray *firstPage;
            [paginator retrieveNextPageOnSucces:^(NSArray *page) { firstNextPage = page; } onError:nil];
            [paginator retrieveFirstPageOnSucces:^(NSArray *page) { firstPage = page; } onError:nil];
            [[firstNextPage should] equal:firstPage];
        });
    });
    
    context(@"when not at end of source", ^{
        beforeEach(^{
            [paginator retrieveFirstPageOnSucces:^(NSArray *page) {} onError:nil];
            [paginator retrieveNextPageOnSucces: ^(NSArray *page) {} onError:nil];
        });
        
        it(@"should inform of availability of data", ^{
            [[theValue([paginator hasMorePages]) should] equal:theValue(YES)];
        });
    });
    
    context(@"when paginating data", ^{
        __block NSArray *firstPage;
        __block NSArray *secondPage;
        __block NSArray *thirdPage;
        
        beforeEach(^{
            [paginator retrieveFirstPageOnSucces:^(NSArray *page) { firstPage  = page; } onError:nil];
            [paginator retrieveNextPageOnSucces: ^(NSArray *page) { secondPage = page; } onError:nil];
            [paginator retrieveNextPageOnSucces: ^(NSArray *page) { thirdPage  = page; } onError:nil];
        });
        
        context(@"should correctly paginate", ^{
            specify(^{ [[firstPage  should] equal:@[@0, @1, @2, @3]]; });
            specify(^{ [[secondPage should] equal:@[@4, @5, @6, @7]]; });
            specify(^{ [[thirdPage  should] equal:@[@8, @9]]; });
        });
        
        it(@"should inform of end of pages", ^{
            [[theValue([paginator hasMorePages]) should] equal:theValue(NO)];
        });
        
        context(@"after end of data", ^{
            __block NSArray *pageAfterEndOfData = @[]; // Initialized with something so we can check for nil
            
            beforeEach(^{ [paginator retrieveNextPageOnSucces: ^(NSArray *page) { pageAfterEndOfData = page; } onError:nil]; });
            
            it(@"should return nothing", ^{ [pageAfterEndOfData shouldBeNil]; });
        });
        
        context(@"when retrieving first page again", ^{
            __block NSArray *firstPageAgain;
            __block NSArray *secondPageAgain;
            __block NSArray *thirdPageAgain;
            
            beforeEach(^{
                [paginator retrieveFirstPageOnSucces:^(NSArray *page) { firstPageAgain  = page; } onError:nil];
                [paginator retrieveNextPageOnSucces: ^(NSArray *page) { secondPageAgain = page; } onError:nil];
                [paginator retrieveNextPageOnSucces: ^(NSArray *page) { thirdPageAgain  = page; } onError:nil];
            });
            
            context(@"should restart the paginator", ^{
                specify(^{ [[firstPageAgain  should] equal:firstPage ]; });
                specify(^{ [[secondPageAgain should] equal:secondPage]; });
                specify(^{ [[thirdPageAgain  should] equal:thirdPage ]; });
            });
        });
    });
    
    context(@"when source has some errors", ^{
        beforeEach(^{ pageRetriever.forceError = YES; });
        
        context(@"and we have provided an error block", ^{
            __block BOOL errorBlockInvoked;
            beforeEach(^{ [paginator retrieveFirstPageOnSucces:^(NSArray *page) {} onError:^(NSError *error) { errorBlockInvoked = YES; }]; });
            it(@"should invoke the error block", ^{ [[theValue(errorBlockInvoked) should] equal:theValue(YES)]; });
        });
        
        context(@"and we haven't provided an error block", ^{
            beforeEach(^{ [paginator retrieveFirstPageOnSucces:^(NSArray *page) {} onError:nil]; });
            it(@"shouldn't fail", ^{ /* Empty example to exercise method invocation without error block */ });
        });
    });
});

SPEC_END
