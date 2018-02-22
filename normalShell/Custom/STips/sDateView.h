//
//  sDateView.h
//  sTips
//
//  Created by Seven on 2017/8/14.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sDateView : UIView<sTipsWindowProtocol>

@property (nonatomic, assign) id<sTipsWindowProtocol>delegate;



@property (nonatomic, strong)  void(^confirmBtnClick)(NSString *startDay, NSString *endDay);

- (void)showDateViewWithType:(Ds_DateType)type;

- (void)showDateViewWithType:(Ds_DateType)type DateString:(NSString *)date Formatter:(NSString *)formatter;


@end
