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

@interface ExViewController ()

@end

@implementation ExViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [ExLogSDK sharedManager];
    
    DDLogDebug(@"error");
    DDLogError(@"error");
    DDLogInfo(@"info");
    DDLogVerbose(@"Verbose");
    DDLogWarn(@"DDLogWarn");
}

- (IBAction)btnLogClick:(UIButton *)sender {
    UIViewController *logView = [MGJRouter objectForURL:kLibExLogger withUserInfo:nil];
    [self.navigationController pushViewController:logView animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
