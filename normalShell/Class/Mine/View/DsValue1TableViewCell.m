//
//  DsValue1TableViewCell.m
//  DDService
//
//  Created by Seven on 2017/7/19.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsValue1TableViewCell.h"

@interface DsValue1TableViewCell ()



@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *detailLb;



@end


@implementation DsValue1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//self.accessoryType
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatUI];
        [self confConstrain];
        // Initialization code
        
        
        
    }
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict{

//    self.topLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
//    self.buttomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.buttomLine.hidden = YES;
    
    self.headImgV.image = [UIImage imageNamed:infoDict[@"imageUrl"]];
    self.titleLb.text = infoDict[@"title"];
    self.detailLb.text = infoDict[@"detail"];
    
}



- (void)creatUI{

    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.headImgV];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.accessoryImgV];
    [self.contentView addSubview:self.buttomLine];
    
}

- (void)confConstrain{

    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0.25);
    }];
    
    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@26);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgV.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.accessoryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@8);
        make.height.equalTo(@16);
    }];
    
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accessoryImgV.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.buttomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0.25);
    }];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






#pragma mark ---lazy

- (UILabel *)topLine{

    if (!_topLine) {
        _topLine = [UILabel new];
        _topLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
    }
    return _topLine;
}

- (UIImageView *)headImgV{

    if (!_headImgV) {
        _headImgV = [UIImageView  new];
    }
    return _headImgV;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = 0;
        _titleLb.textColor = DS_COLOR_HEXCOLOR(@"3b3c4e");
        _titleLb.font = DS_APP_FONT(16);
    }
    return _titleLb;
}

- (UILabel *)detailLb{

    if (!_detailLb) {
        _detailLb = [UILabel new];
        _detailLb.textAlignment = 2;
        _detailLb.textColor = DS_COLOR_HEXCOLOR(@"bbbbbb");
        _detailLb.font = DS_APP_FONT(14);
    }
    return _detailLb;
}

- (UIImageView *)accessoryImgV{

    if (!_accessoryImgV) {
        _accessoryImgV = [UIImageView new];
        _accessoryImgV.image = [UIImage imageNamed:@"icon_arrow"];
    }
    return _accessoryImgV;
}

- (UILabel *)buttomLine{

    if (!_buttomLine) {
        _buttomLine = [UILabel new];
        _buttomLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _buttomLine;
}






@end
