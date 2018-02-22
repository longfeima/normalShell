//
//  DDBaseNavigationView.m
//  textNav
//
//  Created by CaydenK on 2017/4/7.
//  Copyright © 2017年 CaydenK. All rights reserved.
//

#import "DDBaseNavigationView.h"
#import "DsNavConfig.h"
#import "DDBaseNavColumnView.h"
#import "DDBaseNavHorizontalView.h"

#define SELF_W  self.frame.size.width
#define SELF_H  self.frame.size.height







@interface DDBaseNavigationView ()

@property (nonatomic, strong) UIImageView *bangImageV;

/**
 返回按钮
 */
//@property (nonatomic, strong) UIButton *leftBarButtonItem;
/**
 标题
 */
//@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *columnBtn;

@property (nonatomic, strong) DDBaseNavHorizontalView *titlesView;
/**
 右按钮
 */
//@property (nonatomic, strong) UIButton *rightBarButtonItem;
/**
 右文案
 */
//@property (nonatomic, strong) UILabel *rightBarLabelItem;
/**
 消息tip
 */

@property (nonatomic, strong) UIImageView *titleHeadView;
@property (nonatomic, strong) UIImageView *titleBgHeadView;

@property (nonatomic, strong) UILabel *messageLb;
@property (nonatomic, strong) UIView *maskV;

@property (nonatomic, strong) DDBaseNavColumnView *columnView;



@end

@implementation DDBaseNavigationView
- (instancetype)init{

    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.97];
        self.navType = DD_DefaultType;
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"alpha"];
}


- (instancetype) initWithFram:(CGRect)frame NavType:(DDNavigationType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.navType = type;
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.97];
        [self addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//        [self layoutSubviews];
        self.navType = type;
        [self setUI];
    }
    return self;
}

- (instancetype) initWithFram:(CGRect)frame NavType:(DDNavigationType)type AndDelegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.97];
        self.navType = type;
        [self addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        self.delegate = delegate;
        //        [self layoutSubviews];
        self.navType = type;
        [self setUI];
    }
    return self;
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"alpha"])
    {
//        NSLog(@"\n\n%@\n\n",change);
        CGFloat new = [change[@"new"] floatValue];
        CGFloat scale = MIN(MAX(0, new), 1);
        switch (self.navType) {
            case DD_ScaleTitleType:
            {
                self.titleLb.font = [UIFont systemFontOfSize:20 * scale];
                self.titleLb.center = CGPointMake(self.center.x, self.frame.size.height * (1 - 1 / 3.0 * scale));
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    [self setBackground];
}

- (void)setBackground{
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.frame];
    imageV.center = self.center;
    imageV.image = [UIImage imageNamed:@"user_photo_bg"];
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.97];
    
}

- (void) setUI{
    [self bangImageV];
    [self leftBarButtonItem];
    [self titleLb];
    [self titleView];
    [self titleBgHeadView];
    [self titleHeadView];
    [self rightBarButtonItem];
    [self messageLb];
    [self rightBarLabelItem];
    [self columnBtn];
    [self columnView];
    [self leftCloseLb];
    
    [self maskV];
}

