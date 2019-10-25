//
//  ExLogFormatter.m
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import "ExLogFormatter.h"
#import "NSDate+Utilities.h"

@implementation ExLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel = nil;
    switch (logMessage.flag) {
        case DDLogFlagError:
            logLevel = @"[ERROR]";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG]";
            break;
        default:
            logLevel = @"[VBOSE]";
            break;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@ %@ [%@][line %ld] %@ %@", logLevel, [logMessage.timestamp stringWithFormat:@"yyyy-MM-dd HH:mm:ss.S"], logMessage.fileName, logMessage.line, logMessage.function, logMessage.message];
    
    return formatStr;
}
@end
