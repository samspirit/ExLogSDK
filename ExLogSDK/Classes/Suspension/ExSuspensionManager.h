//
//  ExSuspensionManager.h
//  ExLogSDK
//
//  Created by ecarx on 2019/12/13.
//

#import <Foundation/Foundation.h>
#import <MGJRouter/MGJRouter.h>
#import "ExLogSDK.h"

NS_ASSUME_NONNULL_BEGIN

@class ExSuspensionManager;

@protocol ExSuspensionManagerDelegate <NSObject>

/*点击悬浮球的回调 */
- (void)suspensionManagerClick:(ExSuspensionManager *)suspensionView;

@end

@interface ExSuspensionManager : NSObject

@property (nonatomic , weak) id<ExSuspensionManagerDelegate>delegate;

//初始化
+ (instancetype)sharedManager;

//添加悬浮球
- (void)createSuspension;

//显示悬浮球
- (void)displaySuspension;
//隐藏悬浮球
- (void)hiddenSuspension;
//改变悬浮球的透明度
- (void)changeSuspensionAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
