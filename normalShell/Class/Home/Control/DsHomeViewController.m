//
//  DsHomeViewController.m
//  normalShell
//
//  Created by Seven on 2018/2/22.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsHomeViewController.h"
#import "DsHomeHeadView.h"
#import "DDCustomCollectionView.h"

#import "DsHomeViewFunctionCell.h"

#import "DsCalendarViewController.h"
#import "DsClockViewController.h"
#import "DsNoteListViewController.h"
#import "DsWeatherViewController.h"


@interface DsHomeViewController ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) DsHomeHeadView *headerView;
@property (nonatomic, strong) DDCustomCollectionView *functinoCollectionView;


@end

@implementation DsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationView.title = DSLocalizedString(DS_HOME_TITLE);
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    DS_APP_DELEGATE.rootTab.selectIndex = 0;
}

- (void)creatUI{
    self.bgScrollView.contentSize = CGSizeMake(DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT * 1.2);
    self.headerView = [[DsHomeHeadView alloc]initWithFrame:CGRectMake(0, 0, DS_APP_SIZE_WIDTH, 210 * DS_APP_SIZE_SCALE)];
    [self.bgScrollView addSubview:self.headerView];
    
    
    
    NSArray *testInfo = @[
                          @{@"title": @"我的及时本",
                            @"detail": @"记录时刻"},
                          @{@"title": @"闹钟",
                            @"detail": @"我的时间"},
                          @{@"title": @"日历",
                            @"detail": @"我的日程"},
                          @{@"title": @"天气",
                            @"detail": @"我的天气"}
                          ];
    self.functinoCollectionView = [[DDCustomCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + 10, DS_APP_SIZE_WIDTH, testInfo.count * 100) AndItemIndetifications:@[@"DsHomeViewFunctionCell"]];
    [self.bgScrollView addSubview:self.functinoCollectionView];
    self.functinoCollectionView.itemsArray = @[@"DsHomeViewFunctionCell",
                                               @"DsHomeViewFunctionCell",
                                               @"DsHomeViewFunctionCell",
                                               @"DsHomeViewFunctionCell"];
    self.functinoCollectionView.itemsSize = CGSizeMake(DS_APP_SIZE_WIDTH, 99.9);
    self.functinoCollectionView.scrollDirection = DDCollectionViewScrollDirectionVertical;
    self.functinoCollectionView.cellType = DDCollectionViewCellDefaultType;
    self.functinoCollectionView.edgeInsetMake = UIEdgeInsetsMake(0, 0.1, 0.1, 0.1);
    __weak DsHomeViewController *weakSelf = self;
    self.functinoCollectionView.DDCustomCollectionBlock = ^(id cell, NSIndexPath *index) {
        
        DsHomeViewFunctionCell *ce = (DsHomeViewFunctionCell *)cell;
        if (index && index.row < testInfo.count) {
            ce.infoDict = testInfo[index.row];
        }
    };
    self.functinoCollectionView.DDCollectionSelectIndex = ^(NSIndexPath *index) {
        //        if (index.item == 0) {
        //            DsLoginViewController *login = [[DsLoginViewController alloc]init];
        //            login.isPresent = YES;
        //            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        //            [weakSelf presentViewController:nav animated:YES completion:nil];
        //            return ;
        //        }
        [weakSelf itemsClickAtIndex:index.item];
        
    };
    
}



- (void)itemsClickAtIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            DsNoteListViewController *vc = [[DsNoteListViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
            DsClockViewController *vc = [[DsClockViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            DsCalendarViewController *vc = [[DsCalendarViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            DsWeatherViewController *vc = [[DsWeatherViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
}












//lazy

-(UIScrollView *)bgScrollView{
    
    if (!_bgScrollView) {
        _bgScrollView = [UIScrollView new];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bgScrollView];
        [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.mas_equalTo(self.view);
            make.top.left.right.equalTo(self.view);
            make. bottom.equalTo(self.view).offset(-64);
        }];
    }
    return _bgScrollView;
}







@end
