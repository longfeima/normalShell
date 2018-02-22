//
//  UIColor+DDSC.m
//  DDSC
//
//  Created by dnnta on 14-11-12.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#import "UIColor+DDSC.h"

@implementation UIColor (DDSC)

+ (UIColor *)dd_randomColor {
    return [UIColor colorWithRed:random() / (CGFloat)RAND_MAX
                           green:random() / (CGFloat)RAND_MAX
                            blue:random() / (CGFloat)RAND_MAX
                           alpha:1.0f];
}

+ (UIColor *)dd_colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

+ (UIColor *)dd_colorWithHexString2:(NSString *)stringToConvert alpha:(CGFloat)alpha {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor dd_colorWithRGBHex:hexNum alpha:alpha];
}

+ (UIColor *)dd_colorWithHexString:(NSString *)hexString {
    return [UIColor dd_colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor *)dd_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if (![hexString isKindOfClass:[NSString class]] || [hexString length] == 0) {
        return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:alpha];
    }
    
    if ([hexString hasPrefix:@"0x"]) {
        return [self dd_colorWithHexString2:hexString alpha:alpha];
    }
    
    const char *s = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
    if (*s == '#') {
        ++s;
    }
    unsigned long long value = strtoll(s, nil, 16);
    int r, g, b;
    switch (strlen(s)) {
        case 2:
            // xx
            r = g = b = (int)value;
            break;
        case 3:
            // RGB
            r = ((value & 0xf00) >> 8);
            g = ((value & 0x0f0) >> 4);
            b = ((value & 0x00f) >> 0);
            r = r * 16 + r;
            g = g * 16 + g;
            b = b * 16 + b;
            break;
        case 6:
            // RRGGBB
            r = (value & 0xff0000) >> 16;
            g = (value & 0x00ff00) >>  8;
            b = (value & 0x0000ff) >>  0;
            break;
        default:
            // RRGGBBAA
            r = (value & 0xff000000) >> 24;
            g = (value & 0x00ff0000) >> 16;
            b = (value & 0x0000ff00) >>  8;
            break;
    }
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alpha];
}
@end
