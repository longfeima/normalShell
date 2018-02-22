//
//  UIButton+DDSC.h
//  DDSC
//
//  Created by dxw on 14/11/27.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DDSC)

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

/**时间间隔*/
@property (nonatomic, assign) NSTimeInterval DD_acceptEventInterval;

/**
 没有网络的时候返回NO/YES
 */
@property (nonatomic, assign) BOOL isHaveNetCanUserful;

@end
