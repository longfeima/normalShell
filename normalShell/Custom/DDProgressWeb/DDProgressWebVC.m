//
//  DDProgressWebVC.m
//  DDSC
//
//  Created by dxw on 14/11/17.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#import "DDProgressWebVC.h"
#import "DDWebViewProgressView.h"
#import "DDWebViewDelegate.h"
#import "AppDelegate.h"



@interface DDProgressWebVC () <DDWebViewProgressDelegate>

@property (nonatomic, strong) UIButton *errorBtn;

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DDWebViewProgressView *progressBar;
@property (nonatomic, strong) DDWebViewDelegate *webViewDelegate;
@property (nonatomic, assign) BOOL hadLoadOnce;
@property (nonatomic, assign) float progressBarHeight;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) BOOL enableProgress;

@property (nonatomic, assign) int navCount;

@property (nonatomic, strong) NSDictionary *shareDetail;

@property (nonatomic, strong) NSDictionary *activityDetail;
@property (nonatomic, assign) BOOL isActivity;
@property (nonatomic, strong) NSString *rightText;
@property (nonatomic, strong) NSString *rightUrl;

@property (nonatomic, assign) BOOL prevIsTempWeb;     //关闭上一个web
@property (nonatomic, assign) BOOL showCloseButton;
@property (nonatomic, strong) NSString *currectLoadUrl;//当前加载URL
@property (nonatomic, strong) NSDictionary *webInfo;

@end

@implementation DDProgressWebVC

- (instancetype)initWithURL:(NSString *)urlStr enabelProgress:(BOOL)enableProgress{
    self = [super init];
    if (self) {
        _urlStr = urlStr;
//        if ([_urlStr dd_containsString:@"newopen"]) {
//            _urlStr = [_urlStr dd_replace:@"newopen" withStr:@"none"];
//        }
        
        _url = [NSURL URLWithString:urlStr];
        _enableProgress = enableProgress;
        _navCount = 0;
        _isActivity = NO;
    }
    return self;
}

- (instancetype)initWithActivity:(NSDictionary *)detail enabelProgress:(BOOL)enableProgress {
    self = [super init];
    if (self) {
        _urlStr = detail[@"linkUrls"];
        _url = [NSURL URLWithString:_urlStr];
        _enableProgress = enableProgress;
        _navCount = 0;
        _activityDetail = detail;
        _isActivity = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = YES;
    
    _webViewDelegate = [[DDWebViewDelegate alloc] init];
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.userInteractionEnabled = YES;
    _webView.scrollView.bounces = YES;
    _webView.scrollView.userInteractionEnabled = YES;
    _webView.scalesPageToFit = YES;
    _webView.delegate = _webViewDelegate;
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
//    self.navigationItem.navType = DD_AccessMessageType;
//    self..rightBarLabelItem.hidden = YES;
//    self.navigationView.rightBarLabelItem.text = @"关闭";
//    self.navigationView.title = @"";
    _webViewDelegate.webViewProxyDelegate = self;
    _webViewDelegate.progressDelegate = self;
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.leading.and.trailing.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(DS_APP_NAV_HEIGHT);
    }];
    
    if (_enableProgress) {
        _progressBarHeight = 2;
        _progressBar = [[DDWebViewProgressView alloc] initWithFrame:CGRectMake(0, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH, _progressBarHeight)];
    }
    
    if (self.prevIsTempWeb) {
        NSMutableArray *VCS = [self.navigationController.viewControllers mutableCopy];
        [VCS removeObjectAtIndex:VCS.count - 2];
        UIViewController *refreshWeb = VCS[VCS.count - 2];
        if ([refreshWeb isKindOfClass:[DDProgressWebVC class]]) {
            DDProgressWebVC *webVC = (DDProgressWebVC *)refreshWeb;
            [webVC webRefresh:nil];
        }
        self.navigationController.viewControllers = VCS;
    }
    
