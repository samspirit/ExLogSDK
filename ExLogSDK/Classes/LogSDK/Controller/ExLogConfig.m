//
//  ExLogConfig.m
//  ExLogSDK
//
//  Created by ecarx on 2019/12/13.
//

#import "ExLogConfig.h"

@implementation ExLogConfig

+ (instancetype)defaultConfig
{
    ExLogConfig *config = [[ExLogConfig alloc] init];
    config.toRecipients = @[@"youjie.xu@ecarx.com.cn"];
    return config;
}

-(ExLogConfig *(^)(NSArray<NSString *> * list))itemToRecipients
{
    return ^(NSArray<NSString *> * list) {
        self.toRecipients = list;
        return self;
    };
}

-(ExLogConfig *(^)(NSArray<NSString *> *list))itemCcRecipients
{
    return ^(NSArray<NSString *> * list) {
        self.ccRecipients = list;
        return self;
    };
}

-(ExLogConfig *(^)(NSArray<NSString *> *list))itemBccRecipients
{
    return ^(NSArray<NSString *> * list) {
        self.bccRecipients = list;
        return self;
    };
}
@end
