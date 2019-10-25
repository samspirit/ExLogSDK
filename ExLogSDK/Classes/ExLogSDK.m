//
//  ExLogSDK.m
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import "ExLogSDK.h"
#import <ExMVVMKit/ExMVVMKit.h>
#import "ExLogViewController.h"


#import "ExLogFormatter.h"

@implementation ExLogSDK

+(void)load {
    [super load];
    
    [ModuleRouter registerURLPattern:@"ykt://geely2.0/RPAControl" toObjectHandler:^id(NSDictionary *routerParameters) {
        return [[ExLogViewController alloc] init];
    }];
}


-(instancetype)init
{
    if (self = [super init]) {
        [self configureLogging];
    }
    return self;
}

+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


#pragma mark - Configuration

- (void)configureLogging
{
    // Enable XcodeColors利用XcodeColors显示色彩（不写没效果）
    setenv("XcodeColors", "YES", 0);
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:self.fileLogger];
    
    //设置颜色值
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor purpleColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    //设置输出的LOG样式
    ExLogFormatter* formatter = [[ExLogFormatter alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
}

#pragma mark - Getters

-(DDFileLogger *)fileLogger
{
    if (!_fileLogger) {
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        
        _fileLogger = fileLogger;
    }
    
    return _fileLogger;
}

@end
