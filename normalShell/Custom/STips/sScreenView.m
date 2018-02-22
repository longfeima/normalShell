//
//  sScreenView.m
//  sTips
//
//  Created by Seven on 2017/7/31.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "sScreenView.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#define DS_BASEIMAGV_TAG                52441


@interface sScreenView()

@property (nonatomic, strong) UIImageView *screenImageV;
@property (nonatomic, strong) UIImageView *cancelImageV;

@end


@implementation sScreenView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        [self creatConstraint];
    }
    return self;
}



- (void)creatUI{
    [self screenImageV];
    [self cancelImageV];
}

- (void)creatConstraint{

    [self.screenImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    [self.cancelImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self.screenImageV.mas_bottom);
        make.height.equalTo(@(40));
    }];
    
    
}


- (void)showScreenWithLocaliteUrl:(NSString *)localiteUrl{

    self.screenImageV.image = [UIImage imageNamed:localiteUrl];
    
}

- (void)showScreenWithUrl:(NSURL *)imageUrl{
    [self.screenImageV sd_setImageWithURL:imageUrl];

}


- (void)itemClick:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag - DS_BASEIMAGV_TAG;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sScreenViewClick:)]) {
        [self.delegate sScreenViewClick:tag?:-1];
    }
}




- (UIImageView *)screenImageV{
    if (!_screenImageV) {
        _screenImageV = [UIImageView new];
        _screenImageV.tag = DS_BASEIMAGV_TAG;
        _screenImageV.userInteractionEnabled = YES;
        [_screenImageV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
        _screenImageV.backgroundColor = [UIColor redColor];
        [self addSubview:_screenImageV];
    }
    return _screenImageV;
}

- (UIImageView *)cancelImageV{
    if (!_cancelImageV) {
        _cancelImageV = [UIImageView new];
        _cancelImageV.tag = DS_BASEIMAGV_TAG + 1;
        _cancelImageV.userInteractionEnabled = YES;
        [_cancelImageV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
        _cancelImageV.backgroundColor = [UIColor orangeColor];
        [self addSubview:_cancelImageV];
    }
    return _cancelImageV;
}



- (UILabel *)tipLb{
    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.textAlignment = 1;
        _tipLb.textColor = [UIColor grayColor];
        _tipLb.backgroundColor = [UIColor blueColor];
        _tipLb.bounds = CGRectMake(0, 0, 200, 30);
        _tipLb.center = CGPointMake(self.center.x, self.center.y + 60);
        [self addSubview:_tipLb];
    }
    return _tipLb;
}

@end
