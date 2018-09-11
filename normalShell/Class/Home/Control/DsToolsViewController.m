//
//  DsToolsViewController.m
//  normalShell
//
//  Created by 龙飞马 on 2018/9/4.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsToolsViewController.h"
#import "DDProgressWebVC.h"
#import "DsValue1TableViewCell.h"

@interface DsToolsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation DsToolsViewController

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[
                        @{@"title": @"百度",
                          @"detail": @"",
                          @"url": @"https://www.baidu.com",
                          @"imageUrl": @"baidu"
                          },
                        @{@"title": @"腾讯",
                          @"detail": @"",
                          @"url": @"https://www.qq.com",
                          @"imageUrl": @"tengxun"
                          }
                        ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DSLocalizedString(DS_HOME_CLOCK_TITLE);
    self.tableView.backgroundColor = DS_COLOR_HEXCOLOR(@"f1f1f1");
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellInd = @"123344444";
    DsValue1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInd];
    if (!cell) {
        cell = [[DsValue1TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellInd];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.infoDict = self.dataSource[indexPath.item];
    cell.accessoryImgV.hidden = self.dataSource.count != indexPath.item;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource[indexPath.item] && self.dataSource[indexPath.item][@"url"]) {
        NSString *url = self.dataSource[indexPath.item][@"url"];
        DDProgressWebVC *webVC = [[DDProgressWebVC alloc] initWithURL:url enabelProgress:YES];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.isPresent = NO;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.001, 10)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}





- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT - DS_APP_NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
