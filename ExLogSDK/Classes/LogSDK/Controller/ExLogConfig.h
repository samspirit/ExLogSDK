//
//  ExLogConfig.h
//  ExLogSDK
//
//  Created by ecarx on 2019/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ExLogConfig;

@interface ExLogConfig : NSObject

+ (instancetype)defaultConfig;

@property (nonatomic, strong) NSArray<NSString *> *toRecipients;
@property (nonatomic, strong) NSArray<NSString *> *ccRecipients;
@property (nonatomic, strong) NSArray<NSString *> *bccRecipients;

@property (nonatomic, copy, readonly) ExLogConfig *(^itemToRecipients)(NSArray<NSString *> *list);

@property (nonatomic, copy, readonly) ExLogConfig *(^itemCcRecipients)(NSArray<NSString *> *list);

@property (nonatomic, copy, readonly) ExLogConfig *(^itemBccRecipients)(NSArray<NSString *> *list);

@end

NS_ASSUME_NONNULL_END
