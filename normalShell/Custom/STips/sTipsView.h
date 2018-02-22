//
//  sTipsView.h
//  sTips
//
//  Created by Seven on 2017/7/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "sTipsWindowProtocol.h"

@interface sTipsView : UIView<sTipsWindowProtocol>

@property (nonatomic, assign) id<sTipsWindowProtocol>delegate;
@property (nonatomic, strong) UILabel *tipLb;
@property (nonatomic, strong) UIImageView *tipImV;
- (void)sTipsViewClick;

@end

