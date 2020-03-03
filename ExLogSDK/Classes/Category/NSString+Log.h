//
//  NSString+Log.h
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Log)

@end

@interface NSObject (Log)
/// 对象信息（需要主动调用）
- (NSString *)logDescription;
@end

@interface NSDictionary (Log)
- (NSString *)logDescription;
@end

@interface NSArray (Log)
- (NSString *)logDescription;
@end
NS_ASSUME_NONNULL_END
