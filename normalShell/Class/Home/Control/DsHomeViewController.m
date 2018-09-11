//
//  DsHomeViewController.m
//  normalShell
//
//  Created by Seven on 2018/2/22.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsHomeViewController.h"
#import "DsHomeHeadView.h"
#import "DsCustomCollectionView.h"

#import "DsHomeViewFunctionCell.h"

#import "DsCalendarViewController.h"
#import "DsClockViewController.h"
#import "DsToolsViewController.h"
#import "DsNoteListViewController.h"
#import "DsWeatherViewController.h"
#import "UserFeedBackViewController.h"
#import "DsWeatherViewController1.h"
@interface DsHomeViewController ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) DsHomeHeadView *headerView;
@property (nonatomic, strong) DsCustomCollectionView *functinoCollectionView;


@end

@implementation DsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DS_COLOR_HEXCOLOR(@"f1f1f1");
//    self.navigationView.title = DSLocalizedString(DS_HOME_TITLE);
    self.title = DSLocalizedString(DS_HOME_TITLE);
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    DS_APP_DELEGATE.rootTab.selectedIndex = 0;
    [self.headerView reloadData];
}

- (void)creatUI{
    self.bgScrollView.contentSize = CGSizeMake(DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT * 1.2);
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.headerView = [[DsHomeHeadView alloc]initWithFrame:CGRectMake(0, 0, DS_APP_SIZE_WIDTH, 210 * DS_APP_SIZE_SCALE)];
    [self.bgScrollView addSubview:self.headerView];
    
    
    
    NSArray *testInfo = @[
                          @{@"title": DSLocalizedString(DS_HOME_CELL_NOTES_TITLE),
                            @"detail": DSLocalizedString(DS_HOME_CELL_NOTES_DETAIL),
                            @"imageUrl": @"note"
                            },
                          @{@"title": DSLocalizedString(DS_HOME_CELL_CLOCK_TITLE),
                            @"detail": DSLocalizedString(DS_HOME_CELL_CLOCK_DETAIL),
                            @"imageUrl": @"clock"}
//                          ,
//                          @{@"title": DSLocalizedString(DS_HOME_CELL_CALENDAR_TITLE),
//                            @"detail": DSLocalizedString(DS_HOME_CELL_CALENDAR_DETAIL),
//                            @"imageUrl": @"calendar"},
//                          @{@"title": DSLocalizedString(DS_HOME_CELL_WEATHER_TITLE),
//                            @"detail": DSLocalizedString(DS_HOME_CELL_WEATHER_DETAIL),
//                            @"imageUrl": @"weather"}
                          ];
    self.functinoCollectionView = [[DsCustomCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + 10, DS_APP_SIZE_WIDTH, testInfo.count * 100) AndItemIndetifications:@[@"DsHomeViewFunctionCell"]];
    [self.bgScrollView addSubview:self.functinoCollectionView];
    self.functinoCollectionView.scrollEnabled = NO;
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
            UserFeedBackViewController *vc = [[UserFeedBackViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            DsToolsViewController *vc = [[DsToolsViewController alloc]init];
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
            DsWeatherViewController1 *desweather = [[DsWeatherViewController1 alloc] init];
            desweather.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:desweather animated:YES];
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
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(DS_APP_NAV_HEIGHT);
            make. bottom.equalTo(self.view).offset(-DS_APP_TAB_HEIGHT);
        }];
    }
    return _bgScrollView;
}







@end
