//
//  CardView.h
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLCardView.h"
typedef enum : NSUInteger {
    Ds_Normal,
    Ds_Special,
} CardView_Type;
@interface CardView : YSLCardView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) CardView_Type type;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
