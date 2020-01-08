//
//  ExLogPopAction.h
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExLogPopAction : NSObject

@property (nonatomic, strong) NSString *titleNormal;
@property (nonatomic, strong) NSString *titleSelect;
@property (nonatomic, assign, getter=isSelecte) BOOL selecte;
@property (nonatomic, copy) void(^handler)(ExLogPopAction *action);
//
+ (instancetype)actionWithTitle:(NSString *)titleNormal selectTitle:(NSString *)titleSelect handler:(void (^)(ExLogPopAction *action))handler;
@end

NS_ASSUME_NONNULL_END
