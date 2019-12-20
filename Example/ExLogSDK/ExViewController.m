//
//  EXViewController.m
//  ExLogSDK
//
//  Created by Geely on 10/24/2019.
//  Copyright (c) 2019 samspirit. All rights reserved.
//

#import "ExViewController.h"
#import <ExLogSDK/ExLogSDK.h>
#import <MGJRouter/MGJRouter.h>

@interface ExViewController () <ExSuspensionManagerDelegate>

@end

@implementation ExViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    DDLogDebug(@"Log Debug");
    DDLogError(@"Log Error");
    DDLogInfo(@"Log Info");
    DDLogVerbose(@"Log Verbose");
    DDLogWarn(@"Log Warn");
}

- (IBAction)btnLogClick:(UIButton *)sender {
    DDLogInfo(@"btn Log Click");
    NSDictionary *dict = @{@"to":@[@"1236666"],@"bcc":@[@"1234"]};
    UIViewController *logView = [MGJRouter objectForURL:kLibExLogger withUserInfo:dict];
    [self.navigationController pushViewController:logView animated:YES];
    
    
//    [[ExSuspensionManager sharedManager] createSuspension];
//    [ExSuspensionManager sharedManager].delegate = self;
//    [[ExSuspensionManager sharedManager] displaySuspension];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)suspensionManagerClick:(ExSuspensionManager *)suspensionView
{
    NSLog(@"www");
}
@end
