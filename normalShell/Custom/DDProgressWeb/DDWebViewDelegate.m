 //
//  TBJWebViewDelegate.m
//  TBJPro
//
//  Created by dongxiaowei on 14-9-22.
//  Copyright (c) 2014年 TBJ. All rights reserved.
//

#import "DDWebViewDelegate.h"


const float kDDWebViewStartProgress = 0.1f;
const float kDDWebViewLodingProgress = 0.5f;
const float kDDWebViewFinalProgress = 0.9f;
NSString *kTBJWebViewCompletePath = @"/ddWebViewProgress/complete";

@interface DDWebViewDelegate ()

@property (nonatomic, assign) int loadingCount;
@property (nonatomic, assign) int totalLoadCount;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, assign) BOOL isLocalHtml;

@end

@implementation DDWebViewDelegate

- (id)init {
    self = [super init];
    if (self) {
        _totalLoadCount = 0;
        _loadingCount = 0;
        _interactive = NO;
        _isLocalHtml = NO;
    }
    return self;
}

- (void)reset {
    _totalLoadCount = 0;
    _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.f];
}

- (void)setProgress:(float)progress {
    if (progress > _progress || progress == 0) {
        _progress = progress;
        if ([_progressDelegate respondsToSelector:@selector(webViewDelegate:updateProgress:)]) {
            [_progressDelegate webViewDelegate:self updateProgress:_progress];
        }
    }
}

- (void)startProgress {
    if (_progress < kDDWebViewStartProgress) {
        [self setProgress:kDDWebViewStartProgress];
    }
}

- (void)incrementProgress {
    float progress = self.progress;
    float maxProgress = self.interactive ? kDDWebViewFinalProgress : kDDWebViewLodingProgress;
    float remainPercent = 1.0 * self.loadingCount / self.totalLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress {
    [self setProgress:1.0];
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *absoluteUrlStr = request.URL.absoluteString;
    
    if (absoluteUrlStr.length <= 0) {
        return NO;
    }
    
    if ([absoluteUrlStr rangeOfString:@"mailto"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:absoluteUrlStr]];
    }
    NSLog(@"\n\n%@\n\n", absoluteUrlStr);
    if ([absoluteUrlStr hasPrefix:@"http://daidashu.local"]) {
        [self handleLocationRequest:absoluteUrlStr];
        return NO;
    }
    
    if ([absoluteUrlStr rangeOfString:@"duiba"].location != NSNotFound) {
        NSString *newUrl = [absoluteUrlStr dd_replace:@"newopen" withStr:@"none"];
        if (newUrl) {
            NSDictionary *notiParam = @{@"url": newUrl, @"delegate": self.webViewProxyDelegate };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenDuiBa" object:notiParam];
            return NO;
        }
    }
    
    if ([absoluteUrlStr rangeOfString:@"newopen"].location != NSNotFound) {
        NSString *newUrl = [absoluteUrlStr dd_replace:@"newopen" withStr:@"none"];
        NSDictionary *notiParam = @{@"url": newUrl, @"delegate": self.webViewProxyDelegate};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DDOpenNewWeb" object:notiParam];
        return NO;
    }
   
    if ([request.URL.path isEqualToString:kTBJWebViewCompletePath]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL ret = YES;
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL isFragmentRequest = NO;
    if (request.URL.fragment) {
        NSString *replaceFragmentPath = [absoluteUrlStr stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment]
                                                                                              withString:@""];
        isFragmentRequest = [replaceFragmentPath isEqualToString:request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    
    _isLocalHtml = [request.URL.scheme isEqualToString:@"file"] && ([absoluteUrlStr hasSuffix:@"405.html"] || [absoluteUrlStr hasSuffix:@"405_noHead.html"]);
    
    if (ret && !isFragmentRequest && isHTTP && isTopLevelNavigation) {
        _currentURL = request.URL;
        [self reset];
    }
    
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewProxyDelegate webViewDidStartLoad:webView];
    }
    _loadingCount++;
    _totalLoadCount = MAX(_loadingCount, _totalLoadCount);
    
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *format = @"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);";
        NSString *waitForCompleteJS = [NSString stringWithFormat:format, webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, kTBJWebViewCompletePath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
    
    if (_isLocalHtml) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *format = @"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);";
        NSString *waitForCompleteJS = [NSString stringWithFormat:format, webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, kTBJWebViewCompletePath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
        
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

#pragma mark - Local Request
- (NSDictionary *)parseRequestParam:(NSString *)url {
    NSRange range = [url rangeOfString:@"?"];
    NSString *paramsUrl = [url substringFromIndex:(range.location + range.length)];
    NSArray *params = [paramsUrl componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    if (params.count > 0) {
        for (NSString *keyValueStr in params) {
            NSArray *keyValueArr = [keyValueStr componentsSeparatedByString:@"="];
            if (keyValueArr.count == 2) {
                [paramDic setObject:keyValueArr[1] forKey:keyValueArr[0]];
            }
        }
    }
    return paramDic;
}

- (void)handleLocationRequest:(NSString *)url {
    NSDictionary *param = [self parseRequestParam:url];
    if (param[@"action"]) {
        NSString *notiStr = param[@"action"] ?: @"";
        NSDictionary *notiParam = @{@"param": param, @"delegate": self.webViewProxyDelegate };
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:notiStr object:notiParam];
        });

    }
}

@end
