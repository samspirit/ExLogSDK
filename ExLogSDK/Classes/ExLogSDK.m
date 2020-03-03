//
//  ExLogSDK.m
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import "ExLogSDK.h"
#import "ExLogPopView.h"
#import "ExLogPopAction.h"
#import "ExLogView.h"
#import "UIDevice+Identifier.h"

static CGFloat const originButton = 20.0;
static CGFloat const sizeButton = 60.0;

@interface ExLogSDK()
//
@property (nonatomic, strong) ExLogFile *logFile;
@property (nonatomic, strong) ExLogView *logView;
/// 入口按钮
@property (nonatomic, strong) UIButton *logButton;
/// 点击入口的列表
@property (nonatomic, strong) NSArray *logActions;
@property (nonatomic, strong) UIView *baseView;
@end

@implementation ExLogSDK

#pragma mark - 实例化
-(instancetype)init
{
    if (self = [super init]) {
        self.baseView = UIApplication.sharedApplication.delegate.window;
        [self logConfig];
    }
    return self;
}

- (void)logConfig
{
    NSSetUncaughtExceptionHandler(&readException);
    [self.logFile read];
    
    NSDictionary *dict = @{
        @"dev_model": [[UIDevice currentDevice].deviceVersion stringByReplacingOccurrencesOfString:@" " withString:@"_"],
        @"dev_os"   : @"ios",
        @"dev_os_version":[NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"],
        @"dev_os_name":[NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleDisplayName"]
    };
    
    [self logText:dict.logDescription key:ExLogViewTypeInfo];
}

+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 视图

- (void)showMenu:(UIButton *)button
{
    [self logMenu];
}

// 拖动手势方法
- (void)panRecognizerAction:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    } else {
        // 拖动视图
        UIView *view = (UIView *)recognizer.view;
        [self.baseView bringSubviewToFront:view];
        
        CGPoint translation = [recognizer translationInView:view.superview];
        CGFloat centerX = view.center.x + translation.x;
        if (centerX < view.frame.size.width / 2) {
            centerX = view.frame.size.width / 2;
        } else if (centerX > view.superview.frame.size.width - view.frame.size.width / 2) {
            centerX = view.superview.frame.size.width - view.frame.size.width / 2;
        }
        CGFloat centerY = view.center.y + translation.y;
        if (centerY < (view.frame.size.height / 2)) {
            centerY = (view.frame.size.height / 2);
        } else if (centerY > view.superview.frame.size.height - view.frame.size.height / 2) {
            centerY = view.superview.frame.size.height - view.frame.size.height / 2;
        }
        view.center = CGPointMake(centerX, centerY);
        [recognizer setTranslation:CGPointZero inView:view];
    }
}

- (void)logMenu
{
    [ExLogPopView.popView showToView:self.logButton actions:self.logActions];
}

- (NSArray *)logActions {
    if (_logActions == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        // - 显示或者隐藏日志
        ExLogPopAction *showAction = [ExLogPopAction actionWithTitle:@"显示" selectTitle:@"隐藏" handler:^(ExLogPopAction * _Nonnull action) {
            
            action.selecte = !action.isSelecte;
            [self logViewShow:action.isSelecte];
        }];
        [array addObject:showAction];
        
        ExLogPopAction *copyAction = [ExLogPopAction actionWithTitle:@"复制" selectTitle:@"" handler:^(ExLogPopAction * _Nonnull action) {
            [self logViewShow:NO];
            showAction.selecte = NO;
            [self logCopy];
        }];
        [array addObject:copyAction];
        
        ExLogPopAction *clearAction = [ExLogPopAction actionWithTitle:@"清空" selectTitle:@"" handler:^(ExLogPopAction * _Nonnull action) {
            [self logViewShow:NO];
            showAction.selecte = NO;
            [self logClear];
        }];
        [array addObject:clearAction];
        
        ExLogPopAction *closeAction = [ExLogPopAction actionWithTitle:@"关闭" selectTitle:@"" handler:^(ExLogPopAction * _Nonnull action) {
            self.logShow = NO;
        }];
        [array addObject:closeAction];
        //
        _logActions = [NSArray arrayWithArray:array];
    }
    return _logActions;
}

