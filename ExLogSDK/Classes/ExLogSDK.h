//
//  ExLogSDK.h
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import <Foundation/Foundation.h>
#import "NSString+Log.h"
#import "ExLogModel.h"


#ifdef DEBUG
/// 中控打印及log记录
#define ExLog(format, ...) {NSLog( @"< %@:(第 %d 行) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format);[ExLogSDK.sharedManager logText:format];}

#define ExLogDebug(format, ...) {NSLog( @"< %@:(第 %d 行) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format);[ExLogSDK.sharedManager logText:format key:ExLogViewTypeDebug];}

#define ExLogError(format, ...) {NSLog( @"< %@:(第 %d 行) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format);[ExLogSDK.sharedManager logText:format key:ExLogViewTypeError];}

#define ExLogWarn(format, ...) {NSLog( @"< %@:(第 %d 行) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format);[ExLogSDK.sharedManager logText:format key:ExLogViewTypeWarn];}

#define ExLogInfo(format, ...) {NSLog( @"< %@:(第 %d 行) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format);[ExLogSDK.sharedManager logText:format key:ExLogViewTypeInfo];}
#endif


NS_ASSUME_NONNULL_BEGIN
@class ExLogModel;
@interface ExLogSDK : NSObject

+ (instancetype)sharedManager;

/// 显示或隐藏（在设置根视图控制器之后）
@property (nonatomic, assign) BOOL logShow;

- (void)logText:(NSString *)text;
- (void)logText:(NSString *)text key:(ExLogViewType)key;

@end

NS_ASSUME_NONNULL_END
