//
//  ExLogViewController.h
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExLogViewController : UIViewController
@property (nonatomic, strong) NSArray<NSString *> *toRecipients;
@property (nonatomic, strong) NSArray<NSString *> *ccRecipients;
@property (nonatomic, strong) NSArray<NSString *> *bccRecipients;
@end

NS_ASSUME_NONNULL_END
