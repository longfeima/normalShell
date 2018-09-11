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
#import "DsNoteTableViewCell.h"


#define curViewHeight self.view.frame.size.height - 49 - 64
#define KRedColor [UIColor redColor]
#define KBlueColor [UIColor blueColor]
#define CNavBgColor  [UIColor colorWithRed:133./256. green:205./256. blue:243./256. alpha:1.]
@interface DsNoteViewController ()<YSLDraggableCardContainerDelegate,YSLDraggableCardContainerDataSource, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (nonatomic,strong) CardView *noDataView;

@property (nonatomic, strong) UIImageView *noteImageV;

@property (nonatomic, strong) UIButton *styleBtn;


@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, assign) BOOL showEmpetyView;


@end

@implementation DsNoteViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    id dataArray = [[DsDatabaseManger shareManager] fetchNotes];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        NSArray *arr = [[DsDatabaseManger shareManager] fetchNotes];
        if ([arr isEqualToArray:_datas]) {
            return;
        }else{
            _datas = [NSMutableArray arrayWithArray:dataArray];
            id style =  [DsUtils fetchFromUserDefaultsWithKey:@"style"];
            if (style && [style isEqual:@(YES)]) {
                [self.tableView reloadData];
            }else{
                [self.container reloadCardContainer];
            }
        }
        id style =  [DsUtils fetchFromUserDefaultsWithKey:@"style"];
        if (style && [style isEqual:@(YES)]) {
            _noDataView.hidden = YES;
        }
        
    }else{
        id style =  [DsUtils fetchFromUserDefaultsWithKey:@"style"];
        if (style && [style isEqual:@(YES)]) {
            _noDataView.hidden = NO;
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.showEmpetyView = YES;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.styleBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    [self.styleBtn addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
    id style =  [DsUtils fetchFromUserDefaultsWithKey:@"style"];
    if (style && [style isEqual:@(YES)]) {
        self.styleBtn.selected = YES;
        [self configSelectStyle];
    }else{
        self.styleBtn.selected = NO;
        [self configNormalStyle];
    }
}
- (void)changeStyle:(UIButton *)btn{
    btn.selected = !btn.selected;
    [DsUtils write2UserDefaults:@(btn.selected) forKey:@"style"];
    if (btn.selected) {
        [self configSelectStyle];
    }else{
        [self configNormalStyle];
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    UserFeedBackViewController *vc = [[UserFeedBackViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//格子
- (void)configNormalStyle{
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    self.bgScrollView.backgroundColor = DS_COLOR_HEXCOLOR(@"f1f1f1");
    self.bgScrollView.contentSize = CGSizeMake(DS_APP_SIZE_WIDTH, 1000);
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.bgScrollView];
    [self initNoDataUI];
    [self initUI];
    [self.bgScrollView  bringSubviewToFront:self.noDataView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteTextClick)];
    [self.noDataView addGestureRecognizer:tap];
    if (self.datas.count <= 0) {
        return;
    }
    NSDictionary *imDict = self.datas[0];
    if ([imDict objectForKey:@"image"]) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[imDict objectForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            CGRect frame = self.container.frame;
            CGSize size = image.size;
            CGFloat H = (DS_APP_SIZE_WIDTH - 40) / size.width * size.height;
            self.noteImageV.frame = CGRectMake(20 , CGRectGetMaxY(frame) + 40, DS_APP_SIZE_WIDTH - 40, H);
        }
    }
    [self.bgScrollView addSubview:self.noteImageV];
    [self.bgScrollView sendSubviewToBack:self.noteImageV];
}

//列表
- (void)configSelectStyle{
//    [self.bgScrollView removeAllSubviews];
    [self.bgScrollView removeFromSuperview];
    self.bgScrollView = nil;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"1234344";
    DsNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[DsNoteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.infoDict = self.datas[indexPath.item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DsDetailTextViewController *vc = [[DsDetailTextViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dict = _datas[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}



///////////
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return DS_APP_ISIPHONE_4 ? - 63 : (DS_APP_ISIPHONE_5 ? -85 : -100);
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 31;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"emptyList"];
}

- (BOOL)emptyDataSetShouldDisplay {
    return self.showEmpetyView;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text =  @"您还没有开始写日记";
    
    NSDictionary *attributes = @{NSFontAttributeName: DS_APP_FONT(14),
                                 NSForegroundColorAttributeName: DS_COLOR_HEXCOLOR(@"bebebe")};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initNoDataUI{
    if (!_noDataView) {
        _noDataView = [[CardView alloc] initWithFrame:CGRectMake(10, 10 + DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH - 20, DS_APP_SIZE_WIDTH - 20)];
        _noDataView.titleLabel.text = DSLocalizedString(DS_NOTE_NOTES_TITLE);
        _noDataView.label.text = DSLocalizedString(DS_NOTE_NOTES_DETAIL);
        _noDataView.hidden = YES;
        _noDataView.backgroundColor = [UIColor whiteColor];
        _noDataView.userInteractionEnabled = YES;
        [self.bgScrollView addSubview:_noDataView];
        
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
    _container.frame = CGRectMake(0, 0,DS_APP_SIZE_WIDTH,  DS_APP_SIZE_WIDTH - 20);
    _container.backgroundColor = [UIColor clearColor];
    _container.userInteractionEnabled = YES;
    _container.dataSource = self;
    _container.delegate = self;
    //    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight | YSLDraggableDirectionUp;
    [self.bgScrollView addSubview:_container];
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
//        _noDataView.hidden = YES;
        self.showEmpetyView = YES;
    }else{
        self.showEmpetyView = NO;
//        _noDataView.hidden = NO;
    }
}

#pragma mark -- Selector


#pragma mark -- YSLDraggableCardContainer DataSource
// 根据index获取当前的view
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    NSDictionary *dict = _datas[index];
    CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    view.backgroundColor = [UIColor whiteColor];
    view.titleLabel.text = [dict objectForKey:@"title"];
    view.label.text = [dict objectForKey:@"text"];

    
    return view;
}

- (void)dragedAtIndex:(NSInteger)index{
    index = index >= self.datas.count ? 0 : index;
    NSDictionary *imDict = self.datas[index];
    if ([imDict objectForKey:@"image"]) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[imDict objectForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            CGRect frame = self.container.frame;
            CGSize size = image.size;
            CGFloat H = (DS_APP_SIZE_WIDTH - 40) / size.width * size.height;
            self.noteImageV.frame = CGRectMake(20 , CGRectGetMaxY(frame) + 40, DS_APP_SIZE_WIDTH - 40, H);
            self.noteImageV.image = image;
            
            self.noteImageV.hidden = NO;
        }else{
            self.noteImageV.hidden = YES;
        }
    }else{
        self.noteImageV.hidden = YES;
    }
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
    DsDetailTextViewController *vc = [[DsDetailTextViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dict = _datas[index];
    [self.navigationController pushViewController:vc animated:YES];
    //}
    NSLog(@"++ index : %ld",(long)index);
}

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT - DS_APP_NAV_HEIGHT - DS_APP_TAB_HEIGHT)];
        _bgScrollView.contentSize = CGSizeMake(DS_APP_SIZE_WIDTH, DS_APP_NAV_HEIGHT);
        _bgScrollView.emptyDataSetSource = self;
        _bgScrollView.emptyDataSetDelegate = self;
    }
    return _bgScrollView;
}

- (UIImageView *)noteImageV{
    if (!_noteImageV) {
        _noteImageV = [UIImageView new];
    }
    return _noteImageV;
}

- (UIButton *)styleBtn{
    if (!_styleBtn) {
        _styleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_styleBtn setTitle:DSLocalizedString(DS_NOTE_STYLE_LIST) forState:UIControlStateNormal];
        [_styleBtn setTitle:DSLocalizedString(DS_NOTE_STYLE_GRID) forState:UIControlStateSelected];
        _styleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_styleBtn setTitleColor:DS_COLOR_HEXCOLOR(@"333333") forState:UIControlStateNormal];
        [_styleBtn setTitleColor:DS_COLOR_HEXCOLOR(@"666666") forState:UIControlStateSelected];
        _styleBtn.selected = YES;
    }
    return _styleBtn;
}


//////
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT - DS_APP_NAV_HEIGHT - DS_APP_TAB_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}




@end

