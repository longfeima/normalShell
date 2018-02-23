//
//  DDCustomCollectionFlowLayout.m
//  textCollectionView
//
//  Created by Seven on 2017/4/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DDCustomCollectionFlowLayout.h"

#define S_COLLECTIONVIEW_WIDTH      self.collectionView.frame.size.width
#define S_COLLECTIONVIEW_HEIGHT     self.collectionView.frame.size.height






static CGFloat _youtW = 100;//375 / 3.0;
static CGFloat _youtH = 100;

@interface DDCustomCollectionFlowLayout ()

@end



@implementation DDCustomCollectionFlowLayout



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(_youtW, _youtH);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        self.minimumLineSpacing = 50;//0.5 * _youtW;
        //        self.minimumInteritemSpacing = 20;
        self._items = 5;
        __type = S_FlowLayoutTypeScale;
    }
    return self;
}

- (void)set_itemSize:(CGSize)_itemSize{
    __itemSize = _itemSize;
    self.itemSize = __itemSize;
    
}

- (void)set_didSelectItem:(NSInteger)_didSelectItem{
    
    __didSelectItem = _didSelectItem;
    [self layoutAttributesForElementsInRect:self.collectionView.frame];
    [self.collectionView layoutIfNeeded];
}




- (void)prepareLayout{
    switch (self._type) {
        case S_FlowLayoutTypeDefault:{
//            NSLog(@"normal that is not layout by user");
            self.sectionInset = UIEdgeInsetsMake(-self.collectionView.frame.size.height, 0, 0, 0);
            self.minimumLineSpacing = 0.5 * _youtW;
            break;
        }
        case S_FlowLayoutTypeScale:{
//            CGFloat inset = (self.collectionView.bounds.size.width ?: 0) * 0.5 - self.itemSize.width * 0.5;
            //            self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
            self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            self.minimumLineSpacing = 30;
            //            self.minimumInteritemSpacing = 20;
            break;
        }
        default:
            break;
    }
    
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    
    NSMutableArray *array = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    switch (self._type) {
        case S_FlowLayoutTypeDefault:{
            
            break;
        }
        case S_FlowLayoutTypeScale:{
            CGRect visiableRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
            
            CGFloat margin = self.collectionView.bounds.size.width * 0.5 + _youtW * 0.5;
            
            CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
            for (UICollectionViewLayoutAttributes *attributes in array) {
                if (self._didSelectItem) {
//                    UICollectionViewLayoutAttributes *attributes1 = array[self._didSelectItem];
//                    CGFloat scale = (1 + (0.5 - fabs(centerX - attributes.center.x) / margin)) * self._itemScale;
                    //                    attributes1.transform = CGAffineTransformMakeScale(scale, scale);
                    attributes.transform = CGAffineTransformMakeScale(1, 1);
                }else{
                    
                    if (!CGRectIntersectsRect(visiableRect, attributes.frame)) {
                        continue;
                    }
                    CGFloat scale = (1 + (0.5 - fabs(centerX - attributes.center.x) / margin)) * self._itemScale;
                    attributes.transform = CGAffineTransformMakeScale(scale, scale);
                }
            }
            
            break;
        }
        default:
            break;
    }
    return (NSArray *)array;
    
}




- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    switch (self._type) {
        case S_FlowLayoutTypeDefault:{
            return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
            break;
        }
        case S_FlowLayoutTypeScale:{
            CGRect lastRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
            
            CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
            
            NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
            
            CGFloat adjustOffsetX = MAXFLOAT;
            
            for (UICollectionViewLayoutAttributes * attributes in array) {
                if (fabs(attributes.center.x - centerX) < fabs(adjustOffsetX)) {
                    adjustOffsetX = attributes.center.x - centerX;
                }
            }
            return  CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
            break;
        }
        default:
            break;
    }
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
}




@end
