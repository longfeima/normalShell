//
//  sShareView.h
//  sTips
//
//  Created by Seven on 2017/7/24.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sTipsWindowProtocol.h"


@interface sShareViewItem : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     NorImage:(NSString *)norImage
                     PreImage:(NSString *)preImage
                        Title:(NSString *)title;

@end



typedef enum : NSUInteger {
    Ds_Share_QQ,
    Ds_Share_WeChat,
    Ds_Share_Moments,
}DsShareType;

@interface sShareView : UIView<sTipsWindowProtocol>

@property (nonatomic, assign) id<sTipsWindowProtocol>delegate;


- (void)confWithArray:(NSArray <NSArray <NSString *> *> *)confArr;

@end
