//
//  UITabBar+Extension.m
//  DDSC
//
//  Created by ai on 16/3/23.
//  Copyright © 2016年 ddsoucai. All rights reserved.
//

#import "UITabBar+Extension.h"

@implementation UITabBar (Extension)
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    return;
}

- (CGFloat)x {
    return self.frame.origin.x;
}
@end
