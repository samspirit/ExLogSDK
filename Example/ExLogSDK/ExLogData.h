//
//  ExLogData.h
//  ExLogSDK_Example
//
//  Created by ecarx on 2020/1/8.
//  Copyright © 2020 11873288@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExLogData : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSArray *project;
@property (nonatomic, strong) NSDictionary *learn;
@end

NS_ASSUME_NONNULL_END
