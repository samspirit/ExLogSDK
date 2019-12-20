//
//  ExSuspensionButton.h
//  ExLogSDK
//
//  Created by ecarx on 2019/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ExSuspensionButton;

@protocol ExSuspensionViewDelegate <NSObject>

/** 点击悬浮球的回调 */
- (void)suspensionViewClick:(ExSuspensionButton *)suspensionView;

@end

@interface ExSuspensionButton : UIButton

/** 代理 */
@property (nonatomic, weak) id<ExSuspensionViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color;

/// 显示
- (void)show;

@end

NS_ASSUME_NONNULL_END
