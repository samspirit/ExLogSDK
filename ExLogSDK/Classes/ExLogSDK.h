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

extern NSString * const kMail_ToRecipients_Address;


static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface ExLogSDK : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) DDFileLogger *fileLogger;

/// 收件人
@property (nonatomic, copy) NSString *mailName;
@property (nonatomic, copy) NSArray *ccMailArray;
@property (nonatomic, copy) NSArray *bccMailArray;
@end

NS_ASSUME_NONNULL_END
