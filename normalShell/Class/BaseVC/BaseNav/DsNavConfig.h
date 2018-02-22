//
//  DsNavConfig.m
//  WBuild
//
//  Created by CaydenK on 2017/11/2.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define APP_SCREEN_WIDTH                     [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT                    [UIScreen mainScreen].bounds.size.height
#define APP_SCREEN_MAX_LENGTH               (MAX(APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT))
#define APP_SCREEN_MIN_LENGTH               (MIN(APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT))
#define APP_ISIPHONE                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define APP_ISIPHONE_X                       (APP_ISIPHONE && APP_SCREEN_MAX_LENGTH == 812.0)
#define APP_NAV_HEIGHT                       ((APP_ISIPHONE_X) ? 88 : 64)




#define APP_FONT(fontSize)                        [UIFont fontWithName:@"Helvetica" size:fontSize ]

