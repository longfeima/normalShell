//
//  sShowTisWindow.m
//  sTips
//妈的，现在情况好像是不能同时显示啊
//  Created by Seven on 2017/7/21.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "sShowTisWindow.h"
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <Foundation/Foundation.h>
#import "sTipsView.h"
#import "sShareView.h"
#import "sSheetView.h"
#import "sAlertView.h"
#import "sScreenView.h"
#import "sDateView.h"






@interface sShowTisWindow ()

@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UIWindow *tipsWindow;

@property (nonatomic, strong) sTipsView *tipsV;
@property (nonatomic, strong) sShareView *shareView;
@property (nonatomic, strong) sSheetView *sheetView;
@property (nonatomic, strong) sAlertView *alertView;
@property (nonatomic, strong) sScreenView *screenView;

@property (nonatomic, strong) sDateView *dateView;




@end

@interface sShowTisWindow ()

{
    UITapGestureRecognizer *_tap;
}

@end


@implementation sShowTisWindow

////////////////////////////////////////////////////////////
+ (instancetype)shareTipsWindow{
    
    static sShowTisWindow *_shareTipsWindow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareTipsWindow = [[sShowTisWindow alloc]init];
    });
    return _shareTipsWindow;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        if ([self.dataSource respondsToSelector:@selector(showTipsWithCustomView:)]) {
            self.isClickHide = YES;
            
        }
        
        
    }
    return self;
}
//- (void)setDelegate:(id<sTipsWindowProtocol>)delegate{

//    _delegate = delegate;
//    self.shareView.delegate = delegate;
//    self.sheetView.delegate = delegate;
//}

- (void)setType:(DsTipsWindowType)type{
    
    switch (type) {
        case tipsWindowAllScreen:
        {
            self.tipsWindow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
            break;
        case tipsWindowNavBar:
        {
            self.tipsWindow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, DS_APP_NAV_HEIGHT);
        }
            break;
        case tipsWindowExpectNavBar:
        {
            self.tipsWindow.frame = CGRectMake(0, DS_APP_NAV_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - DS_APP_NAV_HEIGHT);
        }
            break;
        case tipsWindowExpectTabBar:
        {
            self.tipsWindow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - DS_APP_TAB_HEIGHT);
        }
            break;
        case tipsWindowExpectBar:
        {
            self.tipsWindow.frame = CGRectMake(0, DS_APP_NAV_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - DS_APP_NAV_HEIGHT - DS_APP_TAB_HEIGHT);
        }
            break;
        default:
            break;
    }
}


- (void)setIsClickHide:(BOOL)isClickHide{
    
    if (isClickHide) {
        if (_tap) {
            [self.tipsWindow removeGestureRecognizer:_tap];
        }
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideWindowSubviews)];
        
        [self.tipsWindow addGestureRecognizer:_tap];
    }
}


- (void)hideWindowSubviews{
    
    if (_sheetView) {
        [self hideSheetView];
    }
    if (_shareView) {
        [self hideShareView];
    }
    if (_alertView) {
        [self hideAlertView];
    }
    if (_screenView) {
        [self hideScreenView];
    }
    if (_tipsV) {
        [self hideTipsView];
    }
    if (_dateView) {
        [self hideDateView];
    }
    
    
}



#pragma mark ------ tips relation
- (void)showTips{
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowAllScreen;
    [self showBarWindow];
    
    self.tipsV.tipLb.text = @"这是一个测试tips";
    
    [self.tipsWindow addSubview:self.tipsV];
    [self performSelector:@selector(showTip) withObject:nil afterDelay:1];
    
}
- (void)showTip{
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
        self.tipsV.frame = CGRectMake(0, 0, self.tipsWindow.frame.size.width, DS_APP_NAV_HEIGHT);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tipsV.frame = CGRectMake(0, -DS_APP_NAV_HEIGHT, self.tipsWindow.frame.size.width, DS_APP_NAV_HEIGHT);
            self.tipsWindow.alpha = 0;
        } completion:^(BOOL finished) {
            [self.tipsV removeFromSuperview];
            [self removalBarWindow];
        }];
        
    }];
}

