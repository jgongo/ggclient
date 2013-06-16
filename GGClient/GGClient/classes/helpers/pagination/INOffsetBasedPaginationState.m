//
//  INPaginationMarker.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "INOffsetBasedPaginationState.h"


@implementation INOffsetBasedPaginationState

- (id)initWithTotal:(NSUInteger)total offset:(NSUInteger)offset {
    NSAssert(offset <= total, @"Offset can't be greater than total");
    self = [super init];
    if (self) {
        _total  = total;
        _offset = offset;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(->%i/%i)", self.offset, self.total];
}

- (BOOL)hasMorePages {
    return self.offset < self.total;
}

@end
