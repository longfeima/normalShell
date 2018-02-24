//
//  CPPersonalMessageDetailVC.m
//  lottery
//
//  Created by wayne on 2017/8/29.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPPersonalMessageDetailVC.h"

@interface CPPersonalMessageDetailVC ()
{
    
    IBOutlet UIWebView *_contentTv;
    IBOutlet UILabel *_titleLabel;
    
}
@end

@implementation CPPersonalMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人消息";
    _titleLabel.text = self.msgTitle;
    [self queryMessageDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)queryMessageDetailInfo
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:self.msgId forKey:@"id"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIUserMsgDetail
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *info = [request.resultInfo DWDictionaryForKey:@"data"];
                   NSString *content = [info DWStringForKey:@"content"];
                   [_contentTv loadHTMLString:content baseURL:nil];
                   
               }else{
                   alertMsg = request.requestDescription;
                   [self.navigationController popViewControllerAnimated:YES];
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
               [self.navigationController popViewControllerAnimated:YES];
               
           }];
}


@end
