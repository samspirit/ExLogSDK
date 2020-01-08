//
//  ExLogPopView.h
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ExLogPopAction;

@interface ExLogPopView : UIView


@property (nonatomic, assign) BOOL hideWhileTouch;
@property (nonatomic, assign) BOOL showShade;

+ (instancetype)popView;

/*
 *  指向指定的View来显示弹窗
 *  @param pointView 箭头指向的View
 *  @param actions   动作对象集合<ExLogPopAction>
 */
- (void)showToView:(UIView *)pointView actions:(NSArray<ExLogPopAction *> *)actions;

/*
 *  指向指定的点来显示弹窗
 *  @param toPoint 箭头指向的点(这个点的坐标需按照keyWindow的坐标为参照)
 *  @param actions 动作对象集合<ExLogPopAction>
 */
- (void)showToPoint:(CGPoint)toPoint actions:(NSArray<ExLogPopAction *> *)actions;
@end

NS_ASSUME_NONNULL_END
