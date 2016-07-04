//
//  INOffsetBasedPaginationStateSpec.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright 2013 OPEN input. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "INOffsetBasedPaginationState.h"


SPEC_BEGIN(INOffsetBasedPaginationStateSpec)

describe(@"INOffsetBasedPaginationState", ^{
    __block INOffsetBasedPaginationState *state;
    
    context(@"when initialized with offset less than total", ^{
        beforeEach(^{ state = [[INOffsetBasedPaginationState alloc] initWithTotal:10 offset:5]; });

        specify(^{ [[theValue(state.total ) should] equal:theValue(10)]; });
        specify(^{ [[theValue(state.offset) should] equal:theValue( 5)]; });
        it(@"should tell there are more pages available", ^{ [[theValue([state hasMorePages]) should] equal:theValue(YES)]; });
    });
    
    context(@"when initialized with offset equal to total", ^{
        beforeEach(^{ state = [[INOffsetBasedPaginationState alloc] initWithTotal:10 offset:10]; });
        
        specify(^{ [[theValue(state.total ) should] equal:theValue(10)]; });
        specify(^{ [[theValue(state.offset) should] equal:theValue(10)]; });
        it(@"should tell there are more pages available", ^{ [[theValue([state hasMorePages]) should] equal:theValue(NO)]; });
    });
    
    context(@"when initialized with offset greater than total", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
        it(@"should throw an expcetion", ^{ [[theBlock(^{ [[INOffsetBasedPaginationState alloc] initWithTotal:10 offset:15]; }) should] raise]; });
#pragma clang diagnostic pop
    });
});

SPEC_END
