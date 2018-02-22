//
//  UIColor+DDSC.h
//  DDSC
//
//  Created by dnnta on 14-11-12.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DDGrayColor  [UIColor dd_colorWithHexString:@"0x727171"] 
#define DDLineColor  [UIColor dd_colorWithHexString:@"0xdadada"]
#define DDTextColor  [UIColor dd_colorWithHexString:@"0x888888"]
#define DDTextGrayColor  [UIColor dd_colorWithHexString:@"0xa1a1a1"]

#define DDItmeCellStatusNewerItemColor  [UIColor dd_colorWithHexString:@"666666"]
#define DDItmeCellStatusHotColor        [UIColor dd_colorWithHexString:@"666666"]
#define DDItmeCellStatusNoticeColor     [UIColor dd_colorWithHexString:@"666666"]
#define DDItmeCellStatusSellOutColor    [UIColor dd_colorWithHexString:@"999999"]
#define DDItmeCellStatusRecommedColor   [UIColor dd_colorWithHexString:@"F47E26"]

#define DDItmeCellTitleNormalColor      [UIColor dd_colorWithHexString:@"666666"]
#define DDItmeCellTitleNoticeColor      [UIColor dd_colorWithHexString:@"666666"]
#define DDItmeCellTitleSellOutColor     [UIColor dd_colorWithHexString:@"99999990"]

#define DDItmeCellSellOutColor          [UIColor dd_colorWithHexString:@"999999"]

#define DDItmeCellNormalTextColor       [UIColor dd_colorWithHexString:@"FF5933"]
#define DDItemCellTipTextColor          [UIColor dd_colorWithHexString:@"888888"]

#define DDProductItmeCellTitleNormalColor  [UIColor dd_colorWithHexString:@"4f4f4f"]
#define DDProductItmeCellTitleSelectColor  [UIColor dd_colorWithHexString:@"ff7e00"]

@interface UIColor (DDSC)

+ (UIColor *)dd_randomColor;
+ (UIColor *)dd_colorWithRGBHex:(UInt32)hex;
+ (UIColor *)dd_colorWithHexString:(NSString *)hexString;
+ (UIColor *)dd_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end
