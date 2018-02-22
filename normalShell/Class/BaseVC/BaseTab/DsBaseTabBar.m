//
//  DsBaseTabBar.m
//  WBuild
//
//  Created by Seven on 2017/7/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsBaseTabBar.h"
#import <UIImageView+WebCache.h>
#import "DDGlobalConstant.h"
#import <objc/runtime.h>
#import "DsTabConfig.h"
@interface DsCustomBarItemView ()

@property (nonatomic, strong) UIImageView *itemImageV;
@property (nonatomic, strong) UILabel *itemLb;
@property (nonatomic, strong) UILabel *redPoint;
@property (nonatomic, strong) UILabel *badgeLb;

@end

@implementation DsCustomBarItemView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];//[[UIColor grayColor] colorWithAlphaComponent:0.7];
        [self itemImageV];
        [self itemLb];
        [self redPoint];
        [self badgeLb];
    }
    return self;
}
//---lazy
- (UIImageView *)itemImageV{
    if (!_itemImageV) {
        CGRect frame = self.frame;
        _itemImageV = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 15, 3, 26, 26)];

        [self addSubview:_itemImageV];
    }
    return _itemImageV;
}

- (UILabel *)redPoint{
    
    if (!_redPoint) {
        _redPoint = [UILabel new];
        _redPoint.frame = CGRectMake(CGRectGetMaxX(self.itemImageV.frame) + 3, CGRectGetMaxY(self.itemImageV.frame) - 3, 6, 6);
        _redPoint.layer.cornerRadius = 3.0;
        _redPoint.clipsToBounds = YES;
        _redPoint.hidden = YES;
        _redPoint.backgroundColor = [UIColor redColor];
        [self addSubview:_redPoint];
    }
    return _redPoint;
}

- (UILabel *)badgeLb{
    
    if (!_badgeLb) {
        _badgeLb = [UILabel new];
        _badgeLb.frame = CGRectMake(CGRectGetMaxX(self.itemImageV.frame) - 7, CGRectGetMinY(self.itemImageV.frame) - 3, 14, 14);
        _badgeLb.layer.cornerRadius = 7;
        _badgeLb.clipsToBounds = YES;
        _badgeLb.textAlignment = 1;
        _badgeLb.hidden = YES;
        _badgeLb.text = @"99";
        _badgeLb.textColor = [UIColor whiteColor];
        _badgeLb.font = TAB_APP_FONT(9);
        _badgeLb.backgroundColor = [UIColor redColor];
        [self addSubview:_badgeLb];
    }
    
    return _badgeLb;
    
}


- (UILabel *)itemLb{
    if (!_itemLb) {
        _itemLb = [UILabel new];
        CGRect frame = self.frame;
        _itemLb.frame = CGRectMake(frame.size.width/2 - 15, CGRectGetMaxY(self.itemImageV.frame) + 3, 26, 10);
        _itemLb.textAlignment = 1;
        _itemLb.font = [UIFont boldSystemFontOfSize:12];//TAB_APP_FONT(12);
        _itemLb.textColor = DS_COLOR_HEXCOLOR(@"A7A7A7");//[UIColor whiteColor];//DS_COLOR_HEXCOLOR(@"A7A7A7");
        [self addSubview:_itemLb];
    }
    return _itemLb;
}


@end

////////////////////////////////////////
#define TAB_KEY_CHANGE_TITLE                    @"TAB_KEY_CHANGE_TITLE"
#define TAB_KEY_CHANGE_IMAGES                   @"TAB_KEY_CHANGE_IMAGES"
#define TAB_KEY_CHANGE_SELECTIMAGES             @"TAB_KEY_CHANGE_SELECTIMAGES"


#define TAB_BASEITEM_TAG                10101



@interface DsBaseTabBar ()
{
    UINavigationController *_preNav;
    DsCustomBarItemView *_preView;
}

