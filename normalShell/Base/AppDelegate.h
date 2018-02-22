//
//  AppDelegate.h
//  normalShell
//
//  Created by Seven on 2018/2/22.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DsBaseTabBar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) UIWindow *startWindow;

@property (strong, nonatomic) DsBaseTabBar *rootTab;
@property (nonatomic, strong) NSDictionary *pushMessage;


@end

