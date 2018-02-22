//
//  sShowTisWindow.h
//  sTips
//
//  Created by Seven on 2017/7/21.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sTipsWindowDataSource.h"
#import "sTipsWindowProtocol.h"


@interface sShowTisWindow : NSObject

@property (nonatomic, assign) id<sTipsWindowDataSource>dataSource;

@property (nonatomic, assign) DsTipsWindowType type;

@property (nonatomic, assign) BOOL isClickHide;

+ (instancetype)shareTipsWindow;



- (void)hideWindowSubviews;

/**
 navTips
 */
- (void)showTips;
- (void)showTipsWithString:(NSString *)tips Delegate:(id)delegate;
- (void)showTipsWithString:(NSString *)tips stopDuration:(NSTimeInterval)time;
- (void)showTipsWithString:(NSString *)tips type:(Ds_TipsType)type stopDuration:(NSTimeInterval)time;
/**
 shareView
 */
- (void)showShareView;
- (void)showShareViewWithDelegate:(id)delegate;
- (void)showShareViewWithNormalLogs:(NSArray <NSString *>*)norLogs PressLogs:(NSArray <NSString *>*)preLogs Titles:(NSArray <NSString *>*)titles Delegate:(id)delegate;
/**
 sheetView
 
 @param items item
 @param title title
 */
//- (void)showSheetWithObject:(NSArray <NSString *>*)items title:(NSString *)title;
- (void)showSheetWithObject:(NSArray <NSString *>*)items Title:(NSString *)title Delegate:(id)delegate Type:(Ds_SheetType)type;


////alert
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Cancel:(NSString *)cancel Delegate:(id)delegate;
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Cancel:(NSString *)cancel Confirm:(NSString *)confirm Delegate:(id)delegate;



/**
 screen
 */

- (void)showScreenWithLocaliteUrl:(NSString *)localiteUrl Delegate:(id)delegate;

- (void)showScreenWithUrl:(NSURL *)imageUrl Delegate:(id)delegate;

/**dateView*/

- (void)showDateViewWithType:(Ds_DateType)type Delegate:(id)delegate;

- (void)showDateViewWithType:(Ds_DateType)type DateString:(NSString *)date Formatter:(NSString *)formatter Delegate:(id)delegate;

@end
