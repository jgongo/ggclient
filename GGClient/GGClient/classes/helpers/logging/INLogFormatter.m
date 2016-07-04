//
//  INLogFormatter.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 16/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "INLogFormatter.h"


@interface INLogFormatter ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation INLogFormatter

- (id)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.mmm"];
    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage -> logFlag) {
        case LOG_FLAG_VERBOSE: logLevel = @"D"; break;
        case LOG_FLAG_INFO   : logLevel = @"I"; break;
        case LOG_FLAG_WARN   : logLevel = @"W"; break;
        case LOG_FLAG_ERROR  : logLevel = @"E"; break;
        default              : logLevel = @"?";
    }
    
    NSString *file   = [[[NSString stringWithCString:logMessage -> file encoding:NSUTF8StringEncoding] componentsSeparatedByString:@"/"] lastObject];
    NSString *method = [NSString stringWithCString:logMessage -> function encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"%@ %@ [%@] %@:%i %@ %@", [self.dateFormatter stringFromDate:logMessage -> timestamp], logLevel, logMessage -> threadName, file, logMessage -> lineNumber, method, logMessage -> logMsg];
}

@end