- (void)setNavType:(DDNavigationType)navType{
    _navType = navType;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        obj.hidden = YES;
        if (APP_ISIPHONE_X && [obj isEqual:self.bangImageV]) {
            if ((self.bangImageString.length && [UIImage imageNamed:self.bangImageString]) || (self.bangImageURL.length && [self.bangImageURL hasPrefix:@"http"])) {
                obj.hidden = NO;
            }
        }
    }];
    switch (_navType) {
        case DD_DefaultType:
        {
            self.titleLb.hidden = NO;
        }
            break;
        case DD_NormalType:
        {
            self.leftBarButtonItem.hidden = NO;
            self.titleLb.hidden = NO;
        }
            break;
        case DD_CloseType:
        {
            self.leftBarButtonItem.hidden = NO;
            self.titleLb.hidden = NO;
            self.leftCloseLb.hidden = NO;
        }
            break;
        case DD_ShareType:
        {
            self.leftBarButtonItem.hidden = NO;
            self.titleLb.hidden = NO;
            self.rightBarButtonItem.hidden = NO;
            
        }
            break;
        case DD_AccessMessageType:
        {
            self.leftBarButtonItem.hidden = NO;
            self.titleLb.hidden = NO;
            self.rightBarLabelItem.hidden = NO;
        }
            break;
        
        case DD_ScaleTitleType:
        {
            self.leftBarButtonItem.hidden = NO;
            self.titleLb.hidden = NO;
            self.rightBarButtonItem.hidden = NO;
            self.titleLb.center = CGPointMake(self.center.x, self.frame.size.height);
            self.titleLb.font = [UIFont systemFontOfSize:4];
        }
            break;
        case DD_ColumnType:
        {
            self.leftBarButtonItem.hidden = NO;
            self.titleLb.hidden = NO;
            self.columnBtn.hidden = NO;
            self.columnView.hidden = NO;
            self.maskV.hidden = NO;
            self.maskV.alpha = 0.0;
            self.columnView.alpha = 0.0;
//            self.columnView.frame = CGRectMake(0, 0, 0, 0);
            self.columnView.frame = CGRectMake(APP_SCREEN_WIDTH/2, APP_NAV_HEIGHT, 85, 100);
        }
            break;
            case DD_TitleHorizontalType:
        {
            self.titlesView.hidden = NO;
        }
            break;
        case DD_CenterTitleView:
        {
            self.titleBgHeadView.hidden = NO;
            [self bringSubviewToFront:self.titleBgHeadView];
            self.leftBarButtonItem.hidden = NO;
        }
            break;
        case DD_TitleView:
        {
            self.titleView.hidden = NO;
            [self.titleView setTitle:@"hello" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
}

- (void)setBangImageString:(NSString *)bangImageString{
    _bangImageString = bangImageString;
    if (!APP_ISIPHONE_X) {
        return;
    }
    if (bangImageString.length && [UIImage imageNamed:bangImageString]) {
        self.bangImageV.hidden = NO;
        self.bangImageV.image = [UIImage imageNamed:bangImageString];
    }
}

- (void)setBangImageURL:(NSString *)bangImageURL{
    _bangImageURL = bangImageURL;
    if (!APP_ISIPHONE_X) {
        return;
    }
    if (bangImageURL.length && [bangImageURL hasPrefix:@"http"]) {
        if (self.bangImageString && [UIImage imageNamed:self.bangImageString]) {
            [self.bangImageV sd_setImageWithURL:[NSURL URLWithString:bangImageURL] placeholderImage:[UIImage imageNamed:self.bangImageString]];
        }else{
            [self.bangImageV sd_setImageWithURL:[NSURL URLWithString:self.bangImageURL]];
        }
        self.bangImageV.hidden = NO;
    }
}


// interactive
/**
 返回
 */
- (void)popOrDisViewcontroller {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DDLeftBarButtonItemClick)]) {
        [self.delegate DDLeftBarButtonItemClick];
    }
}

/**
 关闭
 */
- (void)closeClick{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DDCloseBarLabelItemClick)]) {
        [self.delegate DDCloseBarLabelItemClick];
    }
    
}

/**
 右item click
 */
- (void)rightBtnClick{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DDRightBarButtonItem)]) {
        [self.delegate DDRightBarButtonItem];
    }
}
/**
 accessionLabel click
 */
- (void)rightAccessionClick {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DDRightBarLabelItemClick)]) {
        [self.delegate DDRightBarLabelItemClick];
    }
    
}

/**
 headViewClick
 */

- (void)headViewClick:(UITapGestureRecognizer *)tap{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DDHeadViewClick)]) {
        [self.delegate DDHeadViewClick];
    }
}

- (void)titleViewClick{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DDTitleViewClick)]) {
        [self.delegate DDTitleViewClick];
    }
}

////set
- (void)setLeftBarButtonImage:(NSString *)leftBarButtonImage{
    _leftBarButtonImage = leftBarButtonImage;
    self.leftBarButtonItem.hidden = NO;
    [self.leftBarButtonItem setImage:[UIImage imageNamed:leftBarButtonImage] forState:UIControlStateNormal];
    
}



- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.hidden = NO;
    self.titleLb.text = title;
    switch (self.navType) {
        case DD_ColumnType:
        {
            CGFloat titleW = [self adjustTitleWidthWithString:title];
            self.columnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -titleW - 20);
        }
            break;
            
        default:
            break;
    }
}

- (void)setHeadImage:(UIImage *)headImage{

    _headImage = headImage;
    self.titleHeadView.image = headImage;
}


- (void)setTitlesArray:(NSArray<NSString *> *)titlesArray{
    if ([_titlesArray isEqualToArray:titlesArray]) {
        return;
    }
    _titlesArray = titlesArray;
    
    switch (self.navType) {
        case DD_TitleHorizontalType:
        {
            self.titlesView.titleArray = titlesArray;
        }
            break;
            
        default:
            break;
    }
}

- (void)setTitleDefaultSelect:(NSInteger)titleDefaultSelect{
    _titleDefaultSelect = titleDefaultSelect;
    self.titlesView.selectItemAtIndex = _titleDefaultSelect;
}

- (NSInteger)getTitleDefaultSelect:(NSInteger)titleDefaultSelect{
    return self.titlesView.selectItemAtIndex ?: 0;
}


- (CGFloat)adjustTitleWidthWithString:(NSString *)title{
    CGSize resultSize = CGSizeZero;
    if (title <= 0) {
        self.columnBtn.hidden = YES;
        return 0;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    resultSize = [title boundingRectWithSize:CGSizeMake(floor(self.columnBtn.frame.size.width), floor(self.columnBtn.frame.size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: self.titleLb.font,
                                              NSParagraphStyleAttributeName: style}
                                    context:nil].size;
    
    return resultSize.width;
}

- (void)setRightBarButtonImage:(NSString *)rightBarButtonImage{
    _rightBarButtonImage = rightBarButtonImage;
    self.rightBarButtonItem.hidden = NO;
    [self.rightBarButtonItem setImage:[UIImage imageNamed:rightBarButtonImage] forState:UIControlStateNormal];
}

- (void)setRightItemText:(NSString *)rightItemText{
    _rightItemText = rightItemText;
    self.rightBarLabelItem.hidden = NO;
    switch (self.navType) {
        case DD_AccessMessageType:
            self.rightBarLabelItem.text = _rightItemText;
            [self.rightBarLabelItem layoutIfNeeded];
            break;
        default:
            break;
    }
}

- (void)setMessageNum:(NSString *)messageNum{
    if (_messageNum == messageNum) {
        return;
    }
    _messageNum = messageNum;
    self.messageLb.hidden = NO;
    self.messageLb.adjustsFontSizeToFitWidth = YES;
    self.rightBarButtonItem.hidden = NO;
    NSString *mesageCount = [messageNum mutableCopy];
    int count = [mesageCount intValue];
    self.messageLb.hidden = count <= 0;
//    self.messageLb.text = count < 100 ? @(count).stringValue : @"...";
}

- (void)setColumnArray:(NSArray<NSString *> *)columnArray{
    if ([_columnArray isEqualToArray:columnArray]) {
        return;
    }
    _columnArray = columnArray;
    self.columnView.titleArray = _columnArray;
}



////////////////////////////
- (void)setTitleViewWithImage:(NSString *__nullable)image title:(NSString *__nullable)title titleColor:(UIColor *__nullable)color{
    UIColor *tempColor = [UIColor whiteColor];
    if (color) {
        tempColor = color;
    }
    if (image == nil && title == nil) {
        self.titleView.hidden = YES;
        return;
    }
    self.navType = DD_TitleView;
    if (image) {
        [self.titleView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [self.titleView setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (title) {
        [self.titleView setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self.titleView setTitleColor:tempColor forState:UIControlStateNormal];
        [self.titleView setTitle:title forState:UIControlStateNormal];
    }
    
}

/////////////////////////

////lazy

- (UIImageView *)bangImageV{
    
    if (!_bangImageV) {
        _bangImageV = [UIImageView new];
        if (APP_ISIPHONE_X) {
            _bangImageV.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 44);
            [self addSubview:_bangImageV];
        }
    }
    return _bangImageV;
}

- (UIImageView *)backgroundImageV{

    if (!_backgroundImageV) {
        _backgroundImageV = [[UIImageView alloc]initWithFrame:self.frame];
        _backgroundImageV.center = self.center;
    }
    return _backgroundImageV;
    
}

- (UIButton *)leftBarButtonItem{
    if (!_leftBarButtonItem) {
        _leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(10, APP_NAV_HEIGHT - 32 - 6, 32, 32)];
        [_leftBarButtonItem setImage:[UIImage imageNamed:@"icon_nav_back_white"] forState:UIControlStateNormal];
        _leftBarButtonItem.hidden = YES;
        [_leftBarButtonItem addTarget:self action:@selector(popOrDisViewcontroller) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBarButtonItem];
    }
    return _leftBarButtonItem;
}

- (UILabel *)leftCloseLb{

    if (!_leftCloseLb) {
        _leftCloseLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        _leftCloseLb.textAlignment = 1;
        _leftCloseLb.text = @"关闭";
        _leftCloseLb.font = APP_FONT(16);
        _leftCloseLb.userInteractionEnabled = YES;
        [_leftCloseLb addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)]];
        _leftCloseLb.hidden = YES;
        _leftCloseLb.center = CGPointMake(60, APP_NAV_HEIGHT - 16 - 6);
        [self addSubview:_leftCloseLb];
    }
    return _leftCloseLb;
    
}


- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SELF_W - 160, SELF_H/3)];
        _titleLb.textAlignment = 1;
        _titleLb.font = APP_FONT(18);
        _titleLb.hidden = YES;
        _titleLb.center = CGPointMake(self.center.x, APP_NAV_HEIGHT - 16 - 6);
        [self addSubview:_titleLb];
    }
    return _titleLb;
}

