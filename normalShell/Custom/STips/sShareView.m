//
//  sShareView.m
//  sTips
//
//  Created by Seven on 2017/7/24.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "sShareView.h"
#import <Masonry/Masonry.h>




///////////item

@interface sShareViewItem ()
@property (nonatomic, strong) UIImageView *logImageV;
@property (nonatomic, strong) UILabel *titleLb;
@end

@implementation sShareViewItem

- (instancetype)init{

    if (self = [super init]) {
//        [self creatUI];
//        [self creatConstrain];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     NorImage:(NSString *)norImage
                     PreImage:(NSString *)preImage
                        Title:(NSString *)title{

    if (self = [super initWithFrame:frame]) {        
        [self creatUI];
        [self creatConstrain];
        self.logImageV.image = [UIImage imageNamed:norImage];
        self.titleLb.text = title;
        
//        self.logImageV.backgroundColor = [UIColor yellowColor];
//        self.titleLb.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)creatConstrain{
 
    [self.logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.width.height.equalTo(@50);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logImageV);
        make.top.equalTo(self.logImageV.mas_bottom).offset(5);
        make.bottom.equalTo(self);
    }];
    
}


- (void)creatUI{
    [self addSubview:self.logImageV];
    [self addSubview:self.titleLb];
}



///////lazy
- (UIImageView *)logImageV{

    if (!_logImageV) {
        _logImageV = [UIImageView new];
//        _logImageV.backgroundColor = [UIColor redColor];
    }
    return _logImageV;
}

- (UILabel *)titleLb{

    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = 1;
        _titleLb.font = [UIFont systemFontOfSize:15];
        _titleLb.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.98];
    }
    return _titleLb;
}

@end


@interface sShareView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *cancelLb;


@property (nonatomic, strong) NSArray *shareLogsNormal;
@property (nonatomic, strong) NSArray *shareLogsPress;
@property (nonatomic, strong) NSArray *shareTitles;

@end


#define DS_BASEITEM_TAG                         255134
@implementation sShareView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    [self backgroundView];
    [self cancelLb];
}

- (void)confWithArray:(NSArray<NSArray<NSString *> *> *)confArr{
    self.shareLogsNormal = [confArr[0] mutableCopy];
    self.shareLogsPress = [confArr[1] mutableCopy];
    self.shareTitles = [confArr[2] mutableCopy];
    NSInteger maxCount = MAX(MAX(self.shareLogsNormal.count, self.shareLogsPress.count), self.shareTitles.count);
    CGFloat hight = DS_SHARE_ITEMHIGHT;
    NSInteger itemsPerRow = DS_SHARE_ITEMS_PREROW;
    CGFloat width = self.frame.size.width/itemsPerRow;
    for (int i = 0; i < maxCount; i++) {
        sShareViewItem *item = [[sShareViewItem alloc]initWithFrame:CGRectMake(width * (i%itemsPerRow),5 + hight * (i/itemsPerRow), width, hight)
                                                           NorImage: i<self.shareLogsNormal.count?self.shareLogsNormal[i]:@""
                                                           PreImage: i<self.shareLogsPress.count?self.shareLogsPress[i]:@""
                                                              Title: i<self.shareTitles.count?self.shareTitles[i]:@""];
        item.tag = DS_BASEITEM_TAG + i + 1;
        [item addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
        [self.backgroundView addSubview:item];
    }
}

- (void)itemClick:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag - DS_BASEITEM_TAG;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sShareViewSelectIndex:)]) {
        [self.delegate sShareViewSelectIndex:tag?:-1];
    }
}


//lazy========
- (UIView *)backgroundView{
    
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _backgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.98];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}
- (UILabel *)cancelLb{
    if (!_cancelLb) {
        _cancelLb = [[UILabel alloc]initWithFrame:CGRectMake(0, self.backgroundView.frame.size.height - DS_SHARE_CANCELHIGHT, self.backgroundView.frame.size.width, DS_SHARE_CANCELHIGHT)];
        _cancelLb.text = @"取消";
        _cancelLb.backgroundColor = [UIColor whiteColor];
        _cancelLb.font = [UIFont systemFontOfSize:15];
        _cancelLb.textColor = [UIColor redColor];
        _cancelLb.tag = DS_BASEITEM_TAG;
        _cancelLb.textAlignment = 1;
        _cancelLb.userInteractionEnabled = YES;
        [_cancelLb addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
        [self.backgroundView addSubview:_cancelLb];
    }
    return _cancelLb;
}

@end