@property (nonatomic, assign) BOOL isChangeTabImages;
@property (nonatomic, assign) BOOL isChangeTabTitles;
@property (nonatomic, assign) BOOL isChangeTabImagesAndSelectImages;
@end

@implementation DsBaseTabBar



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    NSArray *tabBarSubArray = self.tabBar.subviews;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<tabBarSubArray.count; i++) {
        UIView *View = [tabBarSubArray objectAtIndex:i];
        View.hidden = YES;
    }
    NSArray *array = self.viewControllers;
    NSString *index = objc_getAssociatedObject(self, (__bridge const void *)(@"index"));
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DsCustomBarItemView class]]) {
            [obj removeFromSuperview];
        }
    }];
    for (int i = 0; i<array.count; i++) {
        UINavigationController *nav = [array objectAtIndex:i];
        DsCustomBarItemView *itemView = [[DsCustomBarItemView alloc]initWithFrame:CGRectMake(i*TAB_APP_SCREEN_WIDTH/array.count, 0, TAB_APP_SCREEN_WIDTH/array.count, TAB_APP_TAB_HEIGHT)];
        if (TAB_APP_ISIPHONE_X) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(-i*TAB_APP_SCREEN_WIDTH/array.count, 49, TAB_APP_SCREEN_WIDTH, TAB_APP_TAB_HEIGHT - 49)];
            itemView.clipsToBounds = YES;
            if (self.tabLocalAdvImageString.length && [UIImage imageNamed:self.tabLocalAdvImageString]) {
                imageV.image = [UIImage imageNamed:self.tabLocalAdvImageString];
            }
            if (self.tabAdvImageURL && [self.tabAdvImageURL hasPrefix:@"http"]) {
                [imageV sd_setImageWithURL:[NSURL URLWithString:self.tabAdvImageURL]];
            }
            [itemView addSubview:imageV];
        }
        [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)]];
        [self.tabBar addSubview:itemView];
        itemView.itemImageV.image = nav.tabBarItem.image;
        itemView.itemLb.text = nav.tabBarItem.title;
        itemView.tag = TAB_BASEITEM_TAG + i;
        if (i==0 && !index.length) {
            itemView.itemImageV.image = nav.tabBarItem.selectedImage;
            itemView.itemLb.textColor = DS_COLOR_HEXCOLOR(@"2EB2D9");
            self.selectIndex = 0;
            _preNav = nav;
            _preView =itemView;
        }
        if (index.length && [index integerValue] == i) {
            itemView.itemImageV.image = nav.tabBarItem.selectedImage;
            itemView.itemLb.textColor = DS_COLOR_HEXCOLOR(@"2EB2D9");
            self.selectIndex = [index integerValue];
            _preNav = nav;
            _preView =itemView;
        }
    }
    if (self.isChangeTabImagesAndSelectImages) {
        NSArray *images = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_IMAGES));
        NSArray *selectedImages = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_SELECTIMAGES));
        [self changeTabImageWithIconsArray:images SeletedImageWithIconsArray:selectedImages];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)changeEnvironment{
    NSArray *array = self.viewControllers;
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        //        if (i == self.selectIndex) {
        //            itemV.backgroundColor = DS_GLOBAL_TABBARCOLOR;
        //        }else{
        itemV.backgroundColor = [UIColor whiteColor];//DS_GLOBAL_TABBARCOLOR;
        //        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEnvironment) name:NOTI_APP_TABBARCHANGECOLOR object:nil];
}
/**
 - (void)viewDidAppear:(BOOL)animated{
 [super viewDidAppear:animated];
 NSArray *array = self.viewControllers;
 NSString *index = objc_getAssociatedObject(self, (__bridge const void *)(@"index"));
 [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 if ([obj isKindOfClass:[DsCustomBarItemView class]]) {
 [obj removeFromSuperview];
 }
 }];
 for (int i = 0; i<array.count; i++) {
 UINavigationController *nav = [array objectAtIndex:i];
 DsCustomBarItemView *itemView = [[DsCustomBarItemView alloc]initWithFrame:CGRectMake(i*DDAPPWidth/array.count, 0, DDAPPWidth/array.count, 49)];
 [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)]];
 [self.tabBar addSubview:itemView];
 itemView.itemImageV.image = nav.tabBarItem.image;
 itemView.itemLb.text = nav.tabBarItem.title;
 itemView.tag = TAB_BASEITEM_TAG + i;
 if (i==0 && !index.length) {
 itemView.itemImageV.image = nav.tabBarItem.selectedImage;
 itemView.itemLb.textColor = DDAPPHexColor(@"FF834E");
 self.selectIndex = 0;
 _preNav = nav;
 _preView =itemView;
 }
 if (index.length && [index integerValue] == i) {
 itemView.itemImageV.image = nav.tabBarItem.selectedImage;
 itemView.itemLb.textColor = DDAPPHexColor(@"FF834E");
 self.selectIndex = [index integerValue];
 _preNav = nav;
 _preView =itemView;
 }
 }
 if (self.isChangeTabImagesAndSelectImages) {
 NSArray *images = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_IMAGES));
 NSArray *selectedImages = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_SELECTIMAGES));
 [self changeTabImageWithIconsArray:images SeletedImageWithIconsArray:selectedImages];
 }
 }
 */
