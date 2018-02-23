//
//  DsSeetingViewController.m
//  DDService
//
//  Created by Seven on 2018/2/20.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsSeetingViewController.h"

@interface DsSeetingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *logoutBtn;


@end


@implementation DsSeetingViewController


- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]initWithArray:@[
                                                             @{@"title": @"意见反馈",
                                                               @"detail": @"暂未开放"},
                                                             @{@"title": @"评论",
                                                               @"detail": @"暂未开放"},
                                                             @{@"title": @"夜间模式",
                                                               @"detail": @"暂未开放"},
                                                             @{@"title": @"清除缓存",
                                                               @"detail": @"暂未开放"}
                                                             ]];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tableView];
    
    self.navigationView.title = @"设置";
    self.navigationView.navType = DD_NormalType;
}



- (void)userLogout{

   
    
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellInd = @"cellInd";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInd];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellInd];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.item][@"title"];
    cell.detailTextLabel.textColor = self.dataSource[indexPath.item][@"detail"];
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DS_APP_SIZE_WIDTH, 100)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(view);
        make.height.equalTo(@45);
        make.width.equalTo(@(DS_APP_SIZE_WIDTH - 40));
    }];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count ?: 0;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---lazy


- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT - DS_APP_NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.001, 0.01)];
        _tableView.backgroundColor = DS_COLOR_HEXCOLOR(@"f1f1f1");
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)logoutBtn{

    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutBtn.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        _logoutBtn.layer.cornerRadius = 4.0f;
        _logoutBtn.clipsToBounds = YES;
        [_logoutBtn addTarget:self action:@selector(userLogout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}



@end