- (void)showTipsWithString:(NSString *)tips Delegate:(id)delegate{
    
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowNavBar;
    [self showBarWindow];
    
    self.tipsV.tipLb.text = tips;
    self.tipsV.delegate = delegate;
    
    [self.tipsWindow addSubview:self.tipsV];
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
        self.tipsV.frame = CGRectMake(0, 0, self.tipsWindow.frame.size.width, DS_APP_NAV_HEIGHT);
    }];
    
}

- (void)showTipsWithString:(NSString *)tips stopDuration:(NSTimeInterval)time{
//    self.tipsWindow.backgroundColor = [UIColor clearColor];
    [self showTipsWithString:tips Delegate:nil];
    self.tipsV.tipImV.image = [UIImage imageNamed:@"icon_notice"];
    [self performSelector:@selector(hideTipsView) withObject:nil afterDelay:time];
}
- (void)showTipsWithString:(NSString *)tips type:(Ds_TipsType)type stopDuration:(NSTimeInterval)time{
//    self.tipsWindow.backgroundColor = [UIColor clearColor];
    [self showTipsWithString:tips Delegate:nil];
    switch (type) {
        case Ds_Tips_Error:
        {
            self.tipsV.tipImV.image = [UIImage imageNamed:@"icon_notice"];
            
            self.tipsV.backgroundColor = DS_COLOR_HEXCOLOR(@"FF7239");
        }
            break;
        case Ds_Tips_Success:
        {
            self.tipsV.tipImV.image = [UIImage imageNamed:@"icon_notice2"];
            self.tipsV.backgroundColor = DS_COLOR_HEXCOLOR(@"39ECD9");
        }
            break;
        default:
            break;
    }
    
    [self performSelector:@selector(hideTipsView) withObject:nil afterDelay:time];
}

- (void)hideTipsView{
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsV.frame = CGRectMake(0, -DS_APP_NAV_HEIGHT, self.tipsWindow.frame.size.width, DS_APP_NAV_HEIGHT);
        self.tipsWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tipsV removeFromSuperview];
        self.tipsV = nil;
        [self removalBarWindow];
    }];
}


#pragma mark ---------shareView relation
- (void)showShareViewWithDelegate:(id)delegate{
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowExpectNavBar;
    [self showBarWindow];
    [self.tipsWindow addSubview:self.shareView];
    
    self.shareView.delegate = delegate;
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
        self.shareView.frame = CGRectMake(0, self.tipsWindow.frame.size.height - 250, self.tipsWindow.frame.size.width, 250);
    } completion:^(BOOL finished) {
        //        [self performSelector:@selector(hideShareView) withObject:nil afterDelay:3];
    }];
    
    
}
- (void)showShareViewWithNormalLogs:(NSArray <NSString *>*)norLogs PressLogs:(NSArray <NSString *>*)preLogs Titles:(NSArray <NSString *>*)titles Delegate:(id)delegate{
    
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowExpectNavBar;
    [self showBarWindow];
    NSInteger maxCount = MAX(MAX(norLogs.count, preLogs.count), titles.count);
    NSInteger rows = maxCount/DS_SHARE_ITEMS_PREROW + ((maxCount % DS_SHARE_ITEMS_PREROW) > 0 ? 1 : 0);
    CGFloat shareViewHight = DS_SHARE_CANCELHIGHT + MAX(rows, 2) * DS_SHARE_ITEMHIGHT + 20;//20为上下高度
    self.shareView = [[sShareView alloc]initWithFrame: CGRectMake(0, self.tipsWindow.frame.size.height, self.tipsWindow.frame.size.width, shareViewHight)];
    self.shareView.delegate = delegate;
    [self.tipsWindow addSubview:self.shareView];
    [self.shareView confWithArray:@[[norLogs mutableCopy], [preLogs mutableCopy], [titles mutableCopy]]];
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
        self.shareView.frame = CGRectMake(0, self.tipsWindow.frame.size.height - shareViewHight, self.tipsWindow.frame.size.width, shareViewHight);
    } completion:^(BOOL finished) {
    }];
    
    
}



