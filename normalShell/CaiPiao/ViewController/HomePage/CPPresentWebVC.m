//
//  CPPresentWebVC.m
//  lottery
//
//  Created by wayne on 2017/5/9.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPPresentWebVC.h"

@interface CPPresentWebVC ()

@end

@implementation CPPresentWebVC

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
