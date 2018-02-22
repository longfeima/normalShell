//
//  DDBaseNavColumnView.h
//  textNav
//
//  Created by Seven on 2017/4/9.
//  Copyright © 2017年 CaydenK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBaseNavColumnView : UIView

@property (nonatomic, strong) NSArray<NSString*> *titleArray;

@property (nonatomic, strong)  void(^DDNavColumnViewBlock)(NSInteger index);

//- (instancetype)initWithFrame:(CGRect)frame AndDelegate:(id)delegate;

@end
