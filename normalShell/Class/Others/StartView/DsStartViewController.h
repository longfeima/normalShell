//
//  DsStartViewController.h
//  WBuild
//
//  Created by Seven on 2017/7/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsBaseViewController.h"

typedef NS_ENUM(NSUInteger, LanuchType) {
    LanuchTypeGuide,
    LanuchTypeSplashScreen,
};

@interface DsStartViewController : DsBaseViewController

@property (nonatomic, assign) LanuchType type;

@end


