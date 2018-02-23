//
//  DsMoreHeadView.h
//  DDService
//
//  Created by Seven on 2017/7/13.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DsMoreHeadView : UIView

@property (nonatomic, strong) UIImageView *headImagV;
@property (nonatomic, strong) void(^moreHeadeClickBlock)(NSInteger index);

@end
