//
//  sSheetView.m
//  sTips
//
//  Created by Seven on 2017/7/25.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "sSheetView.h"
#import <objc/runtime.h>

#define EDGE_LEFTANDRIGHT               15
#define EDGE_TOPANDBOTTON               0.5
#define ITEM_TITLE_HEIGHT               45

#define LAYER_CORNERRADIUS              8
#define DS_BASEBTN_TAG                  9999

@interface sSheetView ()

@property (nonatomic, strong) UIView *backgroundView;

@end

static NSString *itemsKey = @"itemsKey";
static NSString *titleKey = @"titleKey";

@implementation sSheetView




- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self creatBackground];
        
    }
    return self;
}


- (void)showSheetWithObject:(NSArray <NSString *>*)items Title:(NSString *)title Type:(Ds_SheetType)type{

    if (items.count <= 0) {
        return;
    }
    objc_setAssociatedObject(self, (__bridge const void *)(itemsKey), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)(titleKey), title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    switch (type) {
        case Ds_Sheet_Default:
        {
            [self creatItemsTypeEqueDefault];
        }
            break;
        case Ds_Sheet_Normal:
        {
            [self creatItemsTypeEqueNormal];
        }
            break;
            
        default:
            break;
    }
    
 
}

- (void)creatItemsTypeEqueDefault{
    
    NSString *title = objc_getAssociatedObject(self, (__bridge const void *)(titleKey));
    NSArray *items = objc_getAssociatedObject(self, (__bridge const void *)(itemsKey));
    CGFloat baseItemMaxY = MAX(0, self.frame.size.height - ITEM_TITLE_HEIGHT - 10);
    CGFloat subItemsHight;
    NSInteger allItemasCount = items.count;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self creatBackground];
    NSMutableArray *tempItemsArr = [items mutableCopy];
    if (items.count > 0) {
        [tempItemsArr insertObject:title atIndex:0];
        allItemasCount = items.count + 1;
    }
    subItemsHight = (self.frame.size.height - ITEM_TITLE_HEIGHT - 10 - (allItemasCount) * EDGE_TOPANDBOTTON)/(allItemasCount);
    UIView *subBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(EDGE_LEFTANDRIGHT, 0, self.frame.size.width - 2 * EDGE_LEFTANDRIGHT, baseItemMaxY)];
    subBackgroundView.layer.cornerRadius = LAYER_CORNERRADIUS;
    subBackgroundView.clipsToBounds = YES;
    [self.backgroundView addSubview:subBackgroundView];
    for (int i = 0; i < tempItemsArr.count; i++) {
        UILabel *itemLb = [[UILabel alloc]initWithFrame:CGRectMake(0, (subItemsHight + EDGE_TOPANDBOTTON) * i, self.frame.size.width - EDGE_LEFTANDRIGHT * 2, subItemsHight)];
        itemLb.tag = DS_BASEBTN_TAG + i;
        [subBackgroundView addSubview:itemLb];
        itemLb.textAlignment = 1;
        itemLb.font = i == 0 ? [UIFont systemFontOfSize:19 weight:1] : [UIFont systemFontOfSize:17];
        itemLb.text = tempItemsArr[i];
        itemLb.userInteractionEnabled = YES;
        itemLb.textColor = i == 0 ? [UIColor blackColor] : [UIColor blueColor];
        itemLb.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        i <= 0 ?: [itemLb addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
    }
    UILabel *cancelLb = [[UILabel alloc]initWithFrame:CGRectMake(EDGE_LEFTANDRIGHT, self.frame.size.height - ITEM_TITLE_HEIGHT, self.frame.size.width - EDGE_LEFTANDRIGHT * 2, ITEM_TITLE_HEIGHT)];
    [self.backgroundView addSubview:cancelLb];
    cancelLb.textAlignment = 1;
    cancelLb.tag = DS_BASEBTN_TAG;
    cancelLb.textColor = [UIColor redColor];
    cancelLb.layer.cornerRadius = LAYER_CORNERRADIUS;
    cancelLb.clipsToBounds = YES;
    cancelLb.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    cancelLb.userInteractionEnabled = YES;
    [cancelLb addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
    cancelLb.text = DSLocalizedString(DS_HOME_CLOCK_BTN_CANCEL);
 
}

- (void)creatItemsTypeEqueNormal{
    
    NSString *title = objc_getAssociatedObject(self, (__bridge const void *)(titleKey));
    NSArray *items = objc_getAssociatedObject(self, (__bridge const void *)(itemsKey));

    CGFloat baseItemMinY = 0.0;
    NSInteger allItemasCount = items.count;
    CGFloat subItemsHight;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self creatBackground];
    if (title.length > 0) {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(EDGE_LEFTANDRIGHT, 0, self.frame.size.width - EDGE_LEFTANDRIGHT * 2, ITEM_TITLE_HEIGHT)];
        [self.backgroundView addSubview:lb];
        allItemasCount = 1 + items.count;
        baseItemMinY = ITEM_TITLE_HEIGHT + 10;
        lb.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        lb.textAlignment = 1;
        lb.layer.cornerRadius = LAYER_CORNERRADIUS;
        lb.clipsToBounds = YES;
        lb.font = [UIFont systemFontOfSize:19 weight:1];
        lb.text = title;
    }
    subItemsHight = (self.frame.size.height - baseItemMinY - items.count * EDGE_TOPANDBOTTON)/items.count;
    UIView *subBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(EDGE_LEFTANDRIGHT, baseItemMinY, self.frame.size.width - 2 * EDGE_LEFTANDRIGHT, self.frame.size.height - baseItemMinY)];
    subBackgroundView.layer.cornerRadius = LAYER_CORNERRADIUS;
    subBackgroundView.clipsToBounds = YES;
    [self.backgroundView addSubview:subBackgroundView];
    
    for (int i = 0; i < items.count; i ++) {
        UILabel *itemLb = [[UILabel alloc]initWithFrame:CGRectMake(0, (subItemsHight + EDGE_TOPANDBOTTON) * i, self.frame.size.width - EDGE_LEFTANDRIGHT * 2, subItemsHight)];
        itemLb.tag = DS_BASEBTN_TAG + i;
        [subBackgroundView addSubview:itemLb];
        itemLb.textAlignment = 1;
        itemLb.text = items[i];
        itemLb.userInteractionEnabled = YES;
        itemLb.textColor = [UIColor blueColor];
        itemLb.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        [itemLb addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)]];
    }
    
}

- (void)itemClick:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag - DS_BASEBTN_TAG;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sSheetViewSelectIndex:)]) {
        [self.delegate sSheetViewSelectIndex:tag?:-1];
    }
    
}


- (void)creatBackground{
    self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.backgroundView];
}
//lazy========
- (UIView *)backgroundView{
    
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hello)]];
        _backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (void)hello{

//    return;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

//    for (UIView *view in self.subviews) {
//        if (view && [view isKindOfClass:[UILabel class]]) {
//            return view;
//        }
//    }
//    
    return [super hitTest:point withEvent:event];
}

@end
