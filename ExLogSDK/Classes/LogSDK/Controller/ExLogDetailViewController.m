//
//  ExLogDetailViewController.m
//  ExLogSDK
//
//  Created by ecarx on 2019/10/24.
//

#import "ExLogDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface ExLogDetailViewController () <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSString *logText;
@property (nonatomic, strong) NSString *logDate;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation ExLogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.editable = NO;
    self.textView.text = self.logText;
    [self.view addSubview:self.textView];
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"send" style:UIBarButtonItemStyleDone target:self action:@selector(sendMailMessage)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithLog:(NSString *)logText forDateString:(NSString *)logDate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _logText = logText;
        _logDate = logDate;
        self.title = logDate;
    }
    return self;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            DDLogDebug(@"LoggerDetailViewController -> mailComposeController:Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            DDLogDebug(@"LoggerDetailViewController -> mailComposeController:Mail saved...");
            break;
        case MFMailComposeResultSent:
            DDLogDebug(@"LoggerDetailViewController -> mailComposeController:Mail sent Success");
            break;
        case MFMailComposeResultFailed:
            DDLogDebug(@"LoggerDetailViewController -> mailComposeController:Mail send errored:发送邮件失败...");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 自定义代码

-(void)sendMailMessage
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail])
    {
        [mc setSubject:@"APP运行日志"];
        // 设置收件人
        NSString *mailName = [ExLogSDK sharedManager].mailName;
        NSString *sendMailName = [mailName isEqualToString:@""] ? kMail_ToRecipients_Address : mailName;
        [mc setToRecipients:[NSArray arrayWithObjects:sendMailName, nil]];
        //设置cc 设置抄送人
        NSArray *ccList = [ExLogSDK sharedManager].ccMailArray;
        if ([ccList count] > 0) {
            [mc setCcRecipients:ccList];
        }
        
        //设置bcc 设置密抄送
        NSArray *bccList = [ExLogSDK sharedManager].bccMailArray;
        if ([bccList count] > 0) {
            [mc setBccRecipients:bccList];
        }
        //纯文本 如果是带html 可以把isHtml打开
        [mc setMessageBody:_logText isHTML:NO];
        
        //如果有附件
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"blood_orange"
        //                                                     ofType:@"png"];
        //NSData *data = [NSData dataWithContentsOfFile:path];
        //[mc addAttachmentData:data mimeType:@"image/png" fileName:@"blood_orange"];
        
        //在模拟器IOS9都会闪退
        [self presentViewController:mc animated:YES completion:nil];
    }
    else
    {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
//        [MBProgressHUD showMessage:@"设备还没有添加邮件账户,请先增加"];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"警告" message:@"设备还没有添加邮件账户,请先增加" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}
@end
