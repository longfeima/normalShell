//
//  UITabBarController+DsTabBarController.m
//  WBuild
//
//  Created by Seven on 2017/7/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "UITabBarController+DsTabBarController.h"

@implementation UITabBarController (DsTabBarController)


- (void)addViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    vc.title = title;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    UIImage *imageNormal = [UIImage imageNamed:image];
    UIImage *imageSelect = [UIImage imageNamed:selectImage];
    nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:imageNormal selectedImage:imageSelect];
    [self addChildViewController:nav];
}


@end
