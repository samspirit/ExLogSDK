//
//  ExLogModel.m
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import "ExLogModel.h"
#import <UIKit/UIKit.h>
#import <pthread/pthread.h>
#import "ExLogSQLite.h"

/// 最多N条记录
static NSInteger const logMaxCount = 1000;

@interface ExLogModel ()
@property (nonatomic, assign) NSString *logTime;
@property (nonatomic, strong) NSString *logText;
@property (nonatomic, assign) ExLogViewType logType;
@end

@implementation ExLogModel

- (instancetype)initWithlog:(NSString *)text key:(ExLogViewType)type
{
    if (self = [super init]) {
        self.logText = text;
        self.logType = type;
        //
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSString *time = [formatter stringFromDate:NSDate.date];
        self.logTime = time;
        //
        CGFloat height = [self heightWithText:text];
        self.height = height;
        //
        NSAttributedString *attribute = [self attributeStringWithTime:self.logTime text:self.logText key:self.logType];
        self.attributeString = attribute;
    }
    return self;
}

/// 内部使用
- (instancetype)initWithTime:(NSString *)time log:(NSString *)text key:(ExLogViewType)type
{
    self = [super init];
    if (self) {
        self.logText = text;
        self.logType = type;
        self.logTime = time;
        //
        CGFloat height = [self heightWithText:text];
        self.height = height;
        //
        NSAttributedString *attribute = [self attributeStringWithTime:time text:text key:type];
        self.attributeString = attribute;
    }
    return self;
}

- (CGFloat)heightWithText:(NSString *)text
{
    CGFloat heigt = heightText;
    if (text && [text isKindOfClass:NSString.class] && text.length > 0) {
        if (7.0 <= [UIDevice currentDevice].systemVersion.floatValue) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size = [text boundingRectWithSize:CGSizeMake(widthText, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            CGFloat heightTmp = size.height;
            heightTmp += 25;
            if (heightTmp < heightText) {
                heightTmp = heightText;
            }
            heigt = heightTmp;
        }
    }
    return heigt;
}

static NSString *const keyStyle = @"--";
- (NSAttributedString *)attributeStringWithTime:(NSString *)time text:(NSString *)text key:(ExLogViewType)type
{
    NSString *typeName = type == ExLogViewTypeDefault ? [self getNameByType:type] : [NSString stringWithFormat:@"[%@]",[self getNameByType:type]];

    NSString *string = [NSString stringWithFormat:@"%@ %@ %@\n%@", time, keyStyle,typeName, text];
    NSMutableAttributedString *logString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange rang = [string rangeOfString:typeName];
    if (rang.location == NSNotFound) {
        rang = [string rangeOfString:keyStyle];
    }

    UIColor *color = nil;
    switch (type) {
        case ExLogViewTypeDefault:
            color = [UIColor whiteColor];
            break;
        case ExLogViewTypeDebug:
            color = [UIColor greenColor];
            break;
        case ExLogViewTypeWarn:
            color = [UIColor yellowColor];
            break;
        case ExLogViewTypeError:
            color = [UIColor redColor];
            break;
        case ExLogViewTypeInfo:
            color = [UIColor cyanColor];
            break;
        default:
            color = [UIColor grayColor];
            break;
    }
    [logString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
//    [logString addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, (rang.location + rang.length))];
    
    return logString;
}

- (ExLogViewType)getTypeByName:(NSString *)name
{
    if ([name isEqualToString:@""]) {
        return ExLogViewTypeDefault;
    } else if ([name isEqualToString:@"Debug"]) {
        return ExLogViewTypeDebug;
    } else if ([name isEqualToString:@"Error"]) {
        return ExLogViewTypeError;
    } else if ([name isEqualToString:@"Warn"]) {
        return ExLogViewTypeWarn;
    } else if ([name isEqualToString:@"Info"]) {
        return ExLogViewTypeInfo;
    }
    return ExLogViewTypeUnknow;
}

- (NSString *)getNameByType:(ExLogViewType)type
{
    switch (type) {
        case ExLogViewTypeDefault: return @"";
        case ExLogViewTypeDebug: return @"Debug";
        case ExLogViewTypeError: return @"Error";
        case ExLogViewTypeWarn: return @"Warn";
        case ExLogViewTypeInfo: return @"Info";
        default: return @"unknow";
    }
}
@end


#pragma mark - 文件管理

@interface ExLogFile ()
{
    pthread_mutex_t mutexLock;
}

@property (nonatomic, strong) ExLogSQLite *sqlite;
/// 默认保存N条记录，超过则自动删除
@property (nonatomic, strong) NSMutableArray *logArray;

@end

@implementation ExLogFile

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&mutexLock, NULL);
        
        [self initializeSQLiteTable];
    }
    return self;
}

