//
//  DsMoreHeadView.m
//  DDService
//
//  Created by Seven on 2017/7/13.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsMoreHeadView.h"



@interface DsMoreHeadView ()


@property (nonatomic, strong) UILabel *testLb;

@end


@implementation DsMoreHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
        [self creatUI];
        self.userInteractionEnabled = YES;
        [self confConstrain];
    }
    return self;
}

- (void)creatUI{
    
    [self addSubview:self.headImagV];
    [self addSubview:self.testLb];
    self.testLb.text = @"";
    self.testLb.textColor = DS_COLOR_HEXCOLOR(@"bbbbbb");
    self.headImagV.clipsToBounds = YES;
    self.headImagV.layer.cornerRadius = 50;
    self.headImagV.image = [UIImage imageNamed:@"1.jpg"];

}

- (void)confConstrain{
    
    [self.headImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.equalTo(@100);
    }];
    
    [self.testLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImagV.mas_bottom).offset(10);
        make.centerX.equalTo(self.headImagV);
    }];
    
}

- (void)subviewClick:(UITapGestureRecognizer *)tap{
// 1点击头像 2点击lb
    if (tap.view == self.headImagV) {
        self.moreHeadeClickBlock(1);
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    UIView *result = [super hitTest:point withEvent:event];
    if (result == self) {
        return nil;
    } else {
        return result;
    }
    
}







#pragma mark -----lazy

- (UIImageView *)headImagV{

    if (!_headImagV) {
        _headImagV = [UIImageView new];
        _headImagV.backgroundColor = [UIColor orangeColor];
        _headImagV.userInteractionEnabled = YES;
        [_headImagV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(subviewClick:)]];
    }
    return _headImagV;
    
}

- (UILabel *)testLb{
    
    if (!_testLb) {
        _testLb = [UILabel new];
        _testLb.textAlignment = 1;
        _testLb.textColor = [UIColor  whiteColor];
        _testLb.font = [UIFont systemFontOfSize:19];
    }
    return _testLb;
}


@end
