//
//  AppDelegate.m
//  normalShell
//
//  Created by Seven on 2018/2/22.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "AppDelegate.h"
#import "DsHomeViewController.h"
#import "DsMineViewController.h"
#import "DsStartViewController.h"
#import "DsNoteViewController.h"
#import <IQKeyboardManager.h>

#import "UMMobClick/MobClick.h"

//#import "UMessage.h"
//#import "WXApi.h"

#import "JPUSHService.h"

static NSString *appKey = @"6943b77ca1a7b35800302fa4";
static NSString *channel = @"CP55-Production";
static BOOL isProduction = YES;

@interface AppDelegate ()<UITabBarDelegate, JPUSHRegisterDelegate>

@property (nonatomic, strong) UINavigationController *homeNav;
@property (nonatomic, strong) UINavigationController *noteNav;

@property (nonatomic, strong) UINavigationController *mineNav;


@property (nonatomic, strong) DsHomeViewController *homeVC;
@property (nonatomic, strong) DsNoteViewController *noteVC;
@property (nonatomic, strong) DsMineViewController *mineVC;


@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) DsStartViewController *startVC;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [DsUtils saveFirstInstallTime];
    [self confSDKWithDict:launchOptions];
    [self creatTab];
    self.window.rootViewController = self.rootTab;
//    if ([DsUtils isHaveEnoughTimeToJump]) {
//        self.window = self.baseWindow;
//    }else{
//    }
//    
    return YES;
}




- (void)conNormalfSDKWithDict:(NSDictionary *) launchOptions{
    
}

- (void)confSDKWithDict:(NSDictionary *) launchOptions{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UMConfigInstance.appKey = @"59c208fb9f06fd79d400005a";
    UMConfigInstance.channelId = [NSString stringWithFormat:@"%@-cp55",app_Version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
#if DEBUG
    //    //启动基本SDK
    //    [[PgyManager sharedPgyManager] startManagerWithAppId:pgyerKey];
    //    //启动更新检查SDK
    //    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:pgyerKey];
    //
    //    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:pgyerKey];   // 请将 PGY_APP_ID 换成应用的 App Key
    //    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
#endif
}



- (void) creatTab{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.hidden = NO;
    self.rootTab = [[UITabBarController alloc] init];
    self.rootTab.delegate = self;
    
    
    self.homeVC = [[DsHomeViewController alloc] init];
    self.homeNav = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
    UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:DSLocalizedString(DS_TAB_HOME)
                                                          image:[[UIImage imageNamed:@"icon_tab_homepage_nor"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"icon_tab_homepage_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.homeVC.tabBarItem = homeItem;
    
    
    self.noteVC = [[DsNoteViewController alloc] init];
    self.noteNav = [[UINavigationController alloc] initWithRootViewController:self.noteVC];
    UITabBarItem *noteItem = [[UITabBarItem alloc] initWithTitle:DSLocalizedString(DS_TAB_NOTE)
                                                          image:[[UIImage imageNamed:@"icon_tab_message_nor"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"icon_tab_message_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.noteVC.tabBarItem = noteItem;
    
    
    
    
    self.mineVC = [[DsMineViewController alloc] init];
    self.mineNav = [[UINavigationController alloc] initWithRootViewController:self.mineVC];
    UITabBarItem *mineItem = [[UITabBarItem alloc] initWithTitle:DSLocalizedString(DS_TAB_MINE)
                                                           image:[[UIImage imageNamed:@"icon_tab_my_nor"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"icon_tab_my_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.mineVC.tabBarItem = mineItem;
    
    
    //
    self.homeNav.tabBarItem.tag = 0;
    self.noteNav.tabBarItem.tag = 1;
    self.mineNav.tabBarItem.tag = 2;
    
    
    self.rootTab.tabBar.barStyle = UIBarStyleBlack;
    self.rootTab.tabBar.barTintColor = [UIColor whiteColor];
    self.rootTab.viewControllers = @[self.homeNav, self.noteNav, self.mineNav];
    
}




- (void)tab_selectAtIndex:(NSInteger)index{
    
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark ------------ push -------------------


- (void)handleRemoteMessage:(NSDictionary *)userInfo
{
    
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler {
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler {
}
#endif


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    self.pushMessage = userInfo;
    [self handleRemoteMessage:userInfo];
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)applicatio didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        self.pushMessage = userInfo;
        [self handleRemoteMessage:userInfo];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    
    
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}





@end
