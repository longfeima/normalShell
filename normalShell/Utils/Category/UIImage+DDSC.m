//
//  UIImage+DDSC.m
//  DDSC
//
//  Created by ai on 16/10/19.
//  Copyright © 2016年 ddsoucai. All rights reserved.
//

#import "UIImage+DDSC.h"

@implementation UIImage (DDSC)
+ (UIImage *)drawImageWithColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
