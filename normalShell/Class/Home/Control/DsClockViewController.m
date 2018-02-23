//
//  DsClockViewController.m
//  normalShell
//
//  Created by Seven on 2018/2/23.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsClockViewController.h"

#define BASETAG_BTN     221
#define BASETAG_SWT     999

@interface DsClockViewController ()

@property (nonatomic, strong) UIButton *clockBtn1;
@property (nonatomic, strong) UISwitch *switch1;

@property (nonatomic, strong) UIButton *clockBtn2;
@property (nonatomic, strong) UISwitch *switch2;

@property (nonatomic, strong) UIButton *clockBtn3;
@property (nonatomic, strong) UISwitch *switch3;

@property (nonatomic, strong) UIButton *currentClockBtn;
@property (nonatomic, strong) UISwitch *currentSwitch;

@end

@implementation DsClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationView.navType = DD_NormalType;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationView.title = @"闹钟";
    [self creatUI];
    [self configConstraint];
    [self configData];
}

- (void)configData{
    id dataArray = [[DsDatabaseManger shareManager] fetchClocks];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        NSArray *dateArray = (NSArray *)dataArray;
        for (int i = 0; i < dateArray.count; i++) {
            NSDictionary *dict =dateArray[i];
            UIButton *calendarBtn = [self.view viewWithTag:i + BASETAG_BTN];
            [calendarBtn setTitle:dict[@"date"] forState:UIControlStateNormal];
            UISwitch *clockSwitch = [self.view viewWithTag:i + BASETAG_SWT];
            clockSwitch.on = [dict[@"state"] intValue];
            calendarBtn.enabled = clockSwitch.isOn;
        }
    }else{
        NSMutableArray *tempArr = [NSMutableArray new];
        for (int i = 0; i<3; i++) {
            NSDictionary *dict = @{
                                   @"date": @"00:00",
                                   @"state": @"0"
                                   };
            [tempArr addObject:dict];
        }
        [[DsDatabaseManger shareManager] saveClocksWithArray:[NSArray arrayWithArray:tempArr]];
        self.clockBtn1.enabled = NO;
        self.clockBtn2.enabled = NO;
        self.clockBtn3.enabled = NO;
        [self.clockBtn1 setTitle:@"00:00" forState:UIControlStateNormal];
        [self.clockBtn2 setTitle:@"00:00" forState:UIControlStateNormal];
        [self.clockBtn3 setTitle:@"00:00" forState:UIControlStateNormal];
        
        self.switch1.on = NO;
        self.switch2.on = NO;
        self.switch3.on = NO;
    }
    
}

- (void)creatUI{
    [self.view addSubview:self.clockBtn1];
    self.clockBtn1.tag = BASETAG_BTN;
    [self.view addSubview:self.switch1];
    self.switch1.tag = BASETAG_SWT;
    
    [self.view addSubview:self.clockBtn2];
    self.clockBtn2.tag = BASETAG_BTN + 1;
    [self.view addSubview:self.switch2];
    self.switch2.tag = BASETAG_SWT + 1;
    
    [self.view addSubview:self.clockBtn3];
    self.clockBtn3.tag = BASETAG_BTN + 2;
    [self.view addSubview:self.switch3];
    self.switch3.tag = BASETAG_SWT + 2;
    
    [self.clockBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.clockBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    [self.clockBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.clockBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    [self.clockBtn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.clockBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    [self.switch1 addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    [self.switch2 addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    [self.switch3 addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    
    [self.clockBtn1 addTarget:self action:@selector(clockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.clockBtn2 addTarget:self action:@selector(clockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.clockBtn3 addTarget:self action:@selector(clockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clockBtnClick:(UIButton*)btn{
    NSInteger tab = btn.tag =BASETAG_BTN;
    
    
}

- (void)switchClick:(UISwitch *)swit{
    self.currentSwitch = swit;
    NSInteger tag = swit.tag - BASETAG_SWT + BASETAG_BTN;
    UIButton *btn = [self.view viewWithTag:tag];
    btn.enabled = swit.isOn;
    id dataArray = [[DsDatabaseManger shareManager] fetchClocks];
    NSMutableArray *mutable = [NSMutableArray arrayWithArray:(NSArray *)dataArray];
    
    NSDictionary *dict = @{
                           @"date": btn.titleLabel.text,
                           @"state": [NSString stringWithFormat:@"%i", swit.isOn]
                           };
    
    [mutable replaceObjectAtIndex:tag - BASETAG_BTN withObject:dict];
    [[DsDatabaseManger shareManager] saveClocksWithArray:mutable];
}

- (void)configConstraint{
    [self.clockBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DS_APP_NAV_HEIGHT + 10);
        make.left.equalTo(self.view).offset(30);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    
    [self.switch1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clockBtn1);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    
    UILabel *line1 = [UILabel new];
    [self.view addSubview:line1];
    line1.backgroundColor = [UIColor grayColor];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clockBtn1.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.height.equalTo(@0.5);
        make.width.equalTo(@(DS_APP_SIZE_WIDTH - 40));
    }];
    
    
    [self.clockBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.left.height.width.equalTo(self.clockBtn1);
    }];
    
    [self.switch2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clockBtn2);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    
    UILabel *line2 = [UILabel new];
    [self.view addSubview:line2];
    line2.backgroundColor = [UIColor grayColor];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clockBtn2.mas_bottom).offset(10);
        make.left.height.width.equalTo(line1);
    }];
    
    
    [self.clockBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.left.height.width.equalTo(self.clockBtn2);
    }];
    
    [self.switch3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clockBtn3);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    
    UILabel *line3 = [UILabel new];
    [self.view addSubview:line3];
    line3.backgroundColor = [UIColor grayColor];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clockBtn3.mas_bottom).offset(10);
        make.left.height.width.equalTo(line2);
    }];
    
    
    
}




#pragma mark ---lazy

- (UIButton *)clockBtn1{
    if (!_clockBtn1) {
        _clockBtn1 = [UIButton new];
    }
    return _clockBtn1;
}

- (UISwitch *)switch1{
    if (!_switch1) {
        _switch1 = [UISwitch new];
    }
    return _switch1;
}


- (UIButton *)clockBtn2{
    if (!_clockBtn2) {
        _clockBtn2 = [UIButton new];
    }
    return _clockBtn2;
}

- (UISwitch *)switch2{
    if (!_switch2) {
        _switch2 = [UISwitch new];
    }
    return _switch2;
}

- (UIButton *)clockBtn3{
    if (!_clockBtn3) {
        _clockBtn3 = [UIButton new];
    }
    return _clockBtn3;
}

- (UISwitch *)switch3{
    if (!_switch3) {
        _switch3 = [UISwitch new];
    }
    return _switch3;
}

@end
