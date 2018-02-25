//
//  DsDetailTextViewController.m
//  normalShell
//
//  Created by 孟博 on 2018/2/25.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsDetailTextViewController.h"

@interface DsDetailTextViewController ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *textLabel;
@end

@implementation DsDetailTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.title = [_dict objectForKey:@"title"];
    self.navigationView.navType = DD_NormalType;
    [self.view addSubview:self.textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(DS_APP_NAV_HEIGHT + 10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.text = [_dict objectForKey:@"text"];
    }
    return _textLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