- (UIButton *)titleView{

    if (!_titleView) {
        _titleView = [UIButton new];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleView.hidden = YES;
        [_titleView addTarget:self action:@selector(titleViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
            make.width.equalTo(@(SELF_W - 80));
        }];
    }
    return _titleView;
}


- (DDBaseNavHorizontalView *)titlesView{

    if (!_titlesView) {
        _titlesView = [DDBaseNavHorizontalView new];
        _titlesView.center = CGPointMake(self.center.x, APP_NAV_HEIGHT - 16 - 6);
        _titlesView.backgroundColor = [UIColor clearColor];
        _titlesView.hidden = YES;
        __weak DDBaseNavigationView * weakself = self;
        __weak DDBaseNavHorizontalView *weaktitleHeadView = _titlesView;
        _titlesView.DDNavHorizotalViewBlock = ^(NSInteger index) {
            if (weakself.DDNavHorizontalBlock) {
                weakself.titleDefaultSelect = weaktitleHeadView.selectItemAtIndex;
                weakself.DDNavHorizontalBlock(index);
            }
        };
        [self addSubview:_titlesView];
    }
    return _titlesView;
}

- (UIImageView *)titleHeadView{

    if (!_titleHeadView) {
        _titleHeadView = [UIImageView new];
        _titleHeadView.backgroundColor = [UIColor clearColor];
        _titleHeadView.hidden = NO;
        _titleHeadView.userInteractionEnabled = YES;
        _titleHeadView.frame = CGRectMake(0, 0, 50, 50);
        _titleHeadView.center = CGPointMake(26, 26);
        _titleHeadView.clipsToBounds = YES;
        [_titleHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick:)]];
        _titleHeadView.layer.cornerRadius = 25;
        [self.titleBgHeadView addSubview:_titleHeadView];
    }
    return _titleHeadView;
}

