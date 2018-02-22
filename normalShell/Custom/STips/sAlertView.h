//
//  sAlertView.h
//  sTips
//
//  Created by Seven on 2017/7/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sTipsWindowProtocol.h"

@interface sAlertView : UIView<sTipsWindowProtocol>

@property (nonatomic, assign) id<sTipsWindowProtocol>delegate;

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Cancel:(NSString *)cancel;


- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message Cancel:(NSString *)cancel Confirm:(NSString *)confirm;



@end
