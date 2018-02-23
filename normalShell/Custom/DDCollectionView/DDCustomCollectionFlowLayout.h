//
//  DDCustomCollectionFlowLayout.h
//  textCollectionView
//
//  Created by Seven on 2017/4/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, S_FlowLayoutType) {
    S_FlowLayoutTypeDefault = 0,        //没有做比例约束
    S_FlowLayoutTypeScale               //比例约束
};


@interface DDCustomCollectionFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) S_FlowLayoutType _type;
@property (nonatomic, assign) CGSize _itemSize;
@property (nonatomic, assign) CGFloat _itemScale;
@property (nonatomic, assign) NSInteger _items;
@property (nonatomic, assign) NSInteger _didSelectItem;


@end
