//
//  ExLogDetailViewController.h
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import <UIKit/UIKit.h>
#import "ExLogConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExLogDetailViewController : UIViewController

- (id)initWithLog:(NSString *)logText forDateString:(NSString *)logDate;

- (void)updateWithConfig:(void(^)(ExLogConfig *config))configBlock;
@end

NS_ASSUME_NONNULL_END
