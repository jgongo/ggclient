//
//  GGBookMappingSpec.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright 2013 OPEN input. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <Typhoon/Typhoon.h>
#import <RestKit/Testing.h>
#import <RKKiwiMatchers/RKKiwiMatchers.h>
#import "INRestKitHelper.h"
#import "GGClientAssembly.h"
#import "GGBook.h"


SPEC_BEGIN(GGBookMappingSpec)

registerMatchers(@"RK");

describe(@"GGBook mapping", ^{
    __block INRestKitHelper *restkitHelper;
    __block RKMappingTest   *mappingTest;
    
    beforeAll(^{
        [RKTestFixture setFixtureBundle:[NSBundle bundleWithIdentifier:@"com.openinput.GGClientTests"]];
        TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[GGClientAssembly assembly]];
        restkitHelper = [factory componentForType:[INRestKitHelper class]];
    });
    
    afterEach(^{ mappingTest = nil; [RKTestFactory tearDown]; });
    
    context(@"when parsing a valid book", ^{
        beforeEach(^{ mappingTest = [restkitHelper setupMappingTestForClass:[GGBook class] withFixture:@"book.json"]; });
        
        specify(^{ [[mappingTest should] mapKeyPath:@"id"     toKeyPath:@"identifier" withValue:@"42"]; });
        specify(^{ [[mappingTest should] mapKeyPath:@"title"  toKeyPath:@"title"      withValue:@"The Hitch-hikers Guide to the Galaxy"]; });
        specify(^{ [[mappingTest should] mapKeyPath:@"author" toKeyPath:@"author"     withValue:@"Douglas Adams"]; });
        specify(^{ [[mappingTest should] mapKeyPath:@"image"  toKeyPath:@"imageURL"   withValue:[NSURL URLWithString:@"http://assignment.golgek.mobi/static/42.jpg"]]; });
        specify(^{ [[mappingTest should] mapKeyPath:@"price"  toKeyPath:@"price"      withValue:[NSDecimalNumber decimalNumberWithString:@"5.62"]]; });
    });
});

SPEC_END
