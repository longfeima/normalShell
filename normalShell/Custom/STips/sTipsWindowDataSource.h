//
//  sTipsWindowDelegate.h
//  sTips
//
//  Created by Seven on 2017/7/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>


typedef enum : NSUInteger {
    Ds_Show_Top,
    Ds_Show_Center,
    Ds_Show_Buttom,
} DsShowScreenType;

@protocol sTipsWindowDataSource <NSObject>


- (void)showTipsWithCustomView:(UIView*)customView Type:(DsShowScreenType)type;


@end
