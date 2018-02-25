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

#import "UMessage.h"
#import "WXApi.h"

#import "JPUSHService.h"

static NSString *appKey = @"6943b77ca1a7b35800302fa4";
static NSString *channel = @"CP55-Production";
static BOOL isProduction = YES;

@interface AppDelegate ()<UITabBarDelegate, JPUSHRegisterDelegate, DsTabBarProtocol>

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
    
    if ([DsUtils isHaveEnoughTimeToJump]) {
        [self confSDKWithDict:launchOptions];
        [self initCaiPiao];
        [self customAppearence];
        self.window = self.baseWindow;
    }else{
        [DsUtils saveFirstInstallTime];
        [self creatTab];
        self.window.rootViewController = self.rootTab;
    }
    
    return YES;
}


- (void)initCaiPiao{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.toolbarDoneBarButtonItemText = @"完成";
    
    self.baseWindow = [[UIWindow  alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.baseWindow.backgroundColor = [UIColor whiteColor];
    self.maiTabBarController = [[MainTabBarController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.maiTabBarController];
    nav.navigationBarHidden = YES;
    self.baseWindow.rootViewController = nav;
    
}

- (void)customAppearence
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kMainColor] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back_navi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance]setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:backButtonImage];
    [[UINavigationBar appearance]setTintColor:[UIColor clearColor]];
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        // 去掉iOS11系统默认开启的self-sizing
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName,
      nil]];
    
    [[UITabBar appearance]setTintColor:kMainColor];
    
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


- (void)userReLogin:(NSNotification *)noti {
    [[sShowTisWindow shareTipsWindow] showTipsWithString:@"登录授权过期，请重新登录" stopDuration:6];
    UINavigationController *nav = (UINavigationController *)self.rootTab.selectedViewController;
    UIViewController *topVC = nav.topViewController;
    UIViewController *presentVC = nav.visibleViewController;
    if (topVC != presentVC) {
        [presentVC dismissViewControllerAnimated:NO completion:^{
            [nav popToRootViewControllerAnimated:NO];
        }];
    } else {
        [nav popToRootViewControllerAnimated:NO];
    }
    
//    DsLoginViewController *loginVC = [[DsLoginViewController alloc] init];
//    loginVC.isPresent = YES;
//    UINavigationController *logNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [self.rootTab.selectedViewController presentViewController:logNav animated:YES completion:^{
//        self.rootTab.selectIndex = 0;
//    }];
}


