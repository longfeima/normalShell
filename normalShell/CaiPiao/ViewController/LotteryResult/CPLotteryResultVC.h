//
//  CPLotteryResultVC.h
//  lottery
//
//  Created by wayne on 2017/6/25.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBaseViewController.h"

@interface CPLotteryResultVC : CPBaseViewController

@property(nonatomic,assign)BOOL isLoadView;


-(void)goToResultDetailWithGid:(NSString *)gid
                       dayType:(int)dayType
            isShowPushAnimated:(BOOL)animated;
@end