- (void)dealloc
{
    pthread_mutex_destroy(&mutexLock);
}

- (ExLogModel *)logWith:(NSString *)text key:(ExLogViewType)type
{
    pthread_mutex_lock(&mutexLock);
    if (self.logArray.count >= (logMaxCount - 1)) {
        [self.logArray removeObjectAtIndex:0];
    }
    ExLogModel *model = [[ExLogModel alloc] initWithlog:text key:type];
    [self.logArray addObject:model];
    [self saveLog:model];
    pthread_mutex_unlock(&mutexLock);
    
    return self.logArray.lastObject;
}

- (void)clear
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&self->mutexLock);
        if (self.logArray.count > 0) {
            [self.logArray removeAllObjects];
            [self deleteLog];
        }
        pthread_mutex_unlock(&self->mutexLock);
    });
}

#pragma mark - setter/getter

- (NSMutableArray *)logArray
{
    if (_logArray == nil) {
        _logArray = [[NSMutableArray alloc] init];
    }
    return _logArray;
}

- (NSArray *)logs
{
    pthread_mutex_lock(&mutexLock);
    NSArray *arrayTmp = [NSArray arrayWithArray:self.logArray];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ExLogModel *model in arrayTmp) {
        [array insertObject:model atIndex:0];
    }
    pthread_mutex_unlock(&mutexLock);
    return array;
}

#pragma mark - 存储

- (ExLogSQLite *)sqlite
{
    if (_sqlite == nil) {
        _sqlite = [[ExLogSQLite alloc] init];
    }
    return _sqlite;
}

- (void)initializeSQLiteTable
{
    // // ID, LogTime, logType, LogText
    NSString *sql = @"CREATE TABLE IF NOT EXISTS ExLogRecord(ID INT TEXTPRIMARY KEY, LogTime TEXT, logType TEXT, LogText TEXT NO NULL)";
    [self.sqlite executeSQLite:sql];
}

- (void)saveLog:(ExLogModel *)model
{
    if (model == nil) {
        NSLog(@"没有数据");
        return;
    }
    
    // ID, LogTime, logType, LogText
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO ExLogRecord (ID, LogTime, logType, LogText) VALUES (NULL, '%@', '%@', '%@')", model.logTime, [[ExLogModel alloc] getNameByType:model.logType], model.logText];
    [self.sqlite executeSQLite:sql];
}

- (void)deleteLog
{
    NSString *sql = @"DELETE FROM ExLogRecord";
    [self.sqlite executeSQLite:sql];
}

- (void)read
{
    pthread_mutex_lock(&mutexLock);
    NSString *sql = @"SELECT * FROM ExLogRecord";
    NSArray *array = [self.sqlite selectSQLite:sql];
    [self.logArray removeAllObjects];
    NSMutableArray *logTmp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        NSString *logTime = dict[@"logTime"];
        NSString *logType = dict[@"logType"];
        NSString *logText = dict[@"logText"];
        ExLogModel *model = [[ExLogModel alloc] initWithTime:logTime log:logText key:[[ExLogModel alloc] getTypeByName:logType]];
        [logTmp addObject:model];
    }
    //
    NSInteger number = logTmp.count;
    // 超过N条时删除
    if (number >= logMaxCount) {
        NSInteger numberDel = (number - logMaxCount - 1);
        for (NSInteger index = 0; index < numberDel; index++) {
            // 超过N条时，删除数据库记录
            ExLogModel *model = logTmp.firstObject;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM ExLogRecord WHERE logText = '%@'", model.logText];
                [self.sqlite executeSQLite:sql];
            });
            
            [logTmp removeObjectAtIndex:0];
        }
    }
    [self.logArray addObjectsFromArray:logTmp];
    pthread_mutex_unlock(&mutexLock);
}

@end
