//
//  DsNoteTableViewCell.m
//  normalShell
//
//  Created by 龙飞马 on 2018/9/3.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsNoteTableViewCell.h"


@interface DsNoteTableViewCell()


@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *detailLb;

@property (nonatomic, strong) UILabel *timeLb;


@property (nonatomic, strong) UIImageView *noteImageV;


@end


@implementation DsNoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatUI];
        [self confConstrain];
    }
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict{
    self.buttomLine.hidden = YES;
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    form.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[infoDict[@"ID"] doubleValue]];
    NSString *dateS = [form stringFromDate:date];
    self.timeLb.text = dateS;
    self.titleLb.text = infoDict[@"title"];
    
    
    self.detailLb.text = infoDict[@"text"];
    self.noteImageV.image = [UIImage imageNamed:@"1.jpg"];
    if ([infoDict objectForKey:@"image"]) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[infoDict objectForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            self.noteImageV.image = image;
        }
    }
}



- (void)creatUI{
    
    [self.contentView addSubview:self.topLine];
    
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.detailLb];
    
    [self.contentView addSubview:self.noteImageV];
    [self.contentView addSubview:self.buttomLine];
    
    [self.contentView addSubview:self.buttomLine];
    
}

- (void)confConstrain{
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0.25);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-120);
    }];
    
    
    
    [self.noteImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.width.equalTo(@80);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.noteImageV.mas_left).offset(-7);
        make.bottom.equalTo(self.titleLb);
    }];
    
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        make.left.equalTo(self.titleLb);
        make.right.equalTo(self.noteImageV.mas_left).offset(-10);
        make.bottom.mas_lessThanOrEqualTo(self.contentView).offset(-10);
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



- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = 0;
        _titleLb.textColor = DS_COLOR_HEXCOLOR(@"333333");
        _titleLb.font = DS_APP_FONT(15);
    }
    return _titleLb;
}

- (UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        _detailLb.textAlignment = 0;
        _detailLb.numberOfLines = 0;
        _detailLb.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLb.textColor = DS_COLOR_HEXCOLOR(@"666666");
        _detailLb.font = DS_APP_FONT(13);
    }
    return _detailLb;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.textAlignment = 2;
        _timeLb.textColor = DS_COLOR_HEXCOLOR(@"999999");
        _timeLb.font = [UIFont systemFontOfSize:12];
    }
    return _timeLb;
}


- (UIImageView *)noteImageV{
    if (!_noteImageV) {
        _noteImageV = [UIImageView new];
        _noteImageV.layer.cornerRadius = 2.0f;
        _noteImageV.contentMode = UIViewContentModeScaleAspectFit;
        _noteImageV.clipsToBounds = YES;
    }
    return _noteImageV;
}



- (UILabel *)buttomLine{
    
    if (!_buttomLine) {
        _buttomLine = [UILabel new];
        _buttomLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _buttomLine;
}





@end