- (void)hideShareView{
    [self.tipsWindow.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showShareView) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 0;
        self.shareView.frame = CGRectMake(0, self.tipsWindow.frame.size.height, self.tipsWindow.frame.size.width, 250);
    } completion:^(BOOL finished) {
        [self.shareView removeFromSuperview];
        self.shareView = nil;
        [self removalBarWindow];
    }];
}


#pragma mark ---------sheet relation
- (void)showSheetWithObject:(NSArray <NSString *>*)items Title:(NSString *)title Delegate:(id)delegate Type:(Ds_SheetType)type{
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowAllScreen;
    [self showBarWindow];
    [self.tipsWindow addSubview:self.sheetView];
    [self.sheetView showSheetWithObject:items Title:title Type:type];
    self.sheetView.delegate = delegate;
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
        self.sheetView.frame = CGRectMake(0, self.tipsWindow.frame.size.height - 250, self.tipsWindow.frame.size.width, 250);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideSheetView{
    
    [self.tipsWindow.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showSheetWithObject:Title:Delegate:Type:) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 0;
        self.sheetView.frame = CGRectMake(0, self.tipsWindow.frame.size.height, self.tipsWindow.frame.size.width, 250);
    } completion:^(BOOL finished) {
        [self.sheetView removeFromSuperview];
        self.sheetView = nil;
        [self removalBarWindow];
    }];
    
    
}


#pragma mark -----alert release

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Cancel:(NSString *)cancel Delegate:(id)delegate{
    
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowAllScreen;
    [self showBarWindow];
    [self.tipsWindow addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.tipsWindow);
    }];
    self.alertView.delegate = delegate;
    [self.alertView showAlertWithTitle:title Message:message Cancel:cancel];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
    }];
    
    
}
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Cancel:(NSString *)cancel Confirm:(NSString *)confirm Delegate:(id)delegate{
    
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowAllScreen;
    [self showBarWindow];
    [self.tipsWindow addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.tipsWindow);
        //        make.width.height.equalTo(@200);
        make.left.right.equalTo(self.tipsWindow);
    }];
    [self.alertView showAlertWithTitle:title Message:message Cancel:cancel Confirm:confirm];
    self.alertView.delegate = delegate;
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
        self.tipsWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
    
}

- (void)hideAlertView{
    [self.tipsWindow.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showSheetWithObject:Title:Delegate:Type:) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.alertView removeFromSuperview];
        self.alertView = nil;
        [self removalBarWindow];
    }];
}

///////screenView
#pragma screenView

- (void)showScreenWithLocaliteUrl:(NSString *)localiteUrl Delegate:(id)delegate{
    self.screenView.delegate = delegate;
    [self showScreenView];
    [self.screenView showScreenWithLocaliteUrl:@""];
}

- (void)showScreenWithUrl:(NSURL *)imageUrl Delegate:(id)delegate{
    [self showScreenView];
    [self.tipsWindow addSubview:self.screenView];
    self.screenView.delegate = delegate;
    [self.screenView showScreenWithUrl:imageUrl];
}

- (void)showScreenView{
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowAllScreen;
    [self showBarWindow];
    [self screenView];
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.tipsWindow.alpha = 1;
    }];
    
}
- (void)hideScreenView{
    
    [self.tipsWindow.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showScreenWithUrl:) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showScreenWithLocaliteUrl:) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 0.0;
        //        self.screenView.center = self.tipsWindow.center;
        //        self.screenView.bounds = CGRectMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self.screenView removeFromSuperview];
        self.screenView = nil;
        [self removalBarWindow];
    }];
    
}


- (void)showDateViewWithType:(Ds_DateType)type Delegate:(id)delegate{
    
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowExpectNavBar;
    [self showBarWindow];
    [self.tipsWindow addSubview:self.dateView];
    [self.dateView showDateViewWithType:type];
    self.dateView.delegate = delegate;
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
        self.tipsWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.dateView.frame = CGRectMake(0, self.tipsWindow.frame.size.height - 250, self.tipsWindow.frame.size.width, 250);
    } completion:^(BOOL finished) {
        //        [self performSelector:@selector(hideShareView) withObject:nil afterDelay:3];
    }];
    
}

