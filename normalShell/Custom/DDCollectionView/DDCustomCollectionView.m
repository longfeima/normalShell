//
//  DDCustomCollectionView.m
//  textCollectionView
//
//  Created by Seven on 2017/4/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？



#import "DDCustomCollectionView.h"

#import "DDCustomCollectionFlowLayout.h"

#import "headeView.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height





@interface DDCustomCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

/**
 防止空class注册
 */
@property (nonatomic, strong) NSMutableArray *classesMutableArray;
/**
 动画约束，暂时不用，需要的话再做修改
 */
@property (nonatomic, strong) DDCustomCollectionFlowLayout *layout;
/**
 普通约束，根据类型做特效处理，目前不做
 */
@property (nonatomic, strong)UICollectionViewFlowLayout *collLayout;

@end
@interface DDCustomCollectionView ()

{
    NSMutableArray *itemsSelect;
}

@end

@implementation DDCustomCollectionView

- (instancetype)initWithFrame:(CGRect)frame AndItemIndetifications:(NSArray <NSString *>*) itemIdentis{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        
        [self configurationNormal];
        [self registerClassWithArray:itemIdentis];
    }
    return self;
}
/**
 通用配置
 */
- (void)configurationNormal{
    self.cellType = DDCollectionViewCellDefaultType;
    self.edgeInsetMake = UIEdgeInsetsMake(1, 1, 1, 1);
    CGFloat height =(HEIGHT/4)+10.0f;
    CGFloat width = (WIDTH-7)/3.0f+1;
    self.itemsSize =  CGSizeMake(width, height);
    itemsSelect = [NSMutableArray new];
    self.layout.scrollDirection = DDCollectionViewScrollDirectionVertical;
    self.collLayout.scrollDirection = DDCollectionViewScrollDirectionVertical;
    self.selectItemAtIndex = 0;
}

/**
 //注册cell用于class做identifier
 @param classes class array
 */
- (void)registerClassWithArray:(NSArray *)classes{
    for (NSInteger i = 0; i < classes.count; i++) {
        NSString *classStr = classes[i];
        Class itemClass = NSClassFromString(classStr);
        if (itemClass != nil) {
            [self.classesMutableArray addObject: classStr];
            [self.collectionView registerClass:[itemClass class] forCellWithReuseIdentifier:classStr];
        }
    }
}

#pragma mark ----collectionViewDelegte
//目前先写一组的
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *resuse = self.classesMutableArray[indexPath.section];
     id cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuse forIndexPath:indexPath];
    if (self.DDCustomCollectionBlock) {
        self.DDCustomCollectionBlock(cell, indexPath);
    }
    if (itemsSelect) {
        [self updateCellStatus:cell selected:[itemsSelect[indexPath.row] boolValue]];
    }
       return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.sectionsArray.count) {
          return self.sectionsArray.count;
    }
    return self.classesMutableArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.itemsArray.count) {
        return self.itemsArray.count;
    }
    
    if (self.sectionsArray.count) {
        NSString *sec = [NSString stringWithFormat:@"%lu",section];
        NSArray *array = self.sectionsArray[section][sec];
       return array.count;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //选中之后的cell变颜色
    if ( _selectItemAtIndex > -1 && (itemsSelect.count > 0) && ([itemsSelect[_selectItemAtIndex] integerValue] == 1)) {
        [itemsSelect exchangeObjectAtIndex:_selectItemAtIndex withObjectAtIndex:indexPath.row];
        self.selectItemAtIndex = indexPath.row;
    }
    
    if (self.DDCollectionSelectIndex) {
        self.DDCollectionSelectIndex(indexPath);
    }
    
}

// 改变cell的背景
-(void)updateCellStatus:(UICollectionViewCell *)cell selected:(BOOL)selected
{
    switch (self.cellType) {
        case DDCollectionViewCellDefaultType:
        {
        }
            break;
        case DDCollectionViewCellSecalType:{
            if (selected) {
                cell.layer.transform =  CATransform3DMakeScale(1.05, 1.05, 1.05);
            }else{
                cell.layer.transform =  CATransform3DMakeScale(0.95, 0.95, 0.95);
            }
            [cell setNeedsLayout];
        }
            break;
        default:
            break;
    }
   
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return self.edgeInsetMake;//UIEdgeInsetsMake(1, 1, 1, 1);
    
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 2) {
        return nil;
    }
    headeView *headerView1 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    headerView1.headerTitle = @"hellllo";
    [headerView1.btn setTitle:@"BTN" forState:UIControlStateNormal];
    if (self.footView != nil) {
        //        return self.footView;
        headerView1 = self.footView;
    }
    return headerView1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    if (self.footView) {
//        NSLog(@"\n\n\n===%@\n\n",self.footView);
    }
    return CGSizeMake(200, 20);
}

