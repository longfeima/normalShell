//
//  DsCustomCollectionView.h
//  textCollectionView
//
//  Created by Seven on 2017/4/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 

 - DDCollectionViewCellDefaultType: 默认无比例缩放
 - DDCollectionViewCellSecalType: 比例缩放0.05
 */
typedef NS_OPTIONS(NSInteger, DDCollectionViewCellType) {
    DDCollectionViewCellDefaultType,
    DDCollectionViewCellSecalType
};
/**
 滑动方向
 - DDCollectionViewScrollDirectionVertical: 纵向
 - DDCollectionViewScrollDirectionHorizontal: 横向
 */
typedef NS_ENUM(NSInteger, DDCollectionViewScrollDirection) {
    DDCollectionViewScrollDirectionVertical,
    DDCollectionViewScrollDirectionHorizontal
};


@interface DsCustomCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame AndItemIndetifications:(NSArray <NSString *>*) itemIdentis;

@property (nonatomic, strong) UICollectionView *collectionView;
/**
 cell特效
 */
@property (nonatomic, assign) DDCollectionViewCellType cellType;
/**
 传递cell进行相关操作
 */
@property (nonatomic, strong)  void(^DDCustomCollectionBlock)(id cell ,NSIndexPath *index);
@property (nonatomic, strong)  void(^DDCustomCollectionSelectBlock)(id cell ,NSIndexPath *index);
@property (nonatomic, strong)  void(^DDCollectionSelectIndex)(NSIndexPath *index);
/**
 edge
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsetMake;
/**
 滑动方向
 */
@property (nonatomic, assign) DDCollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign) BOOL scrollEnabled;
/**
 一组items为 item大小
 */
@property (nonatomic, assign) CGSize itemsSize;
/**
 cell个数
 */
@property (nonatomic, strong) NSArray<NSString *> *itemsArray;
/**
 默认选中
 */
@property (nonatomic, assign) NSInteger selectItemAtIndex;
/**
 多组
 //key 0、1、2、3........
 */
@property (nonatomic, strong) NSArray<NSDictionary *> *sectionsArray;
/**
 @{
    @"width": 123,
    @"height": 123
 }
 */
@property (nonatomic, strong) NSArray<NSDictionary *> *sectionsSizeArray;
@property (nonatomic, strong) NSArray<NSString *> *sectionHeader;


@property (nonatomic, strong) id footView;

@end
