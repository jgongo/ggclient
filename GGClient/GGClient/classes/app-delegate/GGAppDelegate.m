//
//  GGAppDelegate.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGAppDelegate.h"
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <NSLogger-CocoaLumberjack-connector/DDNSLoggerLogger.h>
#import <Typhoon/Typhoon.h>
#import "INLogFormatter.h"
#import "GGClientAssembly.h"


@implementation GGAppDelegate

#pragma mark Helper methods

- (void)configureLogger
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
#if defined (CONFIGURATION_Debug)
    setenv("XcodeColors", "YES", 0);
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [DDTTYLogger sharedInstance].logFormatter = [[INLogFormatter alloc] init];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
#if defined (CONFIGURATION_Debug) || defined (CONFIGURATION_Testing)
    [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];
#endif
}

- (void)loadSharedObjectsContext
{
    id <TyphoonResource> configurationProperties = [TyphoonBundleResource withName:@"catalog.properties"];
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[GGClientAssembly assembly]];
    [factory attachMutator:[TyphoonPropertyPlaceholderConfigurer configurerWithResource:configurationProperties]];
    [factory makeDefault];
}

#pragma mark Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureLogger];
    [self loadSharedObjectsContext];
    
    return YES;
}
							
@end
