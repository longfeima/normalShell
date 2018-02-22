//
//  UIView+Frame.m
//  TBJPro
//
//  Created by dongxiaowei on 14-5-28.
//  Copyright (c) 2014年 TBJ. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (UIViewController *)dd_rootVC {
    return (UIViewController *)[self dd_traverseResponderChainForUIViewController];
}

- (id)dd_traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder dd_traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

- (CGPoint)dd_origin
{
    return self.frame.origin;
}

- (void)dd_setOrigin:(CGPoint)origin
{
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)dd_size
{
    return self.frame.size;
}

- (void)dd_setSize:(CGSize)size
{
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom
{
    self.frame = CGRectMake(self.x, bottom - self.width, self.width, self.height);
}

- (CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(right-self.width, self.y, self.width, self.height);
}

@end
