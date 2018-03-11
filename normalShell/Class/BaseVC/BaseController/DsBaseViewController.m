//
//  DsBaseViewController.m
//  WBuild
//
//  Created by Seven on 2017/7/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsBaseViewController.h"

@interface DsBaseViewController ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation DsBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.navigationController.navigationBarHidden = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self navigationView];
    
    self.view.backgroundColor = DS_COLOR_GLOBAL_BACKGROUND;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationView.navType = DD_DefaultType;
//    self.navigationView.title = DSLocalizedString(DS_HOME_CELL_NOTES_TITLE);
    self.title = DSLocalizedString(DS_HOME_CELL_NOTES_TITLE);
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.zPosition = -1;
    UIColor *startColor = DS_COLOR_HEXCOLOR(@"0x57C9E8");
    UIColor *endColor = DS_COLOR_HEXCOLOR(@"0x31ded8");
    self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    self.gradientLayer.startPoint = CGPointMake(0.3, 0.3);
    self.gradientLayer.endPoint = CGPointMake(1, 0.6);
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

- (void)setNeedShowColorLayer:(BOOL)needShowColorLayer {
    _needShowColorLayer = needShowColorLayer;
    if (!_needShowColorLayer) {
        [self.gradientLayer removeFromSuperlayer];
    } else {

    }
}

- (void)setupBackItem {
}

- (void)setupCloseItem {
    
}

- (void)setupSpecialBackItem {
}

- (void)setupSpecialCloseItem {
}


- (void)DDRightBarButtonItem{
    //    NSLog(@"点击了右边Btn");
}


- (void)DDRightBarLabelItemClick{
    //    NSLog(@"点击了右边label");
}


- (void)DDLeftBarButtonItemClick {
    [self back:nil];
}

- (void)back:(id)sender {
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)DDCloseBarLabelItemClick{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)endEditing:(id)sender {
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
