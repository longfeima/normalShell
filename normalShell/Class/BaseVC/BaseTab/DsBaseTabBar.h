//
//  DsBaseTabBar.h
//  WBuild
//
//  Created by Seven on 2017/7/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DsTabBarProtocol.h"
@interface DsCustomBarItemView : UIView
@end


@interface DsBaseTabBar : UITabBarController

@property (nonatomic, assign) id<DsTabBarProtocol>delegate;

/**
 tab items select index
 */
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) NSInteger showRedPointAtIndex;
/**
 @[@"0",@"1",@"1",@"0"]
 */
@property (nonatomic, strong) NSArray<NSString *> *showRedPointsAtIndexs;

@property (nonatomic, strong) NSString *tabLocalAdvImageString;
@property (nonatomic, strong) NSString *tabAdvImageURL;


- (void)showBadgeAtIndex:(NSInteger)index number:(NSString *)number;
/**
 @[@"0",@"1",@"1",@"1"] ——》 @[@"0",@"100",@"50",@"10"]
 */
- (void)showBadgesAtIndexs:(NSArray<NSString *> *)indexs numbers:(NSArray<NSString *> *)numbers;
/**change icon if icons.count == 0 invalid icons.count can small than self.viewControlers.count*/
- (void)changeTabImageWithIconsArray:(NSArray<NSString *> *)icons;

/**change icon if icons.count == 0 invalid icons.count can small than self.viewControlers.count*/
- (void)changeTabImageWithIconsArray:(NSArray<NSString *> *)icons SeletedImageWithIconsArray:(NSArray<NSString *> *)selectedIcons;

/**change titles if icons.count == 0 invalid icons.count can small than self.viewControlers.count*/
- (void)changeTabTitleWithTitlesArray:(NSArray<NSString *> *)titles;

/**This method use changeTabImageWithIconsArray: && changeTabTitleWithTitlesArray:*/
- (void)changeTabImageWithIconsArray:(NSArray<NSString *> *)icons Titles:(NSArray<NSString *> *)titles;

- (void)cancelTabImagesChanges;
- (void)cancelTabImagesAndSelectedImagesChanges;
- (void)cancelTabTitlesChanges;
- (void)cancelTabImagesAndTitlesChanges;



@end
