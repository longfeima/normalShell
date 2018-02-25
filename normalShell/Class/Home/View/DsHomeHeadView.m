//
//  DsHomeHeadView.m
//  DDService
//
//  Created by Seven on 2017/7/13.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsHomeHeadView.h"
#import "CardView.h"
#import "UserFeedBackViewController.h"
#import "DsDetailTextViewController.h"
#import "UIView+KFGetController.h"
@interface DsHomeHeadView ()
@property (nonatomic,copy)NSArray *dataArr;
@property (nonatomic)BOOL IsNoNotes;
@property (nonatomic,strong) CardView *carview;

@end


@implementation DsHomeHeadView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        UIImage *image = [UIImage imageNamed:@"bg_recommend_blue"];
        [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        self.userInteractionEnabled = YES;
        self.image = image;
        [self creatUI];
        [self confConstrain];
        [self initHeaderview];
    }
    return self;
}
- (void)initHeaderview{
//    CardView *carview = [[CardView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    carview.backgroundColor = [UIColor whiteColor];
//    _IsNoNotes = YES;
//    NSDictionary *dict;
//    id dataArray = [[DsDatabaseManger shareManager] fetchNotes];
//    if ([dataArray isKindOfClass:[NSArray class]]) {
//        _dataArr = (NSArray*)dataArray;
//        dict = [_dataArr objectAtIndex:0];
//        _IsNoNotes = NO;
//    }else{
//        _IsNoNotes = YES;
//        dict = @{@"title":@"您还没记录任何事件!",@"text":@"开始记录您的精彩瞬间吧......"};
//    }
//    carview.titleLabel.text = dict[@"title"];
//    carview.label.text = dict[@"text"];
//    [self addSubview:carview];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteTextClick)];
//    [carview addGestureRecognizer:tap];
    
}
- (void)reloadData{
    if (!_carview) {
        _carview = [[CardView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height + 10)];
        _carview.backgroundColor = [UIColor whiteColor];
    }
    _IsNoNotes = YES;
    NSDictionary *dict;
    id dataArray = [[DsDatabaseManger shareManager] fetchNotes];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        _dataArr = (NSArray*)dataArray;
        dict = [_dataArr objectAtIndex:0];
        _IsNoNotes = NO;
    }else{
        _IsNoNotes = YES;
        dict = @{@"title":@"您还没记录任何事件!",@"text":@"开始记录您的精彩瞬间吧......"};
    }
    _carview.titleLabel.text = dict[@"title"];
    _carview.label.text = dict[@"text"];
    [self addSubview:_carview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteTextClick)];
    [_carview addGestureRecognizer:tap];
}
- (void)noteTextClick{
    if (!_IsNoNotes) {
        DsDetailTextViewController *vc = [[DsDetailTextViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.dict = [_dataArr objectAtIndex:0];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else{
    UserFeedBackViewController *vc = [[UserFeedBackViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}
- (void)creatUI{

    self.dataSource = [NSArray new];//@[@13, @20, @17, @20];
    self.describeSource = [NSArray new];//@[@"helllo",@"HI",@"hhha",@"dsfhak"];

    
}

- (void)confConstrain{
    
    
}

- (void)setDataSource:(NSArray *)dataSource{

    _dataSource = dataSource;
    
    
}
- (void)setDescribeSource:(NSArray<NSString *> *)describeSource{
    _describeSource = describeSource;
    
}

- (void)setCenterTitle:(NSString *)centerTitle{

    _centerTitle = centerTitle;
    
}





@end
