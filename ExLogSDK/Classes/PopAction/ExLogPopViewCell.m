//
//  ExLogPopViewCell.m
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import "ExLogPopViewCell.h"

@implementation ExLogPopViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = self.backgroundColor;
        self.separatorInset = UIEdgeInsetsZero;
        //
        [self setUI];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

#pragma mark 视图

// 初始化
- (void)setUI
{
    self.textLabel.font = [self.class titleFont];
    self.textLabel.textColor = UIColor.blackColor;
}

+ (UIFont *)titleFont
{
    return [UIFont systemFontOfSize:15.f];
}

#pragma mark setter

- (void)setAction:(ExLogPopAction *)action
{
    _action = action;
    if (_action.isSelecte) {
        self.textLabel.text = _action.titleSelect;
        self.textLabel.textColor = UIColor.lightGrayColor;
    } else {
        self.textLabel.text = _action.titleNormal;
        self.textLabel.textColor = UIColor.blackColor;
    }
}


@end