#pragma mark --------- 做点击判断&&取消tab跳转
- (void)tapClick:(UITapGestureRecognizer *)tap{
    DsCustomBarItemView *itemV = (DsCustomBarItemView *)tap.view;
    [self animatWithView:itemV];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tab_selectAtIndex:)]) {
        [self.delegate tab_selectAtIndex:tap.view.tag- TAB_BASEITEM_TAG];
    }
    UINavigationController *nav = self.viewControllers[tap.view.tag- TAB_BASEITEM_TAG];
    if (itemV == _preView) {
        return;
    }
    if (!self.isChangeTabImages) {
        itemV.itemImageV.image = nav.tabBarItem.selectedImage;
        _preView.itemImageV.image =_preNav.tabBarItem.image;
    }
    if (!self.isChangeTabTitles) {
        itemV.itemLb.text = nav.tabBarItem.title;
    }
    
    if (self.isChangeTabImagesAndSelectImages) {
        NSArray *images = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_IMAGES));
        NSArray *selectedImages = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_SELECTIMAGES));
        [_preView.itemImageV sd_setImageWithURL:[NSURL URLWithString:images[self.selectedIndex]]];
        [itemV.itemImageV sd_setImageWithURL:[NSURL URLWithString:selectedImages[tap.view.tag - TAB_BASEITEM_TAG]]];
    }
    itemV.itemLb.textColor = DS_COLOR_HEXCOLOR(@"2EB2D9");
    _preView.itemLb.textColor = DS_COLOR_HEXCOLOR(@"A7A7A7");
    _preView = itemV;
    _preNav = nav;
    self.selectedIndex = tap.view.tag - TAB_BASEITEM_TAG;
}


- (void)setSelectIndex:(NSInteger)selectIndex{
    NSString *index = [NSString stringWithFormat:@"%ld",(long)selectIndex];
    objc_setAssociatedObject(self, (__bridge const void *)(@"index"), index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    DsCustomBarItemView *itemV = [self.tabBar viewWithTag:selectIndex + TAB_BASEITEM_TAG];
    UINavigationController *nav = [self.viewControllers objectAtIndex:selectIndex];
    itemV.itemLb.textColor = DS_COLOR_HEXCOLOR(@"2EB2D9");
    itemV.itemImageV.image = nav.tabBarItem.selectedImage;
    
    if (itemV == _preView) {
       if(!self.isChangeTabImagesAndSelectImages)return;
    }
    
    _preView.itemLb.textColor = DS_COLOR_HEXCOLOR(@"A7A7A7");
    _preView.itemImageV.image = _preNav.tabBarItem.image;
    _preView = itemV;
    _preNav = nav;
    
    
    
    self.selectedIndex = selectIndex;
    if (self.isChangeTabImagesAndSelectImages) {
        NSArray *images = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_IMAGES));
        NSArray *selectedImages = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_SELECTIMAGES));
        [self changeTabImageWithIconsArray:images SeletedImageWithIconsArray:selectedImages];
    }
}


