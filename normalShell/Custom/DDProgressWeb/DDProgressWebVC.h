//
//  DDProgressWebVC.h
//  DDSC
//
//  Created by dxw on 14/11/17.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//
#import "DsBaseViewController.h"
#import <UIKit/UIKit.h>

typedef void(^DDUserEvaluationBlock)(void);

@interface DDProgressWebVC : DsBaseViewController<UIWebViewDelegate>

@property (nonatomic, assign) BOOL isNeedRefresh;
/**用户风险评测*/
@property (nonatomic, copy) DDUserEvaluationBlock evaluationBlock;

- (instancetype)initWithURL:(NSString *)urlStr enabelProgress:(BOOL)enableProgress;

// 活动专用，需要判断终端数量限制是否满足
- (instancetype)initWithActivity:(NSDictionary *)detail enabelProgress:(BOOL)enableProgress;

@end
