//
//  DsBaseViewController.h
//  WBuild
//
//  Created by Seven on 2017/7/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DsBaseViewController : UIViewController
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) BOOL needShowColorLayer;

- (void)back:(id)sender;
- (void)setupBackItem;
- (void)setupCloseItem;
- (void)setupSpecialBackItem;
- (void)setupSpecialCloseItem;
@end
