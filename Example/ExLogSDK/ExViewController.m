//
//  EXViewController.m
//  ExLogSDK
//
//  Created by Geely on 10/24/2019.
//  Copyright (c) 2019 samspirit. All rights reserved.
//

#import "ExViewController.h"
#import <ExLogSDK/ExLogSDK.h>
#import "ExLogData.h"

@interface ExViewController ()
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ExViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[ExLogSDK sharedManager] setLogShow:YES];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"显示" forState:UIControlStateNormal];
    [button setTitle:@"隐藏" forState:UIControlStateSelected];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(showClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"越界" style:UIBarButtonItemStyleDone target:self action:@selector(nextClick)];
    UIBarButtonItem *logItem = [[UIBarButtonItem alloc] initWithTitle:@"log" style:UIBarButtonItemStyleDone target:self action:@selector(logClick)];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"auto" style:UIBarButtonItemStyleDone target:self action:@selector(autoClick)];
    self.navigationItem.rightBarButtonItems = @[nextItem, clearItem, logItem, showItem];
}

- (IBAction)btnLogClick:(UIButton *)sender {
    ExLog(@"ExLog");
    ExLogError(@"ExLogError");
    ExLogDebug(@"ExLogDebug");
    ExLogInfo(@"ExLogInfo");
    ExLogWarn(@"ExLogWarn");
}

- (void)showClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [ExLogSDK sharedManager].logShow = YES;
    } else {
        [ExLogSDK sharedManager].logShow = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextClick
{
    NSString *text = self.array[100];
    NSLog(@"数组越界 %@",text);
    ExViewController *nextVC = [ExViewController new];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (NSArray *)array
{
    return @[@"1", @"2", @"3", @"4", @"5"];
}

- (void)logClick
{
    NSLog(@"array: %@", self.array);
    
    NSDictionary *dict = @{@"name":@"lix", @"sex":@"1", @"age":@(300), @"company":@"nothing"};
    NSLog(@"dict: %@", dict);
    
    NSArray *arrayDict = @[self.array, dict];
    NSLog(@"arrayDict: %@", arrayDict);
    
    if (self.navigationController.viewControllers.count > 5) {
        NSLog(@"text: %@", [self.array objectAtIndex:20]);
        NSString *s = [NSString stringWithFormat:@"text: %@",[self.array objectAtIndex:20]];
        ExLog(s);
    }
    
    ExLogData *data = [[ExLogData alloc] init];
    data.name = @"ming";
    data.job = @"ios";
    data.age = @"100";
    data.company = @"is nothing";
    data.project = @[@"project1", @"project2", @"project3", @"project4", @"project5"];
    data.learn = @{@"key":@"value", @"project":@(10), @"team":@[@"zhangsan", @"lisi", @"wangwu"]};
    ExLog(data.objectDescription);
}

- (void)autoClick
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printLog) userInfo:nil repeats:YES];
    }
}
NSInteger count = 0;
- (void)printLog
{
    NSLog(@"timer count = %@", @(count));
    count++;
    NSString *string = self.array[arc4random() % self.array.count];

    ExLog(string);
    if (count >= 1000) {
        count = 0;
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
