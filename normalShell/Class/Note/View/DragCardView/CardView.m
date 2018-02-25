//
//  CardView.m
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "CardView.h"
@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
//    _imageView = [[UIImageView alloc]init];
//    _imageView.backgroundColor = [UIColor orangeColor];
//    _imageView.hidden = YES;
//    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8);
//    [self addSubview:_imageView];
//
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
//                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                           cornerRadii:CGSizeMake(7.0, 7.0)];
//
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _imageView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _imageView.layer.mask = maskLayer;
//
//    _selectedView = [[UIView alloc]init];
//    _selectedView.frame = _imageView.frame;
//    _selectedView.backgroundColor = [UIColor clearColor];
//    _selectedView.alpha = 0.0;
//    [_imageView addSubview:_selectedView];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:24];
    _titleLabel.textColor = DS_COLOR_HEXCOLOR(@"3b3c4f");
    [self addSubview:_titleLabel];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(self);
    }];
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:133./256. green:205./256. blue:243./256. alpha:1.];
    [self addSubview:_lineView];
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    _label = [[UILabel alloc]init];
    _label.backgroundColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = DS_COLOR_HEXCOLOR(@"bbbbbb");
//    _label.frame = CGRectMake(10, self.frame.size.height * 0.8, self.frame.size.width - 20, self.frame.size.height * 0.2);
//    _label.frame = self.frame;
    _label.numberOfLines = 0;
    _label.font = [UIFont fontWithName:@"Futura-Medium" size:14];
    [self addSubview:_label];
    [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom).offset(10);
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(self).offset(-10);
//        make.height.mas_lessThanOrEqualTo(self.height - 20);
    }];
    _imageView.userInteractionEnabled = YES;
    _label.userInteractionEnabled = YES;
    _titleLabel.userInteractionEnabled = YES;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
