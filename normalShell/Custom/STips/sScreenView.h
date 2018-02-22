//
//  sScreenView.h
//  sTips
//
//  Created by Seven on 2017/7/31.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "sTipsWindowProtocol.h"

@interface sScreenView : UIView<sTipsWindowProtocol>

@property (nonatomic, assign) id<sTipsWindowProtocol>delegate;


@property (nonatomic, strong) UILabel *tipLb;




- (void)showScreenWithLocaliteUrl:(NSString *)localiteUrl;

- (void)showScreenWithUrl:(NSURL *)imageUrl;



@end
