//
//  GGCatalogServiceSpec.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright 2013 OPEN input. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <RestKit/RestKit.h>
#import <Typhoon/Typhoon.h>
#import "INOHHTTPStubsHelper.h"
#import "GGClientAssembly.h"
#import "GGCatalogService.h"
#import "RKObjectManager+GGClientConfiguration.h"
#import "INPaginator.h"


SPEC_BEGIN(GGCatalogServiceSpec)

describe(@"GGCatalogService", ^{
    __block RKObjectManager  *objectManager;
    __block GGCatalogService *service;
    
    beforeEach(^{
        TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[GGClientAssembly assembly]];
        [factory attachMutator:[TyphoonPropertyPlaceholderConfigurer configurerWithResource:[TyphoonBundleResource withName:@"catalog.properties"]]];
        service = [factory componentForKey:@"catalogService"];
        objectManager = [factory componentForKey:@"objectManager"];
    });
    
    context(@"when retrieving books", ^{
        __block NSArray *books;
        
        context(@"params in request", ^{
            __block NSDictionary *params;
            
            beforeEach(^{
                NSString *getBooksPathPattern = [objectManager.router.routeSet routeForName:GGAPI_ROUTE_ITEMS].pathPattern;
                [INOHHTTPStubsHelper stubHTTPResponseForPathPattern:getBooksPathPattern method:@"GET" withFixtureName:@"network.books.json"];
                
                RKObjectManager *objectManager = [RKObjectManager mock];
                KWCaptureSpy    *paramsCapture = [objectManager captureArgument:@selector(getObjectsAtPathForRouteNamed:object:parameters:success:failure:) atIndex:2];
                service.objectManager = objectManager;
                
                NSDictionary *modifiers = @{GGRequestModifierCountKey: @3, GGRequestModifierOffsetKey:@6};
                [service getBookListWithModifiers:modifiers onSuccess:^(NSArray *books) {} onError:nil];
                
                params = paramsCapture.argument;
            });
            
            specify(^{ [[[params objectForKey:GGRequestModifierCountKey]  should] equal:@3]; });
            specify(^{ [[[params objectForKey:GGRequestModifierOffsetKey] should] equal:@6]; });
        });
        
        context(@"successfully", ^{
            beforeEach(^{
                NSString *getBooksPathPattern = [objectManager.router.routeSet routeForName:GGAPI_ROUTE_ITEMS].pathPattern;
                [INOHHTTPStubsHelper stubHTTPResponseForPathPattern:getBooksPathPattern method:@"GET" withFixtureName:@"network.books.json"];
                
                [service getBookListWithModifiers:nil onSuccess:^(NSArray *actualBooks) {
                    books = actualBooks;
                } onError:nil];
            });
            
            it(@"should correctly return the books", ^{
                [[expectFutureValue(theValue(books.count))           shouldEventually] equal:theValue(12)];
                [[expectFutureValue([books objectAtIndex:2])         shouldEventually] beKindOfClass:[GGBook class]];
                [[expectFutureValue([[books objectAtIndex:2] title]) shouldEventually] equal:@"Ten ways to a better mind"];
            });
            
            context(@"without a success block", ^{
                it(@"should raise an exception", ^{
                    [[theBlock(^{ [service getBookListWithModifiers:nil onSuccess:nil onError:nil]; }) should] raise];
                });
            });
        });
        
        context(@"unsuccessfully", ^{
            beforeAll(^{
                NSString *getBooksPathPattern = [objectManager.router.routeSet routeForName:GGAPI_ROUTE_ITEMS].pathPattern;
                [INOHHTTPStubsHelper stubHTTPErrorResponseForPathPattern:getBooksPathPattern method:@"GET" withStatusCodes:500];
            });
            
            context(@"with an error block", ^{
                __block NSError *error;
                beforeEach(^{ error = nil; [service getBookListWithModifiers:nil onSuccess:^(NSArray *books) {} onError:^(NSError *responseError){ error = responseError; }]; });
                it(@"should invoke the block", ^{ [[expectFutureValue(error) shouldEventually] beNonNil]; });
            });
            
            context(@"without an error block", ^{
                beforeEach(^{ [service getBookListWithModifiers:nil onSuccess:^(NSArray *books) {} onError:nil]; });
                it(@"shouldn't fail", ^{ /* Empty example to exercise method invocation without error block */ });
            });
        });
    });
    
    context(@"when retrieving a book", ^{
        __block GGBook *book;
        
        context(@"successfully", ^{
            beforeEach(^{
                NSString *getBookPathPattern = [objectManager.router.routeSet routeForClass:[GGBook class] method:RKRequestMethodGET].pathPattern;
                [INOHHTTPStubsHelper stubHTTPResponseForPathPattern:getBookPathPattern method:@"GET" withFixtureName:@"network.book.json"];

                [service getBookWithId:@"book-id" onSuccess:^(GGBook *actualBook) {
                    book = actualBook;
                } onError:nil];
            });
            
            it(@"should correctly return the book", ^{
                [[expectFutureValue(book)          shouldEventually] beNonNil];
                [[expectFutureValue(book.title)    shouldEventually] equal:@"The Hitch-hikers Guide to the Galaxy"];
                [[expectFutureValue(book.author)   shouldEventually] equal:@"Douglas Adams"];
                [[expectFutureValue(book.price)    shouldEventually] equal:[NSDecimalNumber decimalNumberWithString:@"5.62"]];
                [[expectFutureValue(book.imageURL) shouldEventually] equal:[NSURL URLWithString:@"http://assignment.golgek.mobi/static/42.jpg"]];
            });
            
            context(@"without a book id", ^{
                it(@"should raise an exception", ^{
                    [[theBlock(^{ [service getBookWithId:nil onSuccess:^(GGBook *book) {} onError:nil]; }) should] raise];
                });
            });
            
            context(@"without a success block", ^{
                it(@"should raise an exception", ^{
                    [[theBlock(^{ [service getBookWithId:@"book-id" onSuccess:nil onError:nil]; }) should] raise];
                });
            });
        });
        
        context(@"unsuccessfully", ^{
            beforeAll(^{
                NSString *getBookPathPattern = [objectManager.router.routeSet routeForClass:[GGBook class] method:RKRequestMethodGET].pathPattern;
                [INOHHTTPStubsHelper stubHTTPErrorResponseForPathPattern:getBookPathPattern method:@"GET" withStatusCodes:500];
            });
            
            context(@"with an error block", ^{
                __block NSError *error;
                beforeEach(^{ error = nil; [service getBookWithId:@"book-id" onSuccess:^(GGBook *book) {} onError:^(NSError *responseError){ error = responseError; }]; });
                it(@"should invoke the block", ^{ [[expectFutureValue(error) shouldEventually] beNonNil]; });
            });
            
            context(@"without an error block", ^{
                beforeEach(^{ [service getBookWithId:@"book-id" onSuccess:^(GGBook *book) {} onError:nil]; });
                it(@"shouldn't fail", ^{ /* Empty example to exercise method invocation without error block */ });
            });
        });
    });
});


SPEC_END


