//
//  ExLogSQLite.h
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExLogSQLite : NSObject

/// 建表/删表/插入、更新、删除数据
- (BOOL)executeSQLite:(NSString *)sqlString;
/// 查询
- (NSArray *)selectSQLite:(NSString *)sqlString;
@end

NS_ASSUME_NONNULL_END
