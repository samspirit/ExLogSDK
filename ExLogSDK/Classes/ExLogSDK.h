//
//  ExLogSDK.h
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MGJRouter/MGJRouter.h>
#import "ExSuspensionManager.h"

#define kLibExLogger @"lib://ExLogger"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kMail_ToRecipients_Address;

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface ExLogSDK : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) DDFileLogger *fileLogger;

@end

NS_ASSUME_NONNULL_END
