//
//  sTipsView.m
//  sTips
//
//  Created by Seven on 2017/7/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "sTipsView.h"






@interface sTipsView ()
@end

@implementation sTipsView



- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        [self confConstrain];
    }
    return self;
}

- (void)creatUI{
    [self tipLb];
    [self tipImV];
}
- (void)confConstrain{

    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-20);
        make.width.mas_lessThanOrEqualTo(self.frame.size.width - 50);
    }];
    
    [self.tipImV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipLb);
        make.width.height.equalTo(@20);
        make.right.equalTo(self.tipLb.mas_left).offset(-5);
    }];
    
}



- (void)tipClick:(UITapGestureRecognizer *)tap{

    if (self.delegate && [self.delegate respondsToSelector:@selector(sTipsViewClick)]) {
        [self.delegate sTipsViewClick];
    }
}

- (UILabel *)tipLb{

    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.textAlignment = 1;
        _tipLb.textColor = DS_COLOR_HEXCOLOR(@"ffffff");
        _tipLb.numberOfLines = 0;
        _tipLb.font = DS_APP_FONT_LIGHT(14);
        _tipLb.backgroundColor = [UIColor clearColor];
//        _tipLb.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        _tipLb.center = CGPointMake(self.center.x, self.center.y + 70);
        _tipLb.userInteractionEnabled = YES;
        [_tipLb addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipClick:)]];
        [self addSubview:_tipLb];
    }
    return _tipLb;
}

- (UIImageView *)tipImV{
    if (!_tipImV) {
        _tipImV = [UIImageView new];
        _tipImV.backgroundColor = [UIColor clearColor];
        [self addSubview:_tipImV];
    }
    return _tipImV;
}



@end