#pragma mark - log 处理
- (void)logText:(NSString *)text
{
    [self logText:text key:ExLogViewTypeDefault];
}

- (void)logText:(NSString *)text key:(ExLogViewType)key
{
#ifdef DEBUG
    ExLogModel *model = [self.logFile logWith:text key:key];
    [self.logView addModel:model];
#endif
}
// 日志清理
- (void)logClear
{
#ifdef DEBUG
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认删除log？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.logFile clear];
        self.logView.array = [NSMutableArray new];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [[self getViewController] presentViewController:alertController animated:YES completion:NULL];
    #endif
}

/// 复制日志
- (void)logCopy
{
#ifdef DEBUG
    NSMutableString *text = [[NSMutableString alloc] init];
    for (ExLogModel *model in self.logFile.logs) {
        NSString *string = model.attributeString.string;
        [text appendFormat:@"%@\n\n", string];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
    //
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"已复制到系统粘贴板" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [[self getViewController] presentViewController:alertController animated:YES completion:NULL];
#endif
}

- (void)logViewShow:(BOOL)show
{
    if (show) {
        self.logView.hidden = NO;
        [self.baseView bringSubviewToFront:self.logView];
        [self.baseView bringSubviewToFront:self.logButton];

        self.logView.array = [NSMutableArray arrayWithArray:self.logFile.logs];
            [self.logView addNotificationAddModel];
    } else {
        self.logView.hidden = YES;
        [self.baseView sendSubviewToBack:self.logView];
        [self.logView removeNotificationAddModel];
    }
}

-(UIViewController *) getViewController {
    // 定义一个变量存放当前屏幕显示的viewcontroller
    UIViewController *result = nil;
    // 得到当前应用程序的主要窗口
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    // windowLevel是在 Z轴 方向上的窗口位置，默认值为UIWindowLevelNormal
    if (window.windowLevel != UIWindowLevelNormal) {
        // 获取应用程序所有的窗口
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            // 找到程序的默认窗口（正在显示的窗口）
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                // 将关键窗口赋值为默认窗口
                window = tmpWin;
                break;
            }
        }
    }
    // 获取窗口的当前显示视图
    UIView *frontView = [[window subviews] objectAtIndex:0];
    // 获取视图的下一个响应者，UIView视图调用这个方法的返回值为UIViewController或它的父视图
    id nextResponder = [frontView nextResponder];
    // 判断显示视图的下一个响应者是否为一个UIViewController的类对象
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

#pragma mark - getter && setter

- (void)setLogShow:(BOOL)logShow
{
    _logShow = logShow;

    self.logButton.hidden = !_logShow;
    if (self.logButton.hidden) {
        [self.baseView sendSubviewToBack:self.logButton];
    } else {
        [self.baseView bringSubviewToFront:self.logButton];
    }
}

#pragma mark - lazy
- (ExLogFile *)logFile
{
    if (_logFile == nil) {
        _logFile = [[ExLogFile alloc] init];
    }
    return _logFile;
}

- (ExLogView *)logView
{
    if (_logView == nil) {
        _logView = [[ExLogView alloc] initWithFrame:self.baseView.bounds style:UITableViewStylePlain];
        _logView.userInteractionEnabled = YES;
        _logView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        _logView.hidden = YES;
        [self.baseView addSubview:_logView];
    }
    return _logView;
}

