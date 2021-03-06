//
//  ExLogPopView.m
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import "ExLogPopView.h"
#import "ExLogPopAction.h"
#import "ExLogPopViewCell.h"

static float const PopoverViewCellHorizontalMargin = 15.f; ///< 水平边距
//static float const PopoverViewCellVerticalMargin = 3.f; ///< 垂直边距
//static float const PopoverViewCellTitleLeftEdge = 8.f; ///< 标题左边边距
static float const kPopoverViewMargin = 8.f; ///< 边距
static float const kPopoverViewCellHeight = 40.f; ///< cell指定高度
static float const kPopoverViewArrowHeight = 13.f; ///< 箭头高度

// convert degrees to radians
float DegreesToRadians(float angle) {
    return angle * M_PI / 180;
}

@interface ExLogPopView() <UITableViewDelegate, UITableViewDataSource>
///< 当前窗口
@property (nonatomic, weak) UIWindow *keyWindow;
@property (nonatomic, strong) UITableView *tableView;
///< 遮罩层
@property (nonatomic, strong) UIView *shadeView;
///< 边框Layer
@property (nonatomic, weak) CAShapeLayer *borderLayer;
///< 点击背景阴影的手势
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture;
//
@property (nonatomic, copy) NSArray<ExLogPopAction *> *actionArray;
///< 窗口宽度
@property (nonatomic, assign) CGFloat windowWidth;
///< 窗口高度
@property (nonatomic, assign) CGFloat windowHeight;
///< 箭头指向, YES为向上, 反之为向下, 默认为YES.
@property (nonatomic, assign) BOOL isUpward;
@end

@implementation ExLogPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUI];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, (self.isUpward ? kPopoverViewArrowHeight : 0), CGRectGetWidth(self.bounds), (CGRectGetHeight(self.bounds) - kPopoverViewArrowHeight));
}

+ (instancetype)popView
{
    ExLogPopView *view = [[ExLogPopView alloc] init];
    return view;
}

- (void)setUI
{
    self.actionArray = @[];
    self.isUpward = YES;
    //
    self.backgroundColor = [UIColor whiteColor];
    // keyWindow
    self.keyWindow = [UIApplication sharedApplication].keyWindow;
    self.windowWidth = CGRectGetWidth(self.keyWindow.bounds);
    self.windowHeight = CGRectGetHeight(self.keyWindow.bounds);
    // shadeView
    self.shadeView = [[UIView alloc] initWithFrame:self.keyWindow.bounds];
    [self setShowShade:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.shadeView addGestureRecognizer:tapGesture];
    self.tapGesture = tapGesture;
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = UIColor.clearColor;
    [self.tableView registerClass:ExLogPopViewCell.class forCellReuseIdentifier:NSStringFromClass(ExLogPopViewCell.class)];
    [self addSubview:self.tableView];
}

#pragma mark - getter && setter

- (void)setHideWhileTouch:(BOOL)hideWhileTouch
{
    _hideWhileTouch = hideWhileTouch;
    self.tapGesture.enabled = _hideWhileTouch;
}

- (void)setShowShade:(BOOL)showShade
{
    _showShade = showShade;
    self.shadeView.backgroundColor = _showShade ? [UIColor colorWithWhite:0.f alpha:0.18f] : [UIColor clearColor];
    if (self.borderLayer) {
        self.borderLayer.strokeColor = _showShade ? [UIColor clearColor].CGColor : self.tableView.separatorColor.CGColor;
    }
}

#pragma mark - methord

