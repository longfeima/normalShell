//
//  sSheetView.h
//  sTips
//
//  Created by Seven on 2017/7/25.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "sTipsWindowProtocol.h"

//typedef enum : NSUInteger {
//    Ds_Sheet_Default,           //looks like system sheet(title && items && cancel<index == 0>)
//    Ds_Sheet_Normal             //title and items
//} Ds_SheetType; 、、、、、、、、、、、、


@interface sSheetView : UIView<sTipsWindowProtocol>

@property (nonatomic, assign) id<sTipsWindowProtocol>delegate;

- (void)showSheetWithObject:(NSArray <NSString *>*)items Title:(NSString *)title Type:(Ds_SheetType)type;

@end
