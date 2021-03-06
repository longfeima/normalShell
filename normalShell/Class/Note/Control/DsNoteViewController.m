//
//  DsNoteViewController.m
//  normalShell
//
//  Created by Seven on 2018/2/22.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsNoteViewController.h"
#import "YSLDraggableCardContainer.h"
#import "CardView.h"
#import "DsWeatherViewController1.h"
#import "UserFeedBackViewController.h"
#import "DsDetailTextViewController.h"
#define curViewHeight self.view.frame.size.height - 49 - 64
#define KRedColor [UIColor redColor]
#define KBlueColor [UIColor blueColor]
#define CNavBgColor  [UIColor colorWithRed:133./256. green:205./256. blue:243./256. alpha:1.]
@interface DsNoteViewController ()<YSLDraggableCardContainerDelegate,YSLDraggableCardContainerDataSource>

@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (nonatomic,strong) CardView *noDataView;
@end

@implementation DsNoteViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initUI];
    [self.view  bringSubviewToFront:self.noDataView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor yellowColor];
    [self initNoDataUI];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteTextClick)];
    [self.noDataView addGestureRecognizer:tap];
}
- (void)initNoDataUI{
    if (!_noDataView) {
        _noDataView = [[CardView alloc] initWithFrame:CGRectMake(10, 10 + DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH - 20, DS_APP_SIZE_WIDTH - 20)];
        _noDataView.titleLabel.text = DSLocalizedString(DS_NOTE_NOTES_TITLE);
        _noDataView.label.text = DSLocalizedString(DS_NOTE_NOTES_DETAIL);
        _noDataView.hidden = YES;
        _noDataView.backgroundColor = [UIColor whiteColor];
        _noDataView.userInteractionEnabled = YES;
        [self.view addSubview:_noDataView];
        
    }
}
- (void)noteTextClick{
    UserFeedBackViewController *vc = [[UserFeedBackViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ————— 创建UI界面 —————
-(void)initUI{
    // 创建 _container
    _container = [[YSLDraggableCardContainer alloc]init];
    _container.frame = CGRectMake(0, DS_APP_NAV_HEIGHT,DS_APP_SIZE_WIDTH, curViewHeight);
    _container.backgroundColor = [UIColor clearColor];
    _container.userInteractionEnabled = YES;
    _container.dataSource = self;
    _container.delegate = self;
    //    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight | YSLDraggableDirectionUp;
    [self.view addSubview:_container];
    
    // 创建上下左右四个按钮
    for (int i = 0; i < 4; i++) {
        
        UIView *view = [[UIView alloc]init];
        CGFloat size = self.view.frame.size.width / 4;
        view.frame = CGRectMake(size * i, curViewHeight - kTabBarHeight - size, size, size);
        //        view.backgroundColor = [UIColor darkGrayColor];
        [self.view addSubview:view];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, size - 20, size - 20);
        [button setBackgroundColor:CNavBgColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:18];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = button.frame.size.width / 2;
        button.tag = i;
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        if (i == 0) { [button setTitle:DSLocalizedString(DS_NOTE_BTN_UP) forState:UIControlStateNormal]; }
        if (i == 1) { [button setTitle:DSLocalizedString(DS_NOTE_BTN_DOWN) forState:UIControlStateNormal]; }
        if (i == 2) { [button setTitle:DSLocalizedString(DS_NOTE_BTN_LEFT) forState:UIControlStateNormal]; }
        if (i == 3) { [button setTitle:DSLocalizedString(DS_NOTE_BTN_RIGHT) forState:UIControlStateNormal]; }
    }
    
    // 获取数据
    [self loadData];
    
    // 给_container赋值
    [_container reloadCardContainer];
    
}
- (void)loadData
{
    
    id dataArray = [[DsDatabaseManger shareManager] fetchNotes];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        _datas = [NSMutableArray arrayWithArray:dataArray];
        _noDataView.hidden = YES;
    }else{
        _noDataView.hidden = NO;
    }
    //    _datas = [NSMutableArray array];
    
    //    for (int i = 0; i < 20; i++) {
    //        NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"photo_sample_0%d",i%7 + 1],
    //                               @"name" : @"YSLDraggableCardContainer Demo"};
    //        [_datas addObject:dict];
    //    }
}

#pragma mark -- Selector
- (void)buttonTap:(UIButton *)button
{
    if (_datas.count == 0) {
        return;
    }
    if (button.tag == 0) {
        [_container movePositionWithDirection:YSLDraggableDirectionUp isAutomatic:YES];
    }
    if (button.tag == 1) {
        
        __weak typeof(self) weak_self=self;
        [_container movePositionWithDirection:YSLDraggableDirectionDown isAutomatic:YES undoHandler:^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@"Do you want to reset?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weak_self.container movePositionWithDirection:YSLDraggableDirectionDown isAutomatic:YES];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [weak_self.container movePositionWithDirection:YSLDraggableDirectionDefault isAutomatic:YES];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        
    }
    if (button.tag == 2) {
        [_container movePositionWithDirection:YSLDraggableDirectionLeft isAutomatic:YES];
    }
    if (button.tag == 3) {
        [_container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:YES];
    }
}

#pragma mark -- YSLDraggableCardContainer DataSource
// 根据index获取当前的view
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    NSDictionary *dict = _datas[index];
    CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    view.backgroundColor = [UIColor whiteColor];
    //    view.imageView.image = [UIImage imageNamed:dict[@"image"]];
    //    view.label.text = [NSString stringWithFormat:@"%@  %ld",dict[@"name"],(long)index];
    
    //    if (_datas.count == 0) {
    //        view.titleLabel.text = @"您还没记录任何事件!";
    //        view.label.text = @"记录您的精彩瞬间吧......";
    //    }else{
    view.titleLabel.text = [dict objectForKey:@"title"];
    view.label.text = [dict objectForKey:@"text"];
    //    }
    return view;
}

// 获取view的个数
- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    //    if (_datas.count == 0) {
    //        return 1;
    //    }
    return _datas.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
// 滑动view结束后调用这个方法
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection
{
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionDown) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

// 更新view的状态, 滑动中会调用这个方法
- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
    CardView *view = (CardView *)draggableView;
    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        view.selectedView.backgroundColor = KRedColor;
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        view.selectedView.backgroundColor = KBlueColor;
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        view.selectedView.backgroundColor = [UIColor grayColor];
        view.selectedView.alpha = heightRatio > 0.8 ? 0.8 : heightRatio;
    }
}


// 所有卡片拖动完成后调用这个方法
- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container reloadCardContainer];
    });
}


// 点击view调用这个
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView
{
    //    if (_datas.count == 0) {
    //        UserFeedBackViewController *vc = [[UserFeedBackViewController alloc] init];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }else{
    DsDetailTextViewController *vc = [[DsDetailTextViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dict = _datas[index];
    [self.navigationController pushViewController:vc animated:YES];
    //}
    NSLog(@"++ index : %ld",(long)index);
}


@end

