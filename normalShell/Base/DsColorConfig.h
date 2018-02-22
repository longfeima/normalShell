//
//  DsColorConfig.h
//  WBuild
//
//  Created by Seven on 2017/8/18.
//  Copyright © 2017年 Seven. All rights reserved.
//

#ifndef DsColorConfig_h
#define DsColorConfig_h



#pragma mark ------- normal && night


#define DS_COLOR_RANDOM                  [UIColor colorWithRed:arc4random()%244/255.0 green:arc4random()%244/255.0 blue:arc4random()%244/255.0 alpha:1]
#define DS_COLOR_HEXCOLOR(hexStr)               [UIColor dd_colorWithHexString:hexStr]
#define DS_DAYANDNIGHT(night,day)              [[DsUtils fetchFromUserDefaultsWithKey:DS_GLOBAL_ISNIGHT] boolValue] ? night : day

//tabBarColor
#define DS_COLOR_TABBAR_NIGHT                     [DS_COLOR_HEXCOLOR(@"000000") colorWithAlphaComponent:0.6]
#define DS_COLOR_TABBAR_NORMAL                    DS_COLOR_HEXCOLOR(@"ffffff")

//backgroundColor
#define DS_COLOR_BACKGROUND_NIGHT               [DS_COLOR_HEXCOLOR(@"000000") colorWithAlphaComponent:0.6]
#define DS_COLOR_BACKGROUND_NORMAL              DS_COLOR_HEXCOLOR(@"f1f1f1")

//textColor
#define DS_COLOR_TEXT_CONTENT_NIGHT                  DS_COLOR_HEXCOLOR(@"999999")
#define DS_COLOR_TEXT_CONTENT_NORMAL                 DS_COLOR_HEXCOLOR(@"333333")
#define DS_COLOR_TEXT_BLUE                           DS_COLOR_HEXCOLOR(@"0x57C9E8")


//global && normal->night
#define DS_GLOBAL_ISNIGHT                                       @"DS_GLOBAL_ISNIGHT"
#define DS_COLOR_GLOBAL_TABBAR                                  DS_DAYANDNIGHT(DS_COLOR_TABBAR_NIGHT,DS_COLOR_TABBAR_NORMAL)
#define DS_COLOR_GLOBAL_BACKGROUND                              DS_DAYANDNIGHT(DS_COLOR_BACKGROUND_NIGHT,DS_COLOR_BACKGROUND_NORMAL)
#define DS_COLOR_GLOBAL_TEXT_CONTENT                            DS_DAYANDNIGHT(DS_COLOR_TEXT_CONTENT_NIGHT,DS_COLOR_TEXT_CONTENT_NORMAL)



//navigationBar
#define DS_COLOR_NAVIGATIONBAR_TITLE                 DS_COLOR_HEXCOLOR(@"0x54CAEB")


#endif /* DsColorConfig_h */
