//
//  DDBaseNavColumnView.m
//  textNav
//
//  Created by Seven on 2017/4/9.
//  Copyright © 2017年 CaydenK. All rights reserved.
//

#import "DDBaseNavColumnView.h"


@interface DDBaseNavColumnView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentSelect;
@end


@implementation DDBaseNavColumnView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self tableView];
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }
    return self;
}


- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width - 6, 150/4.0 * titleArray.count);
    UIImage *image = [UIImage imageNamed:@"bg_downlist"];
    CGSize size = image.size;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(size.height/2.0, size.width/2.0, size.height/2.0, size.width/2)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(-3, 0, size.width , 150/4.0 * titleArray.count)];
    imageV.image = image;
    [self.tableView addSubview:imageV];
    [self.tableView sendSubviewToBack:imageV];
    self.currentSelect = 0;
    [self.tableView reloadData];
}


//tableviewDelegte

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIden = @"cellIdentification";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIden];
    }
    
    if (self.titleArray.count) {
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lb = [UILabel new];
        lb.textColor = DS_COLOR_HEXCOLOR(@"666666");
        lb.textAlignment = 1;
        lb.font = DS_APP_FONT(12);
        [cell.contentView addSubview:lb];
        lb.text = self.titleArray[indexPath.item];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(cell.contentView);
        }];
    }
    if (self.currentSelect == indexPath.item) {
        cell.backgroundColor = DS_COLOR_HEXCOLOR(@"ededed");
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 150/4.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.DDNavColumnViewBlock) {
        self.DDNavColumnViewBlock(indexPath.row);
    }
    self.currentSelect = indexPath.item;
    [self.tableView reloadData];
}
// lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_tableView];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