- (UIImageView *)titleBgHeadView{
    
    if (!_titleBgHeadView) {
        _titleBgHeadView = [UIImageView new];
        _titleBgHeadView.backgroundColor = [UIColor clearColor];
        _titleBgHeadView.userInteractionEnabled = YES;
        _titleBgHeadView.hidden = YES;
        _titleBgHeadView.image = [UIImage imageNamed:@"icon_my_touxiang2_defoult"];
        _titleBgHeadView.userInteractionEnabled = YES;
        _titleBgHeadView.frame = CGRectMake(0, 0, 52, 52);
        _titleBgHeadView.center = CGPointMake(self.center.x, self.frame.size.height + 18);
        _titleBgHeadView.clipsToBounds = YES;
        [_titleBgHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick:)]];
        _titleBgHeadView.layer.cornerRadius = 26;
        [self addSubview:_titleBgHeadView];
    }
    return _titleBgHeadView;
}


- (UIButton *)columnBtn{
    
    if (!_columnBtn) {
        _columnBtn = [[UIButton alloc]initWithFrame:self.titleLb.frame];
        _columnBtn.hidden = YES;
        [_columnBtn setImage:[UIImage imageNamed:@"icon_arrow1_up"] forState:UIControlStateNormal];
        _columnBtn.center = CGPointMake(self.center.x, APP_NAV_HEIGHT - 16 - 6);
        [_columnBtn addTarget:self action:@selector(transformBtnImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_columnBtn];
    }
    return _columnBtn;
}

- (void)transformBtnImage:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.isSelected) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.columnView.alpha = 1.0;
            self.maskV.hidden = NO;
            self.maskV.alpha = 1.0;
            self.columnView.frame = CGRectMake(APP_SCREEN_WIDTH/2, APP_NAV_HEIGHT, 85, 150/4.0 * self.columnArray.count);
            [self layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.columnView.frame = CGRectMake(APP_SCREEN_WIDTH/2, APP_NAV_HEIGHT, 85, 0);
            self.columnView.alpha = 0.7;
            self.maskV.hidden = YES;
            self.maskV.alpha = 0.0;
            btn.imageView.transform = CGAffineTransformMakeRotation(0);
            [self layoutIfNeeded];
        }];
    }
}

- (void)maskVtap:(UITapGestureRecognizer *)tap{

}

- (UIButton *)rightBarButtonItem{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(SELF_W - 10 - 35, APP_NAV_HEIGHT - 32 - 6, 32, 32)];
        _rightBarButtonItem.hidden = YES;
        [_rightBarButtonItem addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBarButtonItem];
    }
    return _rightBarButtonItem;
}



- (UILabel *)rightBarLabelItem{
    if (!_rightBarLabelItem) {
        _rightBarLabelItem = [[UILabel alloc]initWithFrame:CGRectMake(SELF_W - 10 - 80, APP_NAV_HEIGHT - 15 - 6, 80, 15)];
        _rightBarLabelItem.textColor = DS_COLOR_HEXCOLOR(@"414042");
        _rightBarLabelItem.font = APP_FONT(14);
        _rightBarLabelItem.textAlignment = 2;
        _rightBarLabelItem.hidden = YES;
        _rightBarLabelItem.userInteractionEnabled = YES;
        [_rightBarLabelItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightAccessionClick)]];
        [self addSubview:_rightBarLabelItem];
    }
    return _rightBarLabelItem;
}



- (UILabel *)messageLb{

    if (!_messageLb) {
        _messageLb = [[UILabel alloc]initWithFrame:CGRectMake(25, 3, 10, 10)];
        _messageLb.layer.cornerRadius = 5;
        _messageLb.clipsToBounds = YES;
        _messageLb.textAlignment = 1;
        _messageLb.hidden = YES;
        _messageLb.backgroundColor = [UIColor redColor];
        [self.rightBarButtonItem addSubview:_messageLb];
    }
    return _messageLb;
}



- (UIView *)maskV{

    if (!_maskV) {
        _maskV = [[UIView alloc]initWithFrame:CGRectMake(0, SELF_H, SELF_W, DS_APP_SIZE_HEIGHT - SELF_H)];
        _maskV.backgroundColor = [UIColor clearColor];//[[UIColor blackColor] colorWithAlphaComponent:0.7];
        _maskV.alpha = 0;
        [_maskV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskVtap:)]];
        _maskV.userInteractionEnabled = YES;
        _maskV.hidden = YES;
        [self addSubview:_maskV];
        [self sendSubviewToBack:_maskV];
    }
    return _maskV;
}


