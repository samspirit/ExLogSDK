//
//  ExSuspensionManager.m
//  ExLogSDK
//
//  Created by ecarx on 2019/12/13.
//

#import "ExSuspensionManager.h"
#import "ExSuspensionButton.h"

@interface ExSuspensionManager() <ExSuspensionViewDelegate>
/** 悬浮球*/
@property (nonatomic , strong) ExSuspensionButton *susGlobe;
@end

@implementation ExSuspensionManager

+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (ExSuspensionButton *)susGlobe{
    if (!_susGlobe) {
        _susGlobe = [[ExSuspensionButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 60, [[UIScreen mainScreen] bounds].size.height - 130, 50, 50) color:[UIColor clearColor]];
//        [_susGlobe setImage:[UIImage imageNamed:@"实境"] forState:UIControlStateNormal];
        [_susGlobe setBackgroundColor:[UIColor redColor]];
        _susGlobe.delegate = self;
    }
    return _susGlobe;
}

- (void)createSuspension{

    [self.susGlobe show];

}
//显示悬浮球
- (void)displaySuspension;
{
    self.susGlobe.hidden = NO;
}
//隐藏悬浮球
- (void)hiddenSuspension;
{
    self.susGlobe.hidden = YES;

}
//改变悬浮球的透明度
- (void)changeSuspensionAlpha:(CGFloat)alpha;
{
    self.susGlobe.alpha = alpha;

}
#pragma mark - ANTSuspensionViewDelegate
- (void)suspensionViewClick:(ExSuspensionButton *)suspensionView
{
//    if([self.delegate respondsToSelector:@selector(suspensionManagerClick:)]) {
//        [self.delegate suspensionManagerClick:self];
//    }
    
    
    
    
    NSDictionary *dict = @{@"to":@[@"1236666"],@"bcc":@[@"1234"]};
    UIViewController *logView = [MGJRouter objectForURL:kLibExLogger withUserInfo:dict];
    
//    self presentViewController
    
//    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    [[self getCurrentVC] presentViewController:logView animated:NO completion:nil];

    
//    [[self getCurrentVC].navigationController pushViewController:logView animated:YES];
}

-(UIViewController *)getCurrentVC {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    return [nextResponder isKindOfClass:[UIViewController class]] ? nextResponder : window.rootViewController;
}
@end
