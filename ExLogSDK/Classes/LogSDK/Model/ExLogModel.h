//
//  ExLogModel.h
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 显示类型，非实时，或实时
typedef NS_ENUM(NSInteger, ExLogViewType) {
    /// 默认基础的日志
    ExLogViewTypeDefault = 1,
    /// 调试 内容
    ExLogViewTypeDebug = 2,
    /// 错误 输出的内容 （红色）
    ExLogViewTypeError = 3,
    /// 警告 输出的内容  (黄色)
    ExLogViewTypeWarn = 4,
    /// 信息 输出
    ExLogViewTypeInfo = 5,
    /// 未知类型
    ExLogViewTypeUnknow = 9
};

static CGFloat const originXY = 10;
static CGFloat const heightText = (25 + 25);
#define widthText (UIScreen.mainScreen.bounds.size.width - originXY * 2)

@interface ExLogModel : NSObject
//
@property (nonatomic, strong) NSAttributedString *attributeString;
@property (nonatomic, assign) CGFloat height;

- (instancetype)initWithlog:(NSString *)text key:(ExLogViewType)type;
- (ExLogViewType)getTypeByName:(NSString *)name;
- (NSString *)getNameByType:(ExLogViewType)type;
@end


@interface ExLogFile : NSObject

/// 记录（最多500条，倒序）
@property (nonatomic, strong, readonly) NSArray *logs;

- (ExLogModel *)logWith:(NSString *)text key:(ExLogViewType)type;
- (void)read;
- (void)clear;

@end
NS_ASSUME_NONNULL_END
