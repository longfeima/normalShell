//
//  DsTabConfig.h
//  WBuild
//
//  Created by CaydenK on 2017/11/3.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TAB_APP_SCREEN_WIDTH                     [UIScreen mainScreen].bounds.size.width
#define TAB_APP_SCREEN_HEIGHT                    [UIScreen mainScreen].bounds.size.height
#define TAB_APP_SCREEN_MAX_LENGTH               (MAX(TAB_APP_SCREEN_WIDTH, TAB_APP_SCREEN_HEIGHT))
#define TAB_APP_SCREEN_MIN_LENGTH               (MIN(TAB_APP_SCREEN_WIDTH, TAB_APP_SCREEN_HEIGHT))
#define TAB_APP_ISIPHONE                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define TAB_APP_ISIPHONE_X                       (TAB_APP_ISIPHONE && TAB_APP_SCREEN_MAX_LENGTH == 812.0)
#define TAB_APP_TAB_HEIGHT                       ((TAB_APP_ISIPHONE_X) ? 83 : 49)




#define TAB_APP_FONT(fontSize)                        [UIFont fontWithName:@"Helvetica" size:fontSize ]
