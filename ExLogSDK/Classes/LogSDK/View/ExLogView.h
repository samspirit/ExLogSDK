//
//  ExLogView.h
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import <UIKit/UIKit.h>
#import "ExLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExLogView : UITableView
@property (nonatomic, strong) NSMutableArray *array;
/// 时间颜色（默认深灰色）
@property (nonatomic, strong) UIColor *colorLog;

- (void)addModel:(ExLogModel *)model;
//
- (void)postNotificationAddModel;
- (void)addNotificationAddModel;
- (void)removeNotificationAddModel;
@end

NS_ASSUME_NONNULL_END
