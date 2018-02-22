//
//  DDBaseNavHorizontalView.m
//  DDSC
//
//  Created by CaydenK on 2017/3/19.
//  Copyright © 2017年 ddsoucai. All rights reserved.
//

#import "DDBaseNavHorizontalView.h"
#import "DsNavConfig.h"



@implementation titleBtn

- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    self.layer.cornerRadius = 2.0;
    self.titleLabel.font = APP_FONT(16);
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected{
    self.backgroundColor = selected ? DS_COLOR_HEXCOLOR(@"0xFF6438") : [UIColor clearColor];
    [self setTitleColor:selected ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
}

@end



@interface DDBaseNavHorizontalView ()

@property (nonatomic, strong) NSMutableArray *titlesTypeArray;
@property (nonatomic, assign) NSInteger currrentSelect;

@end



#define DDBaseNavHorzontalViewTag 118121
@implementation DDBaseNavHorizontalView


- (void)setTitleArray:(NSArray *)titleArray{

    if ([_titleArray isEqualToArray:titleArray]) {
        return;
    }
    _titleArray = titleArray;
    if (titleArray.count <= 4) {
        self.bounds = CGRectMake(0, 0, 82 * titleArray.count, 30);
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        for (int i = 0; i < titleArray.count ; i++) {
            titleBtn *btn = [[titleBtn alloc]initWithFrame:CGRectMake(82 * i, 0, 82, 30)];
            btn.tag = DDBaseNavHorzontalViewTag + i;
            btn.selected = NO;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [self.titlesTypeArray addObject:@YES];
                btn.selected = YES;
            }else{
                [self.titlesTypeArray addObject:@NO];
            }
        }
        self.currrentSelect = 0;
        self.selectItemAtIndex = 0;
    }else{
    
        return;
        
    }
    
}

- (void)setCurrrentSelect:(NSInteger)currrentSelect{
    if (_currrentSelect == currrentSelect) {
        return;
    }
    _currrentSelect = currrentSelect;
}

- (void)setSelectItemAtIndex:(NSInteger)selectItemAtIndex{
    
        for (int i = 0; i < self.titlesTypeArray.count; i++) {
            titleBtn *btn = [self viewWithTag:i + DDBaseNavHorzontalViewTag];
            if (i == selectItemAtIndex) {
                btn.selected = YES;
                _selectItemAtIndex = i;
                _currrentSelect = _selectItemAtIndex;
                [self.titlesTypeArray replaceObjectAtIndex:i withObject:@YES];
            }else{
                [self.titlesTypeArray replaceObjectAtIndex:i withObject:@NO];
                btn.selected = NO;
            }
        }
}

- (NSInteger)getSelectItemAtIndex:(NSInteger)selectItemAtIndex{
    return _currrentSelect;
}

- (void)titleBtnClick:(UIButton *)btn{
    NSInteger index = btn.tag - DDBaseNavHorzontalViewTag;
    if (index == self.selectItemAtIndex) {
        return;
    }
    self.selectItemAtIndex = index;
    for (int i = 0; i < self.titlesTypeArray.count; i++) {
        titleBtn *btn = [self viewWithTag:i + DDBaseNavHorzontalViewTag];
        btn.selected = [self.titlesTypeArray[i] boolValue];
    }
    
    if (self.DDNavHorizotalViewBlock) {
        self.DDNavHorizotalViewBlock(index);
    }
    
}


// --- lazy

- (NSMutableArray *)titlesTypeArray{
    if (!_titlesTypeArray) {
        _titlesTypeArray = [NSMutableArray new];
    }
    return _titlesTypeArray;
}



@end