- (void)animatWithView:(DsCustomBarItemView *)itemV{
    [UIView animateWithDuration:0.1 animations:^{
        itemV.itemImageV.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        itemV.itemImageV.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        
    }];
    
}

#pragma mark ==
- (void)setShowRedPointAtIndex:(NSInteger)showRedPointAtIndex{
    NSArray *array = self.viewControllers;
    if (showRedPointAtIndex < 0 || showRedPointAtIndex >= array.count) {
        return;
    }
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        if (i == showRedPointAtIndex) {
            itemV.redPoint.hidden = NO;
        }else{
            itemV.redPoint.hidden = YES;
        }
    }
}

- (void)setShowRedPointsAtIndexs:(NSArray<NSString *> *)showRedPointsAtIndexs{
    
    NSArray *array = self.viewControllers;
    if (showRedPointsAtIndexs.count == 0 || showRedPointsAtIndexs.count != array.count) {
        return;
    }
    for (int i = 0; i < showRedPointsAtIndexs.count; i++) {
        NSString *str = showRedPointsAtIndexs[i];
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        if ([str integerValue] == 1) {
            itemV.redPoint.hidden = NO;
        }else{
            itemV.redPoint.hidden = YES;
        }
    }
    
}

- (void)showBadgeAtIndex:(NSInteger)index number:(NSString *)number{
    NSArray *array = self.viewControllers;
    if (index < 0 || index >= array.count
        || [number integerValue] < 0
        ) {
        return;
    }
    NSString *temp;
    if ([number integerValue] >= 100) {
        temp = @"..";
    }else{
        temp = [number integerValue] > 0 ? number : @"";
    }
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        if (i == index && [number integerValue] > 0) {
            itemV.badgeLb.hidden = NO;
            itemV.badgeLb.text = temp;
        }else{
            itemV.badgeLb.hidden = YES;
            itemV.badgeLb.text = @"";
        }
    }
}

- (void)showBadgesAtIndexs:(NSArray<NSString *> *)indexs numbers:(NSArray<NSString *> *)numbers{
    
    NSArray *array = self.viewControllers;
    if (indexs.count == 0 || indexs.count != array.count
        ||numbers.count != indexs.count) {
        return;
    }
    for (int i = 0; i < indexs.count; i++) {
        NSString *temp;
        if ([numbers[i] integerValue] >= 100) {
            temp = @"..";
        }else{
            temp = [numbers[i] integerValue] > 0 ? numbers[i] : @"";
        }
        NSString *str = indexs[i];
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        if ([str integerValue] == 1 && [numbers[i] integerValue]) {
            itemV.badgeLb.hidden = NO;
            itemV.badgeLb.text = temp;
        }else{
            itemV.badgeLb.hidden = YES;
            itemV.badgeLb.text = @"";
        }
    }
    
}
//change tabIconsWithURL
- (void)changeTabImageWithIconsArray:(NSArray<NSString *> *)icons{
    if (icons.count <=0) {
        return;
    }
    self.isChangeTabImages = YES;
    NSArray *array = self.viewControllers;
    objc_setAssociatedObject(self, (__bridge const void *)(TAB_KEY_CHANGE_IMAGES), icons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        itemV.backgroundColor = [UIColor whiteColor];
        if (icons.count > i && [icons[i] length] > 0) {
            [itemV.itemImageV sd_setImageWithURL:[NSURL URLWithString:icons[i]]];
        }
    }
}
#pragma mark ----后期支持传单个数组的话做单个修改
/**change icon if icons.count == 0 invalid icons.count can small than self.viewControlers.count */
- (void)changeTabImageWithIconsArray:(NSArray<NSString *> *)icons SeletedImageWithIconsArray:(NSArray<NSString *> *)selectedIcons{
    self.isChangeTabImagesAndSelectImages = YES;
    objc_setAssociatedObject(self, (__bridge const void *)(TAB_KEY_CHANGE_IMAGES), icons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)(TAB_KEY_CHANGE_SELECTIMAGES), selectedIcons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSArray *array = self.viewControllers;
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        itemV.backgroundColor = [UIColor whiteColor];
        if (icons.count > i && [icons[i] length] > 0) {
            NSString *iconUrl = (i == self.selectedIndex ? selectedIcons[i] : icons[i]);
            [itemV.itemImageV sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
        }
        itemV.itemLb.textColor = (i == self.selectedIndex ? DS_COLOR_HEXCOLOR(@"2EB2D9") : DS_COLOR_HEXCOLOR(@"A7A7A7"));
    }
}



