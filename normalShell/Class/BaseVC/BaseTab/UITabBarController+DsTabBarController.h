//
//  UITabBarController+DsTabBarController.h
//  WBuild
//
//  Created by Seven on 2017/7/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (DsTabBarController)

/**快速添加视图控制器*/
- (void)addViewController:(UIViewController *)vc
                    title:(NSString *)title
                    image:(NSString *)image
              selectImage:(NSString *)selectImage;


@end
