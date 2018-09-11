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

#import "DsNoteViewController.h"
#import <IQKeyboardManager.h>


#import <AFNetworking.h>
#import "ViewController.h"


#import "WXApi.h"

#ifdef DEBUG
#import "FLEXManager.h"
#endif

#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



@interface AppDelegate ()<UITabBarDelegate, UNUserNotificationCenterDelegate  ,WXApiDelegate>

@property (nonatomic, strong) UINavigationController *homeNav;
@property (nonatomic, strong) UINavigationController *noteNav;

@property (nonatomic, strong) UINavigationController *mineNav;


@property (nonatomic, strong) DsHomeViewController *homeVC;
@property (nonatomic, strong) DsNoteViewController *noteVC;
@property (nonatomic, strong) DsMineViewController *mineVC;


@property (nonatomic, strong) UIImageView *blurView;



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
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [DsUtils saveFirstInstallTime];
    [self confSDKWithDict:launchOptions];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSString *urlString = @"http://211.159.186.227:8085/Account/GetConfig?token=7d5bb8e9-5e23-4f68-97c5-7d22ed829c05";
    //    iOS程序访问HTTP资源时需要对URL进行Encode，比如像拼出来的 http://ami.ac?p1=%+&sa f&p2=中文，其中的中文、特殊符号&％和空格都必须进行转译才能正确访问
    //    NSString *str =[content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
//    NSDictionary *params = @{@"token": @"7d5bb8e9-5e23-4f68-97c5-7d22ed829c05"};
    //  默认提交请求的数据是二进制的,返回格式是JSON；如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
    //  设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"post请求成功＝＝＝＝%@",dict);
        if (!dict) {
            [self creatTab];
            return ;
        }
        int success = [[dict objectForKey:@"success"] intValue];
        if (success) {
            int status = 1;//[[dict objectForKey:@"status"] intValue];
            if (status) {//开关打开
                ViewController *vc = [[ViewController alloc] init];
                self.window.rootViewController = vc;
                [self.window makeKeyAndVisible];
            }else{//开关关闭
                [self creatTab];
            }
        }else{
            [self creatTab];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败＝＝＝＝%@",error);
        [self creatTab];
    }];

//    if ([DsUtils isHaveEnoughTimeToJump]) {
//        self.window = self.baseWindow;
//    }else{
//    }
//    
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

#pragma mark - FLEX
#ifdef DEBUG
- (void)setupDebugginGesture {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFLEX)];
    gesture.numberOfTapsRequired = 2;
    gesture.numberOfTouchesRequired = 2;
    [self.window addGestureRecognizer:gesture];
}
- (void)showFLEX {
    [[FLEXManager sharedManager] showExplorer];
}
#endif


- (void)conNormalfSDKWithDict:(NSDictionary *) launchOptions{
    
}

- (void)confSDKWithDict:(NSDictionary *) launchOptions{
    
    NSString *UMessageAppKey = @"5b8e769af43e486ff3000024";
//    [UMessage openDebugMode:YES];
    [UMConfigure setLogEnabled:NO];
    [UMConfigure initWithAppkey:UMessageAppKey channel:nil];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 用户接受消息
        }else{
            // 用户拒收消息
        }
    }];
    [UMessage setBadgeClear:YES];

    
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
    
    self.window.rootViewController = self.rootTab;
    [self.window makeKeyAndVisible];
}




- (void)tab_selectAtIndex:(NSInteger)index{
    
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [SUMUser checkUpdateNewestVersion];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForApplicationWillEnterForeground object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}



#pragma mark ------------ push -------------------


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    NSLog(@"\n\n%@\n\n", [deviceToken description]);
    
//    NSString *st = [deviceToken description];
//   st = [st stringByReplacingOccurrencesOfString:@">" withString:@""];
//   st = [st stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    st = [st stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    NSLog(@"\n\n\nst%@\n\n\n", st);
//    NSData *data = [st dataUsingEncoding:NSUTF8StringEncoding];
//    [UMessage registerDeviceToken: data];
}




//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*
     [UMessage didReceiveRemoteNotification:userInfo];
     */
    [UMessage setAutoAlert:NO];
    if (@available(iOS 10.0, *)) {
        
    } else {
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    
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

#pragma mark- UNUserNotificationCenterDelegate
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center
      willPresentNotification:(UNNotification *)notification
        withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
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
    
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - WXApi
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
