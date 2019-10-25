//
//  ExLogDetailViewController.h
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import <ExMVVMKit/ExMVVMKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kMail_cc_ToRecipients_Address = @"11873288@qq.com";

@interface ExLogDetailViewController : BaseViewController

- (id)initWithLog:(NSString *)logText forDateString:(NSString *)logDate;

@end

NS_ASSUME_NONNULL_END