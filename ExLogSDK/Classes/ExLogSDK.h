//
//  ExLogSDK.h
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExLogSDK : NSObject

@property (nonatomic, strong) DDFileLogger *fileLogger;

+ (instancetype)sharedManager;
@end

NS_ASSUME_NONNULL_END
