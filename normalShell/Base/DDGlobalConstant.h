//
//  DDGlobalConstant.h
//  DDSC
//
//  Created by dxw on 14/11/27.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#ifndef DDSC_DDGlobalConstant_h
#define DDSC_DDGlobalConstant_h

#define fequalzero(a) (fabs(a) < FLT_EPSILON)

#define DDBoolValue(strValue) (strValue) ? [strValue intValue] : (-1)

#define DDHandleBlock(block, ...)            if(block) { block(__VA_ARGS__); }
//#define DDAPPDelegate                     ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define DDBundleVersion                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/**本地化语言获取*/

#define DSLocalizedString(key)                   [NSString stringWithFormat:@"%@", NSLocalizedString(key, nil)]

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//#define DDAPPSize                         [[UIScreen mainScreen] bounds].size
//#define DDAPPWidth                        DDAPPSize.width
//#define APPHeight                         DDAPPSize.height

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)



#define IS_IPHONE_4 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define kDDIPhone5                    IS_IPHONE_5
#define kDDIPhone4                    IS_IPHONE_4
#define IOS_LATEST8                     [UIDevice currentDevice].systemVersion.floatValue >= 8.0
#define IOS_LATEST7                     [UIDevice currentDevice].systemVersion.floatValue >= 7.0
#define IOS_LATEST9                     [UIDevice currentDevice].systemVersion.floatValue >= 9.0

#define KWidthScale6AND5                (375.0 / 320.0)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define DDAPPChannel                      @"App Store"

//#define DDAPPFont(fontSize)               [UIFont fontWithName:@"Helvetica" size:fontSize ]
//#define DDAPPBoldFont(fontSize)           [UIFont fontWithName:@"Helvetica-Bold" size:fontSize ]
//#define DDAPPLightFont(fontSize)          [UIFont fontWithName:@"Helvetica-Light" size:fontSize ]

#define kDDUserPhoneInputChar             @"0123456789"
#define kDDUserCardInputChar              @"0123456789Xx"

#define DDAPPHexColor(hexStr)             [UIColor dd_colorWithHexString:hexStr]

#define kDDGuestPwd(uid)                [NSString stringWithFormat:@"guess%@", uid]       //手势密码标识 值为用户电话 前面加guess以区分
#define kDDGuestCountKey(uid)           [NSString stringWithFormat:@"guesscount%@", uid]             // 手势密码解锁次数Tip
#define kDDGuestMaxCount                5                   // 手势密码解锁剩余次数
#define kDDGuestMinLength               4                   // 手势密码最低长度

#define kDDFingerprint(uid)             [NSString stringWithFormat:@"fingerprint%@", uid]     //指纹密码

#define kDDEnterBackground              @"enterBackground"

/**/

#define DDBundleVersion                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]





#define SCREEN_MAX_LENGTH               (MAX(DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT))
#define SCREEN_MIN_LENGTH               (MIN(DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT))

#define DS_APP_ISIPAD                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DS_APP_ISIPHONE                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define DS_APP_ISRETINA                 ([[UIScreen mainScreen] scale] >= 2.0)
#define DS_APP_ISIPHONE_4               (DS_APP_ISIPHONE && SCREEN_MAX_LENGTH < 568.0)
#define DS_APP_ISIPHONE_5               (DS_APP_ISIPHONE && SCREEN_MAX_LENGTH == 568.0)
#define DS_APP_ISIPHONE_6               (DS_APP_ISIPHONE && SCREEN_MAX_LENGTH == 667.0)
#define DS_APP_ISIPHONE_6P              (DS_APP_ISIPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X                     (DS_APP_ISIPHONE && SCREEN_MAX_LENGTH == 812.0)

#define DS_APP_OS_LATEST8                     [UIDevice currentDevice].systemVersion.floatValue >= 8.0
#define DS_APP_OS_LATEST7                     [UIDevice currentDevice].systemVersion.floatValue >= 7.0
#define DS_APP_OS_LATEST9                     [UIDevice currentDevice].systemVersion.floatValue >= 9.0

#define DS_APP_DELEGATE                     ((AppDelegate *)[UIApplication sharedApplication].delegate)





#define DS_APP_SIZE                         [[UIScreen mainScreen] bounds].size
#define DS_APP_SIZE_SCALE                   [[UIScreen mainScreen] bounds].size.width / 375.0
#define DS_APP_SIZE_WIDTH                   DS_APP_SIZE.width
#define DS_APP_SIZE_HEIGHT                  DS_APP_SIZE.height
#define DS_APP_NAV_HEIGHT                   ((IS_IPHONE_X) ? 88 : 64)
#define DS_APP_TAB_HEIGHT                   ((IS_IPHONE_X) ? 83 : 49)
#define DS_APP_SAFE_AREA_BOTTOM_HRIGHT      ((IS_IPHONE_X) ? 34 : 0)


#define DS_APP_FONT(fontSize)               [UIFont fontWithName:@"Helvetica" size:fontSize ]
#define DS_APP_FONT_BOLD(fontSize)          [UIFont fontWithName:@"Helvetica-Bold" size:fontSize ]
#define DS_APP_FONT_LIGHT(fontSize)         [UIFont fontWithName:@"Helvetica-Light" size:fontSize ]




















#define DS_CHAR_PHONENUMBER                        @"0123456789"






#define DS_USER_COLLECTION_MATERIALS(MOBILE)    [NSString stringWithFormat:@"DS_USER_COLLECTION_MATERIALS%@",MOBILE]   //用户收藏的物料列表


#define DS_URL_TEMP                             @"https://www.baidu.com"
#define DS_LIST_PAGESIZE                        @"10"

/**/


#endif