/*! @brief 显示弹窗指向某个点,  */
- (void)showToPoint:(CGPoint)toPoint
{
    NSAssert(self.actionArray.count > 0, @"actions must not be nil or empty !");
    
    // 截取弹窗时相关数据
    float arrowWidth = 28;
    float cornerRadius = 6.f;
    float arrowCornerRadius = 2.5f;
    float arrowBottomCornerRadius = 4.f;
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + arrowWidth / 2 + 2;
    if (toPoint.x < minHorizontalEdge) {
        toPoint.x = minHorizontalEdge;
    }
    if (self.windowWidth - toPoint.x < minHorizontalEdge) {
        toPoint.x = self.windowWidth - minHorizontalEdge;
    }
    
    // 遮罩层
    self.shadeView.alpha = 0.f;
    [self.keyWindow addSubview:self.shadeView];
    
    // 刷新数据以获取具体的ContentSize
    [self.tableView reloadData];
    // 根据刷新后的ContentSize和箭头指向方向来设置当前视图的frame
    CGFloat widthSelf = [self calculateMaxWidth]; // 宽度通过计算获取最大值
    CGFloat heightSelf = self.tableView.contentSize.height + kPopoverViewArrowHeight;
    
    // 限制最高高度, 免得选项太多时超出屏幕
    CGFloat maxHeight = self.isUpward ? (self.windowHeight - toPoint.y - kPopoverViewMargin) : (toPoint.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    if (heightSelf > maxHeight) {
        // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
        heightSelf = maxHeight;
        self.tableView.scrollEnabled = YES;
        if (!self.isUpward) {
            // 箭头指向下则移动到最后一行
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.actionArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    CGFloat currentX = (toPoint.x - widthSelf / 2);
    CGFloat currentY = toPoint.y;
    // x: 窗口靠左
    if (toPoint.x <= (widthSelf / 2 + kPopoverViewMargin)) {
        currentX = kPopoverViewMargin;
    }
    // x: 窗口靠右
    if ((self.windowWidth - toPoint.x) <= (widthSelf / 2 + kPopoverViewMargin)) {
        currentX = (self.windowWidth - kPopoverViewMargin - widthSelf);
    }
    // y: 箭头向下
    if (!self.isUpward) {
        currentY = toPoint.y - heightSelf;
    }
    
    self.frame = CGRectMake(currentX, currentY, widthSelf, heightSelf);
    
    // 截取箭头
    CGPoint arrowPoint = CGPointMake(toPoint.x - CGRectGetMinX(self.frame), self.isUpward ? 0 : heightSelf); // 箭头顶点在当前视图的坐标
    CGFloat maskTop = (self.isUpward ? kPopoverViewArrowHeight : 0); // 顶部Y值
    CGFloat maskBottom = (self.isUpward ? heightSelf : (heightSelf - kPopoverViewArrowHeight)); // 底部Y值
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(0, cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + maskTop)
                        radius:cornerRadius
                    startAngle:DegreesToRadians(180)
                      endAngle:DegreesToRadians(270)
                     clockwise:YES];
    // 箭头向上时的箭头位置
    if (self.isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth / 2, kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverViewArrowHeight)
                         controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, kPopoverViewArrowHeight)];
    }
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(widthSelf - cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(widthSelf - cornerRadius, maskTop + cornerRadius)
                        radius:cornerRadius
                    startAngle:DegreesToRadians(270)
                      endAngle:DegreesToRadians(0)
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(widthSelf, maskBottom - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(widthSelf - cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:DegreesToRadians(0)
                      endAngle:DegreesToRadians(90)
                     clockwise:YES];
    // 箭头向下时的箭头位置
    if (!self.isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth / 2, heightSelf - kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, heightSelf - arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x + arrowWidth / 2 - arrowBottomCornerRadius, heightSelf - kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, heightSelf - arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowWidth / 2, heightSelf - kPopoverViewArrowHeight)
                         controlPoint:CGPointMake(arrowPoint.x - arrowWidth / 2 + arrowBottomCornerRadius, heightSelf - kPopoverViewArrowHeight)];
    }
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:DegreesToRadians(90)
                      endAngle:DegreesToRadians(180)
                     clockwise:YES];
    [maskPath closePath];
    // 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // 边框 (只有在不显示半透明阴影层时才设置边框线条)
    if (!self.showShade) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = self.bounds;
        borderLayer.path = maskPath.CGPath;
        //
        borderLayer.lineWidth = 3;
        borderLayer.fillColor = [UIColor.redColor colorWithAlphaComponent:0.3].CGColor;
        borderLayer.strokeColor = UIColor.redColor.CGColor;
        [self.layer addSublayer:borderLayer];
        self.borderLayer = borderLayer;
    }
    
    [self.keyWindow addSubview:self];
    
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / widthSelf, self.isUpward ? 0.f : 1.f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.shadeView.alpha = 1.f;
    }];
}

/*! @brief 计算最大宽度 */
- (CGFloat)calculateMaxWidth
{
    CGFloat width = 0;
    UIFont *font = [ExLogPopViewCell titleFont];
    for (ExLogPopAction *action in self.actionArray) {
        CGFloat titleWidth = [action.titleNormal sizeWithAttributes:@{NSFontAttributeName:font}].width;
        titleWidth = (PopoverViewCellHorizontalMargin * 2 + titleWidth + kPopoverViewMargin);
        if (titleWidth > width) {
            width = titleWidth;
        }
    }
    if (width > (self.keyWindow.bounds.size.width - kPopoverViewMargin * 2)) {
        width = (self.keyWindow.bounds.size.width - kPopoverViewMargin * 2);
    }
    return width;
}

/*! @brief 点击外部隐藏弹窗 */
- (void)hide
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        self.shadeView.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

/*! @brief 指向指定的View来显示弹窗 */
- (void)showToView:(UIView *)pointView actions:(NSArray<ExLogPopAction *> *)actions
{
    // 判断 pointView 是偏上还是偏下
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:self.keyWindow];
    CGFloat pointViewUpLength = CGRectGetMinY(pointViewRect);
    CGFloat pointViewDownLength = self.windowHeight - CGRectGetMaxY(pointViewRect);
    // 弹窗箭头指向的点
    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    if (pointViewUpLength > pointViewDownLength) {
        // 弹窗在 pointView 顶部
        toPoint.y = pointViewUpLength - 5;
    } else {
        // 弹窗在 pointView 底部
        toPoint.y = CGRectGetMaxY(pointViewRect) + 5;
    }
    
    // 箭头指向方向
    self.isUpward = pointViewUpLength <= pointViewDownLength;
    self.actionArray = [actions copy];
    [self showToPoint:toPoint];
}

/*! @brief 指向指定的点来显示弹窗 */
- (void)showToPoint:(CGPoint)toPoint actions:(NSArray <ExLogPopAction *> *)actions
{
    self.actionArray = [actions copy];
    // 计算箭头指向方向
    self.isUpward = toPoint.y <= self.windowHeight - toPoint.y;
    [self showToPoint:toPoint];
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPopoverViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExLogPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ExLogPopViewCell.class)];
    
    ExLogPopAction *action = self.actionArray[indexPath.row];
    cell.action = action;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExLogPopAction *action = self.actionArray[indexPath.row];
    if (action.handler) {
        action.handler(action);
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        self.shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.actionArray = nil;
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