- (DDBaseNavColumnView *)columnView{

    if (!_columnView) {
        _columnView = [[DDBaseNavColumnView alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH/2, APP_NAV_HEIGHT, 85, 150/4.0 * self.columnArray.count)];
        _columnView.backgroundColor = [UIColor clearColor];
        _columnView.hidden = YES;
        _columnView.alpha = 0.0;
        __weak DDBaseNavigationView * weakself = self;
        _columnView.DDNavColumnViewBlock = ^(NSInteger index) {
            if (weakself.columnArray.count) {
                weakself.title = weakself.columnArray[index];
            }
            if (weakself.DDNavColumnBlock) {
                [weakself transformBtnImage:weakself.columnBtn];
                weakself.DDNavColumnBlock(index);
            }
        };
        [self addSubview:_columnView];
    }
    
    return _columnView;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint btnP = [self convertPoint:point toView:self.columnView];
    if (self.leftBarButtonItem.isHidden == NO && self.leftBarButtonItem.alpha > 0 && point.x < CGRectGetMaxX(self.leftBarButtonItem.frame) && point.y < APP_NAV_HEIGHT) {
        return self.leftBarButtonItem;
    }
    else if (self.leftCloseLb.isHidden == NO && self.leftCloseLb.alpha > 0 && (point.x < CGRectGetMaxX(self.leftCloseLb.frame) && point.x > CGRectGetMaxX(self.leftBarButtonItem.frame) && point.y < APP_NAV_HEIGHT)){
        return self.leftCloseLb;
    }
    else if (self.columnBtn.isHidden == NO && self.columnBtn.alpha > 0 && (point.x < CGRectGetMaxX(self.columnBtn.frame) && point.x > CGRectGetMinX(self.columnBtn.frame) && point.y < APP_NAV_HEIGHT)){
        return self.columnBtn;
    }
    else if (self.titleBgHeadView.isHidden == NO && self.titleBgHeadView.alpha > 0 && (point.x < CGRectGetMaxX(self.titleBgHeadView.frame) && point.x > CGRectGetMinX(self.titleBgHeadView.frame) )&& (point.y < CGRectGetMaxY(self.titleBgHeadView.frame) && point.y > CGRectGetMinY(self.titleBgHeadView.frame) )){
        return self.titleBgHeadView;
    }
    
    else if (self.columnView.isHidden == NO && self.columnView.alpha > 0 && [self.columnView pointInside:btnP withEvent:event]){
        for (UIView *view in self.columnView.subviews) {
            if (view) {
                    return view;
                }
            }
        return self.columnView;
    }
    else if (self.rightBarButtonItem.isHidden == NO && self.rightBarButtonItem.alpha > 0 &&  point.x > CGRectGetMinX(self.rightBarButtonItem.frame) && point.y < APP_NAV_HEIGHT){
        return self.rightBarButtonItem;
    }
    
    else if (self.rightBarLabelItem.isHidden == NO && self.rightBarLabelItem.alpha > 0 &&  point.x > CGRectGetMinX(self.rightBarLabelItem.frame) && point.y < APP_NAV_HEIGHT){
        return self.rightBarLabelItem;
    }
    
    else if (self.titleView.isHidden == NO ){
        if ( (point.x < CGRectGetMaxX(self.titleView.frame) + 20 && point.x > CGRectGetMinX(self.titleView.frame) - 20)&& (point.y < CGRectGetMaxY(self.titleView.frame) + 10 && point.y > CGRectGetMinY(self.titleView.frame) - 10)) {
            return self.titleView;
        }
        return nil;
    }
    else if (point.y > APP_NAV_HEIGHT && self.maskV.isHidden == NO && self.maskV.alpha > 0){
        return self.maskV;
    }
    return [super hitTest:point withEvent:event];
}
@end









