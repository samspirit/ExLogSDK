//
//  ExLogSDK.m
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import "ExLogSDK.h"
#import "ExLogViewController.h"
#import "ExLogFormatter.h"

NSString * const kMail_ToRecipients_Address = @"youjie.xu@ecarx.com.cn";

@implementation ExLogSDK
@synthesize mailName = _mailName,ccMailArray = _ccMailArray, bccMailArray = _bccMailArray;

+(void)load {
    [super load];
    
    [MGJRouter registerURLPattern:kLibExLogger toObjectHandler:^id(NSDictionary *routerParameters) {
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
    // 添加控制台输出Logger
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:self.fileLogger];
    
    // 允许设置颜色值
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    // DDTTYLogger支持自定义日志的颜色（自定义DDLogInfo日志的颜色为蓝色，DDLogFlagInfo即LOG_FLAG_INFO）
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor purpleColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    //设置输出的LOG样式
    ExLogFormatter *formatter = [[ExLogFormatter alloc] init];
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
#pragma mark - getter && setter
-(NSString *)mailName
{
    return _mailName;
}
-(void)setMailName:(NSString *)mailName
{
    _mailName = mailName;
}

-(NSArray *)ccMailArray
{
    return _ccMailArray;
}
-(void)setCcMailArray:(NSArray *)ccMailArray
{
    _ccMailArray = ccMailArray;
}

-(NSArray *)bccMailArray
{
    return _bccMailArray;
}
-(void)setBccMailArray:(NSArray *)bccMailArray
{
    _bccMailArray = bccMailArray;
}
@end
