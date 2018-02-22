//
//  sAlertView.m
//  sTips
//
//  Created by Seven on 2017/7/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "sAlertView.h"
#import <Masonry/Masonry.h>

#import <objc/runtime.h>


#define DS_BASEBTN_TAG              12312334
#define DS_BACKGROUND_EDGE          30

@interface sAlertView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *messageLb;
@property (nonatomic, strong) UILabel *cancelLb;
@property (nonatomic, strong) UILabel *confirmLb;


@end
@implementation sAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self creatUI];
    }
    return self;
}

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Cancel:(NSString *)cancel{

    
    self.titleLb.text = title;
    self.messageLb.text = message;
    self.cancelLb.text = cancel;
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.backgroundView).offset(10);
    }];
    
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(20);
        make.left.equalTo(self.backgroundView).offset(10);
        make.right.equalTo(self.backgroundView).offset(-10);
    }];
    
    
    [self.cancelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundView).offset(-10);
        make.left.equalTo(self.backgroundView).offset(10);
        make.right.equalTo(self.backgroundView).offset(-10);
    }];
    
    UILabel *lineLb = [UILabel new];
    [self.backgroundView addSubview:lineLb];
    lineLb.backgroundColor = [UIColor blackColor];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroundView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.cancelLb.mas_top).offset(- 5);
    }];
    
    
}


- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Cancel:(NSString *)cancel Confirm:(NSString *)confirm{

    [self creatUI];
    self.titleLb.text = title;
    self.messageLb.text = message;
    self.cancelLb.text = cancel;
    self.confirmLb.text = confirm;
    
    CGFloat titleHight = title.length > 0 ? 20 : 0.01;
    CGFloat messageLbHight = [self adjustContentHightWithString:message];// * 1.05;
    CGFloat backViewHight = MAX(200, MIN(messageLbHight + 10 + titleHight + 10 + 10 + 0.5 + 5 + 30 + 10, [UIScreen mainScreen].bounds.size.height - 64 - 49));
    CGFloat correctMessageLbHight = backViewHight - ( 10 + titleHight + 10 + 10 + 0.5 + 30 + 10 + 5);
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(DS_BACKGROUND_EDGE);
        make.right.equalTo(self).offset(-DS_BACKGROUND_EDGE);
        make.height.equalTo(@(backViewHight));
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView).offset(10);
        make.centerX.equalTo(self.backgroundView);
        make.height.equalTo(@(titleHight));
    }];
    
    
    [self.cancelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundView).offset(-10);
        make.left.equalTo(self.backgroundView);
        make.height.equalTo(@30);
    }];
    [self.confirmLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.cancelLb);
        make.width.height.equalTo(self.cancelLb);
        make.left.equalTo(self.cancelLb.mas_right);
        make.right.equalTo(self.backgroundView);
    }];
    
    UILabel *lineLb = [UILabel new];
    [self.backgroundView addSubview:lineLb];
    lineLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroundView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.cancelLb.mas_top).offset(- 5);
    }];
    UILabel *vLine = [UILabel new];
    [self.backgroundView addSubview:vLine];
    vLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.centerX.equalTo(self.backgroundView);
        make.top.bottom.equalTo(self.cancelLb);
    }];
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        make.left.equalTo(self.backgroundView).offset(10);
        make.height.equalTo(@(correctMessageLbHight));
        make.right.equalTo(self.backgroundView).offset(-10);
        make.bottom.equalTo(lineLb.mas_top).offset(-10);
    }];
    
}



- (CGFloat)adjustContentHightWithString:(NSString *)message{
    CGSize resultSize = CGSizeZero;
    if (message <= 0) {
//        self.columnBtn.hidden = YES;
        return 0;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    resultSize = [message boundingRectWithSize:CGSizeMake(floor([UIScreen mainScreen].bounds.size.width - DS_BACKGROUND_EDGE * 2 - 20), floor(MAXFLOAT))
                                     options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                  attributes:@{NSFontAttributeName: self.messageLb.font,
                                               NSParagraphStyleAttributeName: style}
                                     context:nil].size;
    
    return resultSize.height;
}

- (void)itemClick:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag - DS_BASEBTN_TAG;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sAlertViewSelectIndex:)]) {
        [self.delegate sAlertViewSelectIndex:tag?:-1];
    }
    
}


- (void)creatUI{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
//    self.backgroundView.frame = CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height);
//    [self addSubview:self.backgroundView];
    [self backgroundView];
    [self titleLb];
    [self messageLb];
    [self cancelLb];
    [self confirmLb];
}
//lazy========
- (UIView *)backgroundView{
    
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.userInteractionEnabled = YES;
//        _backgroundView.frame = CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height);
        _backgroundView.layer.cornerRadius = 8.0;
        _backgroundView.clipsToBounds = YES;
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hello)]];
        _backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UILabel *)titleLb{

    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont boldSystemFontOfSize:19];
        _titleLb.textAlignment = 1;
        [self.backgroundView addSubview:_titleLb];
    }
    return _titleLb;
}

- (UILabel *)messageLb{

    if (!_messageLb) {
        _messageLb = [UILabel new];
        _messageLb.font = [UIFont systemFontOfSize:14];
        _messageLb.numberOfLines = 0;
        [self.backgroundView addSubview:_messageLb];
    }
    return _messageLb;
}

- (UILabel *)cancelLb{

    if (!_cancelLb) {
        _cancelLb = [UILabel new];
        _cancelLb.textAlignment = 1;
        _cancelLb.userInteractionEnabled = YES;
        _cancelLb.tag = DS_BASEBTN_TAG;
        _cancelLb.font = [UIFont systemFontOfSize:17];
        [_cancelLb addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
        [self.backgroundView addSubview:_cancelLb];
    }
    return _cancelLb;
}

- (UILabel *)confirmLb{

    if (!_confirmLb) {
        _confirmLb = [UILabel new];
        _confirmLb.textAlignment = 1;
        _confirmLb.userInteractionEnabled = YES;
        _confirmLb.tag = DS_BASEBTN_TAG + 1;
        [_confirmLb addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
        _confirmLb.font = [UIFont systemFontOfSize:17];
        [self.backgroundView addSubview:_confirmLb];
    }
    return _confirmLb;
}



- (void)hello{
    
    //    return;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    //    for (UIView *view in self.subviews) {
    //        if (view && [view isKindOfClass:[UILabel class]]) {
    //            return view;
    //        }
    //    }
    //
    return [super hitTest:point withEvent:event];
}


@end