-(UIButton *)logButton
{
    if (_logButton == nil) {
        _logButton = [[UIButton alloc] initWithFrame:CGRectMake(originButton, originButton, sizeButton, sizeButton)];
        _logButton.layer.cornerRadius = _logButton.frame.size.width / 2;
        _logButton.layer.masksToBounds = YES;
        _logButton.layer.borderColor = [UIColor redColor].CGColor;
        _logButton.layer.borderWidth = 3.0;
        _logButton.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.3];
        [_logButton setTitle:@"查看\n日志" forState:UIControlStateNormal];
        _logButton.titleLabel.numberOfLines = 2;
        _logButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_logButton setTitleColor:UIColor.yellowColor forState:UIControlStateNormal];
        [_logButton setTitleColor:UIColor.lightGrayColor forState:UIControlStateHighlighted];
        [_logButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        // 添加拖动手势
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizerAction:)];
        _logButton.userInteractionEnabled = YES;
        [_logButton addGestureRecognizer:panRecognizer];
        //
        [self.baseView addSubview:_logButton];
        [self.baseView bringSubviewToFront:_logButton];
    }
    return _logButton;
}

#pragma mark - 异常

// 获得异常的C函数
void readException(NSException *exception) {
    // 设备信息
    NSString *deviceModel = [NSString stringWithFormat:@"设备类型：%@", UIDevice.currentDevice.model];
    NSString *deviceSystem = [NSString stringWithFormat:@"设备系统：%@", UIDevice.currentDevice.systemName];
    NSString *deviceVersion = [NSString stringWithFormat:@"设备系统版本：%@", UIDevice.currentDevice.systemVersion];
    NSString *deviceName = [NSString stringWithFormat:@"设备名称：%@", UIDevice.currentDevice.name];
    NSString *batteryState = @"UIDeviceBatteryStateUnknown";
    switch (UIDevice.currentDevice.batteryState) {
        case UIDeviceBatteryStateUnknown: batteryState = @"UIDeviceBatteryStateUnknown"; break;
        case UIDeviceBatteryStateUnplugged: batteryState = @"UIDeviceBatteryStateUnplugged"; break;
        case UIDeviceBatteryStateCharging: batteryState = @"UIDeviceBatteryStateCharging"; break;
        case UIDeviceBatteryStateFull: batteryState = @"UIDeviceBatteryStateFull"; break;
        default: break;
    }
    NSString *deviceBatteryState = [NSString stringWithFormat:@"设备电池：%@", batteryState];
    NSString *deviceBattery = [NSString stringWithFormat:@"设备量：%f", UIDevice.currentDevice.batteryLevel];
    // 应用信息
    NSString *appName = [NSString stringWithFormat:@"应用名称：%@", [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleDisplayName"]];
    NSString *appVersion = [NSString stringWithFormat:@"应用版本：%@", [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    // 异常信息
    NSString *errorName = [NSString stringWithFormat:@"异常名称：%@", exception.name];
    NSString *errorReason = [NSString stringWithFormat:@"异常原因：%@",exception.reason];
    NSString *errorUser = [NSString stringWithFormat:@"用户信息：%@",exception.userInfo];
    NSString *errorAddress = [NSString stringWithFormat:@"栈内存地址：%@",exception.callStackReturnAddresses];
    NSArray *symbols = exception.callStackSymbols;
    NSMutableString *errorSymbol = [[NSMutableString alloc] initWithString:@"异常描述："];
    for (NSString *item in symbols) {
        [errorSymbol appendString:@"\n"];
        [errorSymbol appendString:item];
    }
    [errorSymbol appendString:@"\n"];
    //
    NSArray *array = @[deviceModel, deviceSystem, deviceVersion, deviceName, deviceBatteryState, deviceBattery, appName, appVersion, errorName, errorReason, errorUser, errorAddress, errorSymbol];
    NSMutableString *crashString = [[NSMutableString alloc] init];
    for (NSString *string in array) {
        [crashString appendString:string];
        [crashString appendString:@"\n"];
    }
    [[ExLogSDK sharedManager] logText:crashString key:ExLogViewTypeError];
}
@end