//change tabTitles
- (void)changeTabTitleWithTitlesArray:(NSArray<NSString *> *)titles{
    self.isChangeTabTitles = YES;
    objc_setAssociatedObject(self, (__bridge const void *)(TAB_KEY_CHANGE_TITLE), titles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSArray *array = self.viewControllers;
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        itemV.backgroundColor = [UIColor whiteColor];
        if (titles.count > i && [titles[i] length] > 0) {
            itemV.itemLb.text = titles[i];
        }
    }
    
}
//change tabTitles&&tabIcons
- (void)changeTabImageWithIconsArray:(NSArray<NSString *> *)icons Titles:(NSArray<NSString *> *)titles{
    [self changeTabImageWithIconsArray:icons];
    [self changeTabTitleWithTitlesArray:titles];
}

- (void)cancelTabImagesChanges{
    self.isChangeTabImages = NO;
    id images = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_IMAGES));
    if ([images isKindOfClass:[NSNull class]] || [images count] <= 0) {
        return;
    }
    
    NSArray *array = self.viewControllers;
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        UINavigationController *nav = self.viewControllers[i];
        if (!self.isChangeTabImages) {
            itemV.itemImageV.image = nav.tabBarItem.image;
        }
    }
    _preView.itemImageV.image =_preNav.tabBarItem.selectedImage;
}

- (void)cancelTabImagesAndSelectedImagesChanges{
    
    self.isChangeTabImagesAndSelectImages = NO;
    id images = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_IMAGES));
    id selectedImages = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_SELECTIMAGES));
    if ([images isKindOfClass:[NSNull class]] || [selectedImages isKindOfClass:[NSNull class]] || [images count] <= 0 || [selectedImages count] <= 0) {
        return;
    }
    NSArray *array = self.viewControllers;
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        UINavigationController *nav = self.viewControllers[i];
        if (!self.isChangeTabImagesAndSelectImages) {
            itemV.itemImageV.image = nav.tabBarItem.image;
        }
    }
    _preView.itemImageV.image =_preNav.tabBarItem.selectedImage;
}


- (void)cancelTabTitlesChanges{
    self.isChangeTabTitles = NO;
    id titles = objc_getAssociatedObject(self, (__bridge const void*)(TAB_KEY_CHANGE_TITLE));
    if ([titles isKindOfClass:[NSNull class]] || [titles count] <= 0) {
        return;
    }
    NSArray *array = self.viewControllers;
    for (int i = 0; i < array.count; i++) {
        DsCustomBarItemView *itemV = [self.tabBar viewWithTag:i + TAB_BASEITEM_TAG];
        UINavigationController *nav = self.viewControllers[i];
        if (!self.isChangeTabTitles) {
            itemV.itemLb.text = nav.tabBarItem.title;
        }
    }
    
    
}
- (void)cancelTabImagesAndTitlesChanges{
    [self cancelTabTitlesChanges];
    [self cancelTabImagesChanges];
    [self cancelTabImagesAndSelectedImagesChanges];
}

@end

