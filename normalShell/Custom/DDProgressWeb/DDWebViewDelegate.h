//
//  TBJWebViewDelegate.h
//  TBJPro
//
//  Created by dongxiaowei on 14-9-22.
//  Copyright (c) 2014年 TBJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDWebViewDelegate;

@protocol DDWebViewProgressDelegate <NSObject>

- (void)webViewDelegate:(DDWebViewDelegate *)webViewDelegate updateProgress:(float)progress;

@end

typedef void (^DDWebViewProgressBlock)(float progress);

@interface DDWebViewDelegate : NSObject<UIWebViewDelegate>

@property (nonatomic, weak) id<DDWebViewProgressDelegate> progressDelegate;
@property (nonatomic, weak) id<UIWebViewDelegate> webViewProxyDelegate;
@property (nonatomic, copy) DDWebViewProgressBlock progressBlock;

@property (nonatomic, assign, readonly) float progress;

@end