- (void) creatTab{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.hidden = NO;
    self.rootTab = [[DsBaseTabBar alloc] init];
    //    self.rootTab.tabLocalAdvImageString = @"companyLogo";
    //    self.rootTab.tabAdvImageURL = @"http://ddsc2.b0.upaiyun.com/common/activity/%E5%AE%A1%E6%9F%A5banner.jpg";
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [SUMUser checkUpdateNewestVersion];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForApplicationWillEnterForeground object:nil];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ------------ 应用跳转 -------------------
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url  {
//    if ([[url absoluteString] hasPrefix:@"wxc7d7a34f4dd7c4d8://"]) {
//        return [WXApi handleOpenURL:url delegate:nil];
//
//    }
//        else if([[url absoluteString] hasPrefix:@"wb3511254898://"]) {
//            return [WeiboSDK handleOpenURL:url delegate:nil];
//    
//        } else if([[url absoluteString] hasPrefix:@"tencent1103598557://"]) {
//            return [QQApiInterface handleOpenURL:url delegate:nil];
//    
//        }

//    else {
//        return YES;
//    }
//}



//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
//    if ([[url absoluteString] hasPrefix:@"wxc7d7a34f4dd7c4d8://"]) {
//        return [WXApi handleOpenURL:url delegate:nil];
//
//    }
//    //    else if([[url absoluteString] hasPrefix:@"wb3511254898://"]) {
//    //        return [WeiboSDK handleOpenURL:url delegate:nil];
//    //
//    //    } else if([[url absoluteString] hasPrefix:@"tencent1103598557://"]) {
//    //        return [QQApiInterface handleOpenURL:url delegate:nil];
//    //
//    //    }
//
//    else {
//        return YES;
//    }
//}

#pragma mark ------------ push -------------------


- (void)handleRemoteMessage:(NSDictionary *)userInfo
{
    
    int action = [userInfo[@"action"] intValue];
    UINavigationController *nav = (UINavigationController *)self.rootTab.selectedViewController;
    UIViewController *presentVC = nav.visibleViewController;
    UIViewController *topVC = nav.topViewController;
    
   
    
    switch (action) {
        case 1:
        {
//            NSString *data = userInfo[@"data"];
//            if (data.length > 0) {
//                DDProgressWebVC *webVC = [[DDProgressWebVC alloc] initWithURL:data enabelProgress:YES];
//                webVC.hidesBottomBarWhenPushed = YES;
//                // 设置手势密码页面是不带nav头的，此处无效
//                if (presentVC.navigationController) {
//                    self.pushMessage = nil;
//                    [presentVC.navigationController pushViewController:webVC animated:YES];
//                }
//            }
        }
            break;
        case 2:
        {
            
        }
            break;
            
        case 3: {
            
        }
            break;
        default:
            break;
    }
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
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
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
    
    id alert = [[userInfo DWDictionaryForKey:@"aps"]objectForKey:@"alert"];
    NSString *title = @"推送通知";
    NSString *body = @"";
    
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSDictionary *alertDic = (NSDictionary *)alert;
        title = [alertDic DWStringForKey:@"title"];
        body = [alertDic DWStringForKey:@"body"];
        
    }else{
        body = alert;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:body delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*
     [UMessage didReceiveRemoteNotification:userInfo];
     */
    [JPUSHService handleRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        
        id alert = [[userInfo DWDictionaryForKey:@"aps"]objectForKey:@"alert"];
        NSString *title = @"推送通知";
        NSString *body = @"";
        
        if ([alert isKindOfClass:[NSDictionary class]]) {
            NSDictionary *alertDic = (NSDictionary *)alert;
            title = [alertDic DWStringForKey:@"title"];
            body = [alertDic DWStringForKey:@"body"];
            
        }else{
            body = alert;
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                           message:body
                                                          delegate:nil
                                                 cancelButtonTitle:@"知道了"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
    
    
    
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


// ===============wechat==================
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        [self queryWechatUnionid:temp.code];
        //temp.code
    }
}

- (void)queryWechatUnionid:(NSString *)code
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    @"wx5525912ec3511b13",@"17578bee42800d5608d3f30e148d9c12",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                /*
                 {
                 "access_token" = "VZpnWzT9ufPUF2iBUNjKukFViYgrIN1ysMfGJDaC21M2HZHqwB26bNWlz0WyXRKUzxqnXgW1kYo4yyDtdwJEE4Zo-eNQUV56R9wf8degtzQ";
                 "expires_in" = 7200;
                 openid = oKZpQ01Rq75rCbeWnbKwXqdQ8PnE;
                 "refresh_token" = YFMsMI0Kcyh8lO2RuaRAtHNurp1CSjCYXvu4tjraAQi4VfMEXSG1T3A4IgNLZ7kahvRxdP6nM9PQJ1WXpoqoKbwd8qS9285fuPjpNXNP3nI;
                 scope = "snsapi_userinfo";
                 unionid = "oas-J0mszbdm089Jk9gIHhFOankg";
                 }
                 */
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSString *unionid = [dic DWStringForKey:@"unionid"];
                NSString *access_token = [dic DWStringForKey:@"access_token"];
                NSString *openid = [dic DWStringForKey:@"openid"];
                NSString *refresh_token = [dic DWStringForKey:@"refresh_token"];
                
                [self getWechatUserInfoWithAccessToken:access_token openId:openid];
                
                if (unionid.length>0) {
                    [SVProgressHUD dismiss];
                }else{
                }
                
                
            }else{
                
            }
            
        });
    });
}

- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    NSString *headimgurl = [dic DWStringForKey:@"headimgurl"];
                    NSString *nickname = [dic DWStringForKey:@"nickname"];
                    if (headimgurl.length>0 && nickname.length>0) {
                    }
                }
                
                
            }
        });
        
    });
}





@end
