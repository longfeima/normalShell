//
//  DsHomeViewFunctionCell.m
//  DDService
//
//  Created by Seven on 2017/7/13.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsHomeViewFunctionCell.h"

@interface DsHomeViewFunctionCell ()

@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) UIImageView *headImageV;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *detailLb;


@end


@implementation DsHomeViewFunctionCell

- (instancetype)init{

    if (self = [super init]) {
        [self creatUI];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self confConstrain];
    }
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict{

    [self creatUI];
    [self confConstrain];
    
    self.titleLb.text = infoDict[@"title"];
    self.detailLb.text = infoDict[@"detail"];
    self.headImageV.image = [UIImage imageNamed:infoDict[@"imageUrl"]];
}








- (void)creatUI{
    [self bgImageV];
    [self headImageV];
    [self titleLb];
    [self detailLb];
    [self.contentView addSubview:self.bgImageV];
    [self.bgImageV addSubview:self.headImageV];
    [self.bgImageV addSubview:self.titleLb];
    [self.bgImageV addSubview:self.detailLb];

}

- (void)confConstrain{

    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0.5);
    }];
    
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageV);
        make.left.equalTo(self.bgImageV).offset(20);
        make.width.equalTo(@26);
        make.height.equalTo(@30);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageV.mas_right).offset(20);
        make.bottom.equalTo(self.bgImageV.mas_centerY).offset(-5);
        make.right.equalTo(self.bgImageV).offset(-10);
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
    }];
}




#pragma mark -----lazy


- (UIImageView *)bgImageV{

    if (!_bgImageV) {
        _bgImageV = [UIImageView new];
        _bgImageV.backgroundColor = [UIColor whiteColor];
    }
    return _bgImageV;
}

- (UIImageView *)headImageV{

    if (!_headImageV) {
        _headImageV = [UIImageView new];
    }
    return _headImageV;
}

- (UILabel *)titleLb{

    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = DS_APP_FONT(15);
        _titleLb.textColor = DS_COLOR_HEXCOLOR(@"3b3c4f");
        _titleLb.textAlignment = 0;
        
    }
    return _titleLb;
    
}
- (UILabel *)detailLb{

    if (!_detailLb) {
        _detailLb = [UILabel new];
        _detailLb.textAlignment = 0;
        _detailLb.numberOfLines = 0;
        _detailLb.textColor = DS_COLOR_HEXCOLOR(@"bbbbbb");
        _detailLb.font = DS_APP_FONT(12);
        
    }
    return _detailLb;
}





@end