#warning mark=======
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sectionsSizeArray.count) {
        NSDictionary *dict = self.sectionsSizeArray[indexPath.section];
        CGSize size = CGSizeMake([dict[@"width"] floatValue], [dict[@"height"] floatValue]);
        return size;
    }
    
    return self.itemsSize;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (self.scrollDirection == DDCollectionViewScrollDirectionVertical) {
        return self.edgeInsetMake.right;
    }
    return self.edgeInsetMake.bottom;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (self.scrollDirection == DDCollectionViewScrollDirectionVertical) {
        return self.edgeInsetMake.bottom;
    }
    return self.edgeInsetMake.right;
    
}


- (void)setCellType:(DDCollectionViewCellType)cellType{
    _cellType = cellType;
}

- (void)setSelectItemAtIndex:(NSInteger)selectItemAtIndex{
//    if (_selectItemAtIndex == selectItemAtIndex) {
//        return;
//    }
    
    if ( _selectItemAtIndex > -1 && (itemsSelect.count > 0) && [itemsSelect[_selectItemAtIndex] integerValue] == 1) {
        [itemsSelect exchangeObjectAtIndex:_selectItemAtIndex withObjectAtIndex:selectItemAtIndex];
    }
    _selectItemAtIndex = selectItemAtIndex;
    if (self.cellType == DDCollectionViewCellSecalType) {
        [self.collectionView reloadData];
    }
}



//默认选中第一个
- (void)setItemsArray:(NSArray<NSString *> *)itemsArray{
    _itemsArray = itemsArray;
    for (int i = 0; i < itemsArray.count; i++) {
        if (i == 0) {
            [itemsSelect addObject:@YES];
        }else{
            [itemsSelect addObject:@NO];
        }
    }
    
    [self.collectionView reloadData];
}

- (void)setSectionsArray:(NSArray<NSDictionary *> *)sectionsArray{
    _sectionsArray = sectionsArray;
    [self.collectionView reloadData];
}

- (void)setSectionsSizeArray:(NSArray<NSDictionary *> *)sectionsSizeArray{

    _sectionsSizeArray = sectionsSizeArray;
    
}

- (void)setEdgeInsetMake:(UIEdgeInsets)edgeInsetMake{
    _edgeInsetMake = edgeInsetMake;
    [self.collectionView reloadData];
}

- (void)setItemsSize:(CGSize)itemsSize{

    _itemsSize = itemsSize;
    [self.collectionView layoutIfNeeded];
}
//- (void)setSectionsSizeArray:(NSArray *)sectionsSizeArray{
//    _sectionsSizeArray = sectionsSizeArray;
//}

- (void)setFootView:(id)footView{
    _footView = footView;
}



- (void)setScrollDirection:(DDCollectionViewScrollDirection)scrollDirection{
    switch (scrollDirection) {
        case DDCollectionViewScrollDirectionVertical:
        {
            self.layout.scrollDirection = DDCollectionViewScrollDirectionVertical;
            self.collLayout.scrollDirection = DDCollectionViewScrollDirectionVertical;
        }
            break;
        case DDCollectionViewScrollDirectionHorizontal:
        {
            self.layout.scrollDirection = DDCollectionViewScrollDirectionHorizontal;
            self.collLayout.scrollDirection = DDCollectionViewScrollDirectionHorizontal;
        }
            break;
            
        default:
            break;
    }
}
- (void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    self.collectionView.scrollEnabled = scrollEnabled;
}



#pragma mark ----lazy



- (NSMutableArray *)classesMutableArray{

    if (!_classesMutableArray) {
        _classesMutableArray = [NSMutableArray new];
    }
    return _classesMutableArray;
}


- (DDCustomCollectionFlowLayout *)layout{
    
    if (!_layout) {
        _layout = [[DDCustomCollectionFlowLayout alloc]init];
        _layout._type = S_FlowLayoutTypeScale;
        _layout._itemSize = CGSizeMake(100, 100);
        _layout._itemScale = 1;
//        _layout._items = self.imageArray.count;
    }
    return _layout;
    
}

- (UICollectionViewFlowLayout *)collLayout{
    if (!_collLayout) {
        _collLayout = [[UICollectionViewFlowLayout alloc]init];
        _collLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    return _collLayout;
}


- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height) collectionViewLayout:self.collLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.clipsToBounds = YES;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}










@end
