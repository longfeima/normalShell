//
//  DDBaseNavHorizontalView.h
//  DDSC
//
//  Created by CaydenK on 2017/3/19.
//  Copyright © 2017年 ddsoucai. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface titleBtn : UIButton

@end



@interface DDBaseNavHorizontalView : UIView

@property (nonatomic, strong) NSArray<NSString*> *titleArray;
/**
 == -1 || > self.titleArray
 */
@property (nonatomic, assign) NSInteger selectItemAtIndex;

@property (nonatomic, strong)  void(^DDNavHorizotalViewBlock)(NSInteger index);
@end
