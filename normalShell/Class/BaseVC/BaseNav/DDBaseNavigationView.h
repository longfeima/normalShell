//
//  DDBaseNavigationView.h
//  textNav
//
//  Created by CaydenK on 2017/4/7.
//  Copyright © 2017年 CaydenK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, DDNavigationType) {
    /**title*/
    DD_DefaultType = 0,
    DD_NormalType,                  /**leftBarButtonItem && title*/
    DD_CloseType,                  /**leftBarButtonItem && closeLb && title*/
    DD_ShareType,                   //leftBarButtonItem && title && rightBarButtonItem
    DD_AccessMessageType,           //leftBarButtonItem && title && rightBarLabelItem
    DD_ScaleTitleType,               //leftBarButtonItem && title && rightBarButtonItem
    DD_ColumnType,                   //leftBarButtonItem && title && ColumnBtn && ColumnTableview
    DD_TitleHorizontalType,          // herizontal title
    DD_CenterTitleView,                   //titleView && leftBarButtonItem
    DD_TitleView                   //titleView
};

@protocol DDNavigationViewDelegate <NSObject>
- (void)DDLeftBarButtonItemClick;
- (void)DDRightBarButtonItem;
- (void)DDRightBarLabelItemClick;
- (void)DDCloseBarLabelItemClick;
- (void)DDHeadViewClick;
- (void)DDTitleViewClick;
//- (void)DDColumnClick:(NSInteger)index;
@end

@interface DDBaseNavigationView : UIView
@property (nonatomic, strong) NSString *bangImageString;
@property (nonatomic, strong) NSString *bangImageURL;
@property (nonatomic, strong) UIButton *leftBarButtonItem;
@property (nonatomic, strong) UIImageView *backgroundImageV;
/**
 返回按钮
 */
@property (nonatomic, strong) NSString *leftBarButtonImage;
@property (nonatomic, strong) UILabel *leftCloseLb;


/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLb;
/**
 标题btn
 */
@property (nonatomic, strong) UIButton *titleView;
/**
 标题
 */
@property (nonatomic, strong) NSString *title;
/**
 DD_TitleHorizontalType 的时候设置
 */
@property (nonatomic, strong) NSArray<NSString *> *titlesArray;
@property (nonatomic, strong)  void(^DDNavHorizontalBlock)(NSInteger index);
/**
 默认选中title
 */
@property (nonatomic, assign) NSInteger titleDefaultSelect;
@property (nonatomic, strong) UIImage *headImage;
/**
 右按钮
 */
@property (nonatomic, strong) UIButton *rightBarButtonItem;

@property (nonatomic, strong) NSString *rightBarButtonImage;
/**
 右文案
 */
@property (nonatomic, strong) UILabel *rightBarLabelItem;
@property (nonatomic, strong) NSString *rightItemText;
/**
 消息tip
 */
@property (nonatomic, strong) NSString *messageNum;
/**
 设置type
 */
@property (nonatomic, assign) DDNavigationType navType;
- (instancetype) initWithFram:(CGRect)frame NavType:(DDNavigationType)type;
- (instancetype) initWithFram:(CGRect)frame NavType:(DDNavigationType)type AndDelegate:(id)delegate;
/**
 下拉栏 DDNavColumnBlock传递点击的第几个
 */

@property (nonatomic, strong) NSArray<NSString *> *columnArray;
@property (nonatomic, strong)  void(^DDNavColumnBlock)(NSInteger index);

@property (nonatomic, assign) id<DDNavigationViewDelegate>delegate;
@end

@interface DDBaseNavigationView ()

- (void)setTitleViewWithImage:(NSString *__nullable)image title:(NSString *__nullable)title titleColor:(UIColor *__nullable)color;

@end

