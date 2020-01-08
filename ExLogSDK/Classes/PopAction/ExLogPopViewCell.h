//
//  ExLogPopViewCell.h
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import <UIKit/UIKit.h>
#import "ExLogPopAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExLogPopViewCell : UITableViewCell
//
@property (nonatomic, strong) ExLogPopAction *action;

+ (UIFont *)titleFont;
@end

NS_ASSUME_NONNULL_END