- (void)showDateViewWithType:(Ds_DateType)type DateString:(NSString *)date Formatter:(NSString *)formatter Delegate:(id)delegate{
    
    [self.tipsWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.type = tipsWindowExpectNavBar;
    [self showBarWindow];
    [self.tipsWindow addSubview:self.dateView];
    [self.dateView showDateViewWithType:type DateString:date Formatter:formatter];
    self.dateView.delegate = delegate;
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 1;
        self.tipsWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.dateView.frame = CGRectMake(0, self.tipsWindow.frame.size.height - 250, self.tipsWindow.frame.size.width, 250);
    } completion:^(BOOL finished) {
        //        [self performSelector:@selector(hideShareView) withObject:nil afterDelay:3];
    }];
}

- (void)hideDateView{
    
    [self.tipsWindow.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showDateViewWithType:) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsWindow.alpha = 0.0;
        self.dateView.frame = CGRectMake(0, self.tipsWindow.frame.size.height, self.tipsWindow.frame.size.width, 250);
    } completion:^(BOOL finished) {
        [self.dateView removeFromSuperview];
        self.dateView = nil;
        [self removalBarWindow];
    }];
    
}









//custom
- (void)showBarWindow{
    [self.keyWindow resignKeyWindow];
    self.tipsWindow.windowLevel = UIWindowLevelStatusBar;
    [self.tipsWindow makeKeyAndVisible];
    
}

- (void)removalBarWindow{
    [self.tipsWindow resignKeyWindow];
    [self.keyWindow makeKeyAndVisible];
}


- (sTipsView *)tipsV{
    
    if (!_tipsV) {
        _tipsV = [[sTipsView alloc] initWithFrame:CGRectMake(0, -DS_APP_NAV_HEIGHT, self.tipsWindow.frame.size.width, DS_APP_NAV_HEIGHT)];
        _tipsV.backgroundColor = DS_COLOR_HEXCOLOR(@"FF7239");
    }
    return _tipsV;
}

//- (sShareView *)shareView{
//
//    if (!_shareView) {
//        _shareView = [[sShareView alloc]initWithFrame:CGRectZero];
//    }
//    return _shareView;
//}

- (sSheetView *)sheetView{
    
    if (!_sheetView) {
        _sheetView = [[sSheetView alloc]initWithFrame:CGRectMake(0, self.tipsWindow.frame.size.height, self.tipsWindow.frame.size.width, 250)];
    }
    return _sheetView;
}

- (sAlertView *)alertView{
    
    if (!_alertView) {
        _alertView = [sAlertView new];
        
        
    }
    return _alertView;
}

- (sScreenView *)screenView{
    
    if (!_screenView) {
        _screenView = [[sScreenView alloc]initWithFrame:CGRectMake(0, 0, 220 * DS_SCREEN_SCALE, 220 * DS_SCREEN_SCALE * 1.2)];
        [self.tipsWindow addSubview:_screenView];
        _screenView.center = self.tipsWindow.center;
    }
    return _screenView;
}

- (sDateView *)dateView{
    
    if (!_dateView) {
        _dateView = [[sDateView alloc]initWithFrame:CGRectMake(0, self.tipsWindow.frame.size.height, self.tipsWindow.frame.size.width, 250)];
        [self.tipsWindow addSubview:_dateView];
    }
    return _dateView;
}





/////lazy

- (UIWindow *)keyWindow{
    
    if (!_keyWindow) {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    //    return _keyWindow;
    return [(AppDelegate *)[UIApplication sharedApplication].delegate window];//
}

- (UIWindow *)tipsWindow{
    
    if (!_tipsWindow) {
        _tipsWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _tipsWindow.clipsToBounds = YES;
        _tipsWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _tipsWindow.alpha = 0;
    }
    return _tipsWindow;
}


@end
