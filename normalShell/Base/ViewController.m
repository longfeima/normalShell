//
//  ViewController.m
//  normalShell
//
//  Created by 艾欧 on 2018/4/10.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
        [_webView loadRequest:request];//加载
    }
    return _webView;
    
}
@end
