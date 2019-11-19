//
//  ExLogSDK.h
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MGJRouter/MGJRouter.h>
#import "ExLogFormatter.h"
#import "ExLogViewController.h"
#import "ExLogDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN
#define kLibExLogger @"lib://ExLogger"

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface ExLogSDK : NSObject

@property (nonatomic, strong) DDFileLogger *fileLogger;

+ (instancetype)sharedManager;
@end

NS_ASSUME_NONNULL_END
