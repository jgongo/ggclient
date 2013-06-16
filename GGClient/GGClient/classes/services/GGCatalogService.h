//
//  GGCatalogService.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "GGBook.h"


#pragma mark Block type definitions

typedef void (^BookListSuccessBlock)(NSArray *books);
typedef void (^BookSuccessBlock)    (GGBook  *book);
typedef void (^ErrorBlock)          (NSError *error);


#pragma mark - Constant definitions

extern NSString* const GGRKObjectRequestOperationKey;

extern NSString* const GGRequestModifierCountKey;
extern NSString* const GGRequestModifierOffsetKey;


#pragma mark - Class interface

@interface GGCatalogService : NSObject

@property (nonatomic, strong) RKObjectManager *objectManager;

- (void)getBookListWithModifiers:(NSDictionary *)modifiers onSuccess:(BookListSuccessBlock)onSuccess onError:(ErrorBlock)onError;
- (void)getBookWithId:(NSString *)bookId onSuccess:(BookSuccessBlock)onSuccess onError:(ErrorBlock)onError;

@end