//    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey: @"WebKitCacheModelPreferenceKey"];
//    
//    
//    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey: @"WebKitMediaPlaybackAllowsInline"];
//    id webView = [self.webView valueForKeyPath:@"_internal.browserView._webView"];
//    id preferences = [webView valueForKey:@"preferences"];
//    [preferences performSelector:@selector(_postCacheModelChangedNotification)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webUserInfo:) name:@"getUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webLogin:) name:@"setUserRelogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewAccountInfo:) name:@"getNewAccountInfo" object:nil];
    
    /**H5点击跳转第三方平台时，推送客户端消息*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webPushAlertInfo:) name:@"webPushAlertInfo" object:nil];
     /**H5回到贷超列表获取客户端数据ps：每次进入贷超列表调用*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webPullAlertInfo:) name:@"webPullAlertInfo" object:nil];

    [self starGoRequest];
}

- (void)webPushAlertInfo:(NSNotification *)noti{
    
    NSDictionary *param = [noti object];
    id postObj = param[@"delegate"];
    id info = param[@"param"];
    if (postObj == self && [info isKindOfClass:[NSDictionary class]]){
        self.webInfo = [param[@"param"] mutableCopy];
    }
}

- (void)webPullAlertInfo:(NSNotification *)noti{
    if (self.webInfo) {
//        客户端有平台信息时，调用H5函数上送数据，web界面弹框
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.webInfo options:0 error:nil];
        NSString *userInfoStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"platformInfo('%@')", userInfoStr]];
    }
}




- (void)webLogin:(NSNotification *)noti {
        NSDictionary *param = [noti object];
        id postObj = param[@"delegate"];
        if (postObj == self) {
            if (self.isPresent) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self performSelectorOnMainThread:@selector(logout) withObject:nil waitUntilDone:NO];
//            [self logout];
        }
}




//
#warning mark ----------navigationView交互关闭按钮右边按钮，分享、明细等
- (void)DDCloseBarLabelItemClick{
    if (self.evaluationBlock) {
        self.evaluationBlock();
    }
    if (self.isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//重写点击时间可以忽略此处
- (void)DDRightBarButtonItem{
    
//    NSLog(@"点击了右边Btn");
}
//
- (void)DDRightBarLabelItemClick{
//    NSLog(@"点击了右边label");
}


- (void)DDLeftBarButtonItemClick {
    [self back:nil];
}

- (void)presentCloseButton {
//    self.navigationView.rightBarLabelItem.hidden = NO;
//    [self.navigationView.rightBarLabelItem addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popAllWebVC)]];
}



// noti  use        1
- (void)webShare:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//
//    if (postDelegate == self && params[@"content"]) {
//        NSString *title = [self urlDecode:params[@"title"]];
//        if (title.length == 0) {
//            title = @"点点搜财移动理财专家";
//        }
//        NSString *contentStr = [self urlDecode:params[@"content"]];
//        NSRange range = [contentStr rangeOfString:@"http:"];
//        NSString *url;
//        NSString *content;
//        if (range.location != NSNotFound) {
//            content = [contentStr substringToIndex:range.location];
//            url = [contentStr substringFromIndex:range.location];
//        } else {
//            content = contentStr;
//            url = [self urlDecode:params[@"url"]] ?: @"http://www.ddsoucai.com";
//        }
//        NSString *channel = params[@"channel"];
//        NSString *iconUrl = params[@"imageurl"];
//        UIImage *shareImage;
//        if (iconUrl.length > 0) {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
//            shareImage = [UIImage imageWithData:data];
//        } else {
//            shareImage = [UIImage imageNamed:@"share_icon"];
//        }
//        [[DDSocialShareManager sharedService] socialShareWithTitle:title content:content url:url image:shareImage channel:channel onView:self.navigationController.view];
//    }
}
// unUse            2
- (void)webInvite:(NSNotification *)noti {
    NSDictionary *notiParam = [noti object];
    id postDelegate = notiParam[@"delegate"];
    if (postDelegate != self) {
        return;
    }
    
//    if ([[DDUserManager sharedClient] isLogined]) {
//    } else {
//        DDUserFormVC *loginVC = [[DDUserFormVC alloc] init];
//        loginVC.isPresent = YES;
//        DDNavigationController *nav = [[DDNavigationController alloc] initWithRootViewController:loginVC];
//        [self presentViewController:nav animated:YES completion:nil];
//    }
}
// unUse            3
- (void)jump:(NSNotification *)noti {
//    NSDictionary *params = [noti object];
//    id postObj = params[@"delegate"];
//    if (postObj == self) {
//        int index = [params[@"param"] intValue];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_APP_ITEMS_JUMP object:@(index)];
//        [self.navigationController jz_popToRootViewControllerAnimated:NO completion:^(UINavigationController *navigationController, BOOL finished) {
//            DDAPPDelegate.rootTab.selectIndex = 1;
//        }];
//    }
}

// 5 use            5
- (void)webAlert:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//
//    if (postDelegate == self && params[@"content"]) {
//        NSString *title = [self urlDecode:params[@"title"]];
//        if (title.length == 0) {
//            title = @"点点搜财";
//        }
//        NSString *contentStr = [self urlDecode:params[@"content"]];
//        if (contentStr.length == 0) {
//            contentStr = @"";
//        }
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:contentStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
//        [alert show];
//    }
}

// use 6
- (void)webToast:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//    if (postDelegate == self && params[@"content"]) {
//        NSString *contentStr = [self urlDecode:params[@"content"]];
//        if (contentStr.length == 0) {
//            contentStr = @"发送成功，感谢您的支持";
//        }
//        [SVProgressHUD showText:contentStr];
//    }
}

// use 7
- (void)webShowNavInviteItem:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//
//    if (postDelegate == self && params[@"content"] && !self.navigationItem.rightBarButtonItem) {
//        self.shareDetail = params;
//        self.navigationView.rightBarButtonItem.hidden = NO;
//        self.navigationView.rightBarButtonImage = @"icon_nav_share_nor";
//        [self.navigationView.rightBarButtonItem addTarget:self action:@selector(appShare:) forControlEvents:UIControlEventTouchUpInside];
//
//    } else {
//        //        self.navigationItem.rightBarButtonItem = nil;
//        self.navigationView.rightBarButtonItem.hidden = YES;
//    }
}
- (void)appShare:(id)sender {
//    if (self.shareDetail[@"content"]) {
//        NSString *title = [self urlDecode:self.shareDetail[@"title"]];
//        if (title.length == 0) {
//            title = @"点点搜财移动理财专家";
//        }
//        NSString *contentStr = [self urlDecode:self.shareDetail[@"content"]];
//        NSRange range = [contentStr rangeOfString:@"http:"];
//        NSString *url;
//        NSString *content;
//        if (range.location != NSNotFound) {
//            content = [contentStr substringToIndex:range.location];
//            url = [contentStr substringFromIndex:range.location];
//        } else {
//            content = contentStr;
//            url = [self urlDecode:self.shareDetail[@"url"]] ?: @"http://www.ddsoucai.com";
//        }
//        NSString *channel = self.shareDetail[@"channel"];
//        NSString *iconUrl = self.shareDetail[@"imageurl"];
//        UIImage *shareImage;
//        if (iconUrl.length > 0) {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
//            shareImage = [UIImage imageWithData:data];
//        } else {
//            shareImage = [UIImage imageNamed:@"share_icon"];
//        }
//
//        [[DDSocialShareManager sharedService] socialShareWithTitle:title content:content url:url image:shareImage channel:channel onView:self.navigationController.view];
//    }
}


// use 8 && 18unUse


// unUse 9
- (void)webEncry:(NSNotification *)noti {
    
}
// unUse 10
- (void)webStatis:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//    if (postDelegate != self) {
//        return;
//    }
//
//    NSString *event = params[@"event"];
//    if (event.length > 0) {
//        [DDUtils LogEvent:event attributes:nil];
//    }
}

// use 11
- (void)openWeiXin:(NSNotification *)noti {
//    NSDictionary *dic = [noti object];
//    NSString *name = dic[@"copytxt"] ?: @"金麦穗点点搜财";
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    [pasteboard setString:name];
//    if ([OpenShare isWeixinInstalled]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin:"]];
//    }
}

// use 12
- (void)addBounsItem:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    id postDelegate = notiParam[@"delegate"];
//    if (postDelegate != self) {
//        return;
//    }
//    self.navigationView.rightBarLabelItem.hidden = NO;
//    NSString *title = [notiParam[@"param"][@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    self.rightUrl = notiParam[@"param"][@"url"];
//    self.navigationView.rightBarLabelItem.text = title;
//
//    [self.navigationView.rightBarLabelItem addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openBounsDes:)]];
}

// unUse 13
- (void)openQQ:(NSNotification *)noti {
//    NSDictionary *dic = [noti object];
//    NSString *qq = dic[@"copytxt"] ?: @"467656767";
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    [pasteboard setString:qq];
//    if ([OpenShare isQQInstalled]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqqapi:"]];
//    }
}


// use 15
- (void)webTabChange:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//    if (postDelegate != self) {
//        return;
//    }
//    //或许用不到
//    int index = [params[@"index"] intValue];
//    if (index < 0 && index >= 4) return;
//    if (self.evaluationBlock) {
//        self.evaluationBlock();
//        if (index == 2) {
//            if ([[DDUserManager sharedClient] isLogined]) {
//                DDAPPDelegate.rootTab.selectIndex = index;
//            }
//        } else {
//            DDAPPDelegate.rootTab.selectIndex = index;
//        }
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
//        [self.navigationController jz_popToRootViewControllerAnimated:NO completion:^(UINavigationController *navigationController, BOOL finished) {
//            if (index == 2) {
//                if ([[DDUserManager sharedClient] isLogined]) {
//                    DDAPPDelegate.rootTab.selectIndex = index;
//                }
//            } else {
//                DDAPPDelegate.rootTab.selectIndex = index;
//            }
//        }];
}

// use 16
- (void)webBindCard:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    id postDelegate = notiParam[@"delegate"];
//    if (postDelegate != self) {
//        return;
//    }
//
//    if ([[DDUserManager sharedClient] isLogined]) {
//        DDBindCardVC *bindCardVC = [[DDBindCardVC alloc] init];
//        bindCardVC.type = 2;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bindCardVC];
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
//        return;
//    }
}

// use 17
- (void)webBankAndRefresh:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//    if (postDelegate != self) {
//        return;
//    }
//
//    if (self.evaluationBlock) {
//        self.evaluationBlock();
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
//
//    NSArray *vcs = self.navigationController.viewControllers;
//    if (vcs.count < 2) {
//        return;
//    }
//
//    NSString *needRefresh = params[@"isrefresh"];
//    if ([needRefresh isEqualToString:@"true"]) {
//        NSString *url = params[@"url"];
//        if (url.length > 0) {
//            DDProgressWebVC *webVC = [[DDProgressWebVC alloc] initWithURL:params[@"url"] enabelProgress:YES];
//            webVC.prevIsTempWeb = YES;
//            webVC.navigationController.navigationBarHidden = YES;
//            [self.navigationController pushViewController:webVC animated:YES];
//        } else {
//            __weak UIViewController *vc = vcs[vcs.count - 2];
//            [self.navigationController jz_popViewControllerAnimated:YES completion:^(UINavigationController *navigationController, BOOL finished) {
//                if ([vc isKindOfClass:[DDProgressWebVC class]]) {
//                    DDProgressWebVC *webVC = (DDProgressWebVC *)vc;
//                    [webVC webRefresh:nil];
//                }
//            }];
//        }
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

// use 19
- (void)webJumpProductItem:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//    if (postDelegate != self) {
//        return;
//    }
//
//    NSString *itemid = params[@"itemid"];
//    if (itemid.length > 0) {
//        ///
//        DD_V_T_ProductDetailVC *detailVC = [[DD_V_T_ProductDetailVC alloc] init];
//        detailVC.itemid = itemid;
//        [self.navigationController pushViewController:detailVC animated:YES];
//    }
}

// unUse 20
- (void)webLoading:(NSNotification *)noti {
//    NSDictionary *notiParam = [noti object];
//    NSDictionary *params = notiParam[@"param"];
//    id postDelegate = notiParam[@"delegate"];
//    if (postDelegate != self) {
//        return;
//    }
//    int type = [params[@"type"] intValue];
//    if (type == 1) {
//        [[DDHUD sharedHUD] show];
//    } else if (type == 2) {
//        [[DDHUD sharedHUD] showSafePayLoading];
//    } else {
//        [[DDHUD sharedHUD] hide];
//    }
}


// unUse 22
- (void)webLoginStatus:(NSNotification *)noti {
//    NSString *login = ([DDUserManager sharedClient].isLogined) ? @"1" : @"0";
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"isLogin('%@')", login]];
}

// use 23

// unUse 24
- (void)webAppInfo:(NSNotification *)noti {
//    DDGlobalModel *globalModel = [DDGlobalModel shareModel];
//    NSDictionary *ua = @{@"appversion": DDBundleVersion,
//                         @"terminalid": globalModel.idfv,
//                         @"platform": globalModel.appPlatform,
//                         //                         @"phone": globalModel.phoneType,
//                         @"osversion": globalModel.osversion,
//                         @"channel": globalModel.channel};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:ua options:0 error:nil];
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"appInfo('%@')", str]];
}


// use 26
- (void)openBrowser:(NSNotification *)noti{
//    NSDictionary *param = [noti object];
//    NSString *url = param[@"param"][@"url"];
//    id postDelegate = param[@"delegate"];
//    if (postDelegate != self) {
//        return;
//    }
//    if (url.length > 0) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
    
}

// use 27 用户评测完成
- (void)webEvaluation:(NSNotification *)noti {
//    if (self.evaluationBlock) {
//        self.evaluationBlock();
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)setTitle:(NSString *)title {
//    self.navigationView.title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.webView reload]; //有需求的时候设置web每个界面是是刷新
//    self.navigationController.navigationBarHidden = YES;
//    [DDUtils beginLogPageView:self.logTitle];
    
    if (_enableProgress) {
        if (self.navigationController.navigationBar) {
//            [self.navigationView addSubview:_progressBar];
        }else {
            [_webView addSubview:_progressBar];
        }
    }
//    [self.view bringSubviewToFront:self.navigationView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [DDUtils endLogPageView:self.logTitle];
    [self.webView stopLoading];
    
    if (_enableProgress) {
        [_progressBar removeFromSuperview];
    }
    
//    if (self.navigationController) {
//        UIView *shareView = [self.navigationController.view viewWithTag:8888];
//        if (shareView && [shareView isKindOfClass:[DDSocialShareView class]]) {
//            [(DDSocialShareView *)shareView dismiss];
//        }
//    }
//
    if ([self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
        UIImagePickerController *pic = (UIImagePickerController *)self.presentedViewController;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            if (pic.sourceType == UIImagePickerControllerSourceTypeCamera) {
                pic.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
        }
    
    }
//    if ([self.presentedViewController isKindOfClass:[UIImagePickerController class]]  && IOS_LATEST8 ) {
//        UIImagePickerController *pic = (UIImagePickerController *)self.presentedViewController;
//        if (pic.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            Class object = NSClassFromString(@"UINavigationTransitionView");
//
//            for (UIView *view in pic.view.subviews) {
//                view.backgroundColor = [UIColor blackColor];
//
//                if ([view isKindOfClass:[object class]]) {
//                    view.frame = CGRectMake(0, 44, DDAPPWidth, APPHeight - 44);
//                    [pic.view bringSubviewToFront:view];
//                }
//                if ([view isKindOfClass:[UINavigationBar class]]) {
//                    UINavigationBar *barV = (UINavigationBar *)view;
//                    barV.barTintColor = [UIColor blackColor];
//                }
//            }
//        }
//
//    }
}

- (void)dealloc {
    self.webView.delegate = nil;
    self.webView = nil;
    self.webViewDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Back
- (void)back:(id)sender {
//    self.navigationView.rightBarLabelItem.text = @"";
//    if (self.isNeedRefresh) {
//    [self cleanCacheAndCookie];
//    [self.webView reload];
//    }
//    [self reloadPage:nil];
//    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:self.webView.request];
    if ([self.webView canGoBack]) {
        [self.webView goBack];
//        [self.webView reload];
        if (!self.showCloseButton) {
            self.showCloseButton = YES;
            [self presentCloseButton];
        }
    } else {
        if (self.isPresent) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)popAllWebVC {
    if (self.evaluationBlock) {
        self.evaluationBlock();
    }
    if (self.isNeedRefresh) {
        [self cleanCacheAndCookie];
    }
    if (self.isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)cleanCacheAndCookie{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
//        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


#pragma mark - Noti
- (void)appShareResult:(NSNotification *)noti {
    [self.webView stringByEvaluatingJavaScriptFromString:@"sharesuccess(0)"];
}

- (void)webRefresh:(NSNotification *)noti {
    [self starGoRequest];
}


- (void)webText:(NSNotification *)noti {
    NSDictionary *notiParam = [noti object];
    NSDictionary *params = notiParam[@"param"];
    id postDelegate = notiParam[@"delegate"];
    
    if (postDelegate == self && params[@"content"]) {
        NSString *title = [self urlDecode:params[@"title"]];
        if (title.length == 0) {
            title = @"点点搜财移动理财专家";
        }
        NSString *contentStr = [self urlDecode:params[@"content"]];
        NSRange range = [contentStr rangeOfString:@"http:"];
        NSString *url;
        NSString *content;
        if (range.location != NSNotFound) {
            content = [contentStr substringToIndex:range.location];
            url = [contentStr substringFromIndex:range.location];
        } else {
            content = contentStr;
            url = [self urlDecode:params[@"url"]] ?: @"http://www.ddsoucai.com";
        }
        NSString *channel = params[@"channel"];
        NSString *iconUrl = params[@"imageurl"];
        UIImage *shareImage;
        if (iconUrl.length > 0) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
            shareImage = [UIImage imageWithData:data];
        } else {
            shareImage = [UIImage imageNamed:@"share_icon"];
        }
//        [[DDSocialShareManager sharedService] socialShareWithTitle:title content:content url:url image:shareImage channel:channel onView:self.navigationController.view];
    }
}

- (void)openNewWeb:(NSNotification *)noti {
    NSDictionary *param = [noti object];
    NSString *url = param[@"url"];
    id postDelegate = param[@"delegate"];
    if (postDelegate != self) {
        return;
    }
    if (url.length > 0) {
        DDProgressWebVC *webVC = [[DDProgressWebVC alloc] initWithURL:url enabelProgress:YES];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
- (void)openDuiBa:(NSNotification *)noti {

}

- (void)openBounsDes:(NSString *)url {
    DDProgressWebVC *webVC = [[DDProgressWebVC alloc] initWithURL:self.rightUrl enabelProgress:YES];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (NSString *)urlDecode:(NSString *)stringToDecode
{
    return (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                  (__bridge CFStringRef)stringToDecode,
                                                                                                  (CFStringRef)@"",
                                                                                                  CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

#pragma mark - Load Request
- (void)starGoRequest {    
    [_webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}

#pragma mark - Progress Delegate
- (void)webViewDelegate:(DDWebViewDelegate *)webViewDelegate updateProgress:(float)progress
{
    if (_enableProgress) {
        [_progressBar setProgress:progress animated:YES];
    }
//    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.navigationController.navigationBarHidden = YES;
    
    _urlStr = webView.request.URL.absoluteString;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] != NSURLErrorCancelled) {
        NSDictionary *userinfo = error.userInfo;
        if (userinfo) {
            NSString *pageurl = [userinfo objectForKey:@"NSErrorFailingURLStringKey"];
            if ([pageurl isEqualToString:_urlStr]) {
                if (!self.errorBtn) {
                    self.errorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.errorBtn setBackgroundImage:[UIImage imageNamed:@"emptyList"] forState:UIControlStateNormal];
                    [self.errorBtn setBackgroundImage:[UIImage imageNamed:@"emptyList"] forState:UIControlStateHighlighted];
                    self.errorBtn.frame = CGRectMake(0, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT - DS_APP_NAV_HEIGHT);
                    [self.view addSubview:self.errorBtn];
                    [self.errorBtn addTarget:self action:@selector(reloadPage:) forControlEvents:UIControlEventTouchUpInside];
                }
                if (_enableProgress) {
                    [_progressBar setProgress:1.0 animated:YES];
                }
                [self.view bringSubviewToFront:self.errorBtn];
            }
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //一元抢购取消分享按钮
//    self.navigationController.navigationBarHidden = YES;
    NSString *str = request.URL.absoluteString;
    self.currectLoadUrl = str;
//    if (IOS_LATEST8) {
//        if ([str containsString:@"http://192.168.3.240:8080"]) {
//            self.navigationView.rightBarButtonItem.hidden = YES;
//        }
//    }else{
//        if ([str rangeOfString:@"http://192.168.3.240:8080"].location != NSNotFound) {
//            self.navigationView.rightBarButtonItem.hidden = YES;
//        }
//    }

    return YES;
}

#pragma mark - Event
- (void)reloadPage:(UIButton *)sender {
    [self.errorBtn removeFromSuperview];
    self.errorBtn = nil;
    [self starGoRequest];
}


@end
