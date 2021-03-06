//
//  DsNoteListViewController.m
//  normalShell
//
//  Created by Seven on 2018/2/23.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsNoteListViewController.h"

@interface DsNoteListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DsNoteListViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tableView];
//    self.navigationView.navType = DD_NormalType;
//    
//    self.navigationView.title = DSLocalizedString(DS_HOME_NOTE_TITLE);
    
    self.title = DSLocalizedString(DS_HOME_WEATHER_TITLE);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellInd = @"cellInd";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInd];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellInd];
    }
    cell.textLabel.text = @"123";
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
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
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
