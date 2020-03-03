//
//  ExLogView.m
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import "ExLogView.h"
#import <pthread/pthread.h>

@interface ExLogCell : UITableViewCell

@property (nonatomic, strong) ExLogModel *model;
@property (nonatomic, strong) UILabel *label;

@end
@implementation ExLogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(originXY, originXY / 2, widthText, heightText)];
        [self.contentView addSubview:self.label];
        self.label.textColor = UIColor.redColor;
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.numberOfLines = 0;
    }
    return self;
}

- (void)setModel:(ExLogModel *)model
{
    _model = model;
    self.label.attributedText = _model.attributeString;
    CGRect rectLabel = self.label.frame;
    rectLabel.size.height = _model.height;
    self.label.frame = rectLabel;
}

@end

@interface ExLogView()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    pthread_mutex_t mutexLock;
}
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, assign) BOOL isSearch;
//
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation ExLogView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        CGFloat height = 0;
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            if (window.safeAreaInsets.bottom > 0.0) {
                // 是机型iPhoneX/iPhoneXR/iPhoneXS/iPhoneXSMax
                height = 20;
            }
        }
        self.tableHeaderView = self.searchView;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = YES;
        [self registerClass:ExLogCell.class forCellReuseIdentifier:NSStringFromClass(ExLogCell.class)];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)dealloc
{
    pthread_mutex_destroy(&mutexLock);
}

- (void)reloadLogView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        [self setContentOffset:CGPointZero];
    });
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.searchArray.count;
    }
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        ExLogModel *model = self.searchArray[indexPath.row];
        CGFloat height = (originXY + model.height);
        return height;
    }
    ExLogModel *model = self.array[indexPath.row];
    CGFloat height = (originXY + model.height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        ExLogCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ExLogCell.class)];
        cell.label.textColor = (self.colorLog ? self.colorLog : UIColor.darkGrayColor);
        ExLogModel *model = self.searchArray[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    ExLogCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ExLogCell.class)];
    cell.label.textColor = (self.colorLog ? self.colorLog : UIColor.darkGrayColor);
    ExLogModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - 搜索

- (UIView *)searchView
{
    if (_searchView == nil) {
        CGFloat top = 20;
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            if (window.safeAreaInsets.bottom > 0.0) {
                // 是机型iPhoneX/iPhoneXR/iPhoneXS/iPhoneXSMax
                top = 44;
            }
        }
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (top + 48))];
        _searchView.backgroundColor = UIColor.clearColor;
        //
        self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, (top + 5), (_searchView.frame.size.width - 20), (_searchView.frame.size.height - top - 10))];
        [_searchView addSubview:self.searchTextField];
        self.searchTextField.layer.cornerRadius = 5;
        self.searchTextField.layer.masksToBounds = YES;
        
        self.searchTextField.backgroundColor = [UIColor colorWithRed:86 green:86 blue:86 alpha:1];
        self.searchTextField.placeholder = @"请输入过滤词";
        self.searchTextField.textColor = UIColor.blackColor;
        self.searchTextField.font = [UIFont systemFontOfSize:15];
        self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.searchTextField.frame.size.height)];
        leftView.backgroundColor = UIColor.clearColor;
        self.searchTextField.leftView = leftView;
        self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        self.searchTextField.delegate = self;
        //
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((_searchView.frame.size.width - 20 - 60), (top + 5), 60, (_searchView.frame.size.height - top - 10))];
        [_searchView addSubview:self.cancelButton];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:UIColor.redColor forState:UIControlStateHighlighted];
        self.cancelButton.layer.cornerRadius = 5;
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.backgroundColor = UIColor.whiteColor;
        [self.cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.alpha = 0.0;
    }
    return _searchView;
}

- (void)cancelClick:(UIButton *)button
{
    [self addNotificationAddModel];

    [UIApplication.sharedApplication.delegate.window endEditing:YES];
    //
    self.searchTextField.text = @"";
    //
    self.isSearch = NO;
    [self.searchArray removeAllObjects];
    [self reloadData];
    
    __block CGRect rect = self.searchTextField.frame;
    [UIView animateWithDuration:0.3 animations:^{
        rect.size.width = (self.searchView.frame.size.width - 40);
        self.searchTextField.frame = rect;
        button.alpha = 0;
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
        // 避免搜索时还在刷新界面，导致无法进行编辑
        [self removeNotificationAddModel];
    
    self.isSearch = YES;
    [self reloadData];
    //
    __block CGRect rect = self.searchTextField.frame;
    [UIView animateWithDuration:0.3 animations:^{
        rect.size.width = (self.searchView.frame.size.width - 40 - 60 - 20);
        self.searchTextField.frame = rect;
        self.cancelButton.alpha = 1;
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIApplication.sharedApplication.delegate.window endEditing:YES];
    [self searchWithText:textField.text];
    [self reloadData];
    
    return YES;
}

- (NSMutableArray *)searchArray
{
    if (_searchArray == nil) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIApplication.sharedApplication.delegate.window endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNotificationAddModel];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNotificationAddModel];
}

- (void)searchWithText:(NSString *)text
{
    [self.searchArray removeAllObjects];
    //
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"logText CONTAINS %@", text];
    NSArray *array = [self.array filteredArrayUsingPredicate:predicate];
    [self.searchArray addObjectsFromArray:array];
}

#pragma mark - setter

- (void)setArray:(NSMutableArray *)array
{
    pthread_mutex_lock(&mutexLock);
    _array = array;
    pthread_mutex_unlock(&mutexLock);
    if (self.isSearch) {
        return;
    }
    //
    [self reloadLogView];
}

#pragma mark - 方法通知

- (void)addModel:(ExLogModel *)model
{
    if (model) {
        pthread_mutex_lock(&mutexLock);
        [self.array insertObject:model atIndex:0];
        pthread_mutex_unlock(&mutexLock);
        if (self.isSearch) {
            return;
        }
        
        [self postNotificationAddModel];
    }
}

static NSString *const kNotificationName = @"reloadTableWhileAddModel";
- (void)postNotificationAddModel
{
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationName object:nil];
}

- (void)addNotificationAddModel
{
    [self removeNotificationAddModel];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadLogView) name:kNotificationName object:nil];
}

- (void)removeNotificationAddModel
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationName object:nil];
}

@end
