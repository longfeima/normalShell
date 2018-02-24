//
//  DsClockViewController.h
//  normalShell
//
//  Created by Seven on 2018/2/23.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsBaseViewController.h"

typedef void (^dateBtnClickBlock)(NSString *date);

@interface DsClockView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;


@property (nonatomic, strong) NSString *hourStr;
@property (nonatomic, strong) NSString *minuteStr;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, copy) dateBtnClickBlock cancelBlock;
@property (nonatomic, copy) dateBtnClickBlock confirmBlock;

@end

@interface DsClockViewController : DsBaseViewController

@end
