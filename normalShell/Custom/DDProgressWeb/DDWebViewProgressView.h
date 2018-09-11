//
//  TBJWebViewProgressView.h
//  TBJPro
//
//  Created by dongxiaowei on 14-9-22.
//  Copyright (c) 2014年 TBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDWebViewProgressView : UIView

@property (nonatomic, assign) float progress;

@property (nonatomic, strong) UIView *progressBarView;

@property (nonatomic, assign) NSTimeInterval barAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeOutDelay;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
