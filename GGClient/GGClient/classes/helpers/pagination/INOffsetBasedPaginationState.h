//
//  INPaginationMarker.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INPaginator.h"


@interface INOffsetBasedPaginationState : NSObject <INPaginationState>
@property (nonatomic, readonly) NSUInteger total;
@property (nonatomic, readonly) NSUInteger offset;
- (id)initWithTotal:(NSUInteger)total offset:(NSUInteger)offset;
@end
