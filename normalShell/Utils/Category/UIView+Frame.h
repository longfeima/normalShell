//
//  UIView+Frame.h
//  TBJPro
//
//  Created by dongxiaowei on 14-5-28.
//  Copyright (c) 2014年 TBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (UIViewController *)dd_rootVC;
- (id)dd_traverseResponderChainForUIViewController;

- (CGPoint)dd_origin;
- (void)dd_setOrigin:(CGPoint)origin;

- (CGSize)dd_size;
- (void)dd_setSize:(CGSize)size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

@end
