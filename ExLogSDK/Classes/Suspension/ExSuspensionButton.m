//
//  ExSuspensionButton.m
//  ExLogSDK
//
//  Created by ecarx on 2019/12/13.
//

#import "ExSuspensionButton.h"

#define kTouchWidth self.frame.size.width
#define kTouchHeight self.frame.size.height

@implementation ExSuspensionButton

-(instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = color;
        self.alpha = 1.0;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
       
        //拖动
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeLocation:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        //点击
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - event response
- (void)changeLocation:(UIPanGestureRecognizer*)p
{
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [p locationInView:appWindow];
    
    //透明度
    if(p.state == UIGestureRecognizerStateBegan)
    {
        self.alpha = 1;
    }
    else if (p.state == UIGestureRecognizerStateEnded)
    {
        self.alpha = 0.5;
    }
    
    //位置
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }else if(p.state == UIGestureRecognizerStateEnded)
    {
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs([[UIScreen mainScreen] bounds].size.width - left);
        //ripper:只停留在左右，需要在上下，将注释打开
        //        CGFloat top = fabs(panPoint.y);
        //        CGFloat bottom = fabs(kScreenHeight - top);
        
        CGFloat minSpace = MIN(left, right);
        //        CGFloat minSpace = MIN(MIN(MIN(top, left), bottom), right);
        CGPoint newCenter;
        CGFloat targetY = 0;
        
        //校正Y
        if (panPoint.y < 15 + kTouchHeight/2.0) {
            targetY = 15 + kTouchHeight/2.0;
        }else if (panPoint.y > ([[UIScreen mainScreen] bounds].size.height - kTouchHeight/2.0 - 15)) {
            targetY = [[UIScreen mainScreen] bounds].size.height - kTouchHeight/2.0 - 15;
        }else{
            targetY = panPoint.y;
        }
        
        if (minSpace == left) {
            newCenter = CGPointMake(kTouchHeight/3 + 20, targetY);
        } else {
            newCenter = CGPointMake([[UIScreen mainScreen] bounds].size.width-kTouchHeight/3-20, targetY);
        }
        
        [UIView animateWithDuration:.25 animations:^{
            self.center = newCenter;
        }];
    }
}

- (void)click
{
    if([self.delegate respondsToSelector:@selector(suspensionViewClick:)])
    {
        [self.delegate suspensionViewClick:self];
    }
}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];

}
@end
