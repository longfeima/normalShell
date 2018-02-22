//
//  sDateView.m
//  sTips
//
//  Created by Seven on 2017/8/14.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "sDateView.h"

#define DATE_BASE_TAG       1245

@interface sDateView ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UITextField *startField;
@property (nonatomic, strong) UITextField *endField;

@property (nonatomic, assign) Ds_DateType type;


@property (nonatomic, strong) UITextField *firstField;
@property (nonatomic, strong) NSDate *currentMinDate;
@property (nonatomic, strong) NSDate *currentMaxDate;



@property (nonatomic, strong) UIPickerView *datePicker;

@property (nonatomic, strong) UIDatePicker *date;
/**
 时 分
 */
@property (nonatomic, strong) UIDatePicker *countDownTimerDate;

@end


@implementation sDateView

- (instancetype)init{
    
    if (self = [super init]) {
        [self creatUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hello)]];
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showDateViewWithType:(Ds_DateType)type{
    self.type = type;
    switch (type) {
        case Ds_Date_StartAndEndDate:
        {
            [self confStartAndEndTextfielfNormal];
            [self confStartAndEndDateConstrain];
            [self.cancelBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.confirmBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case Ds_Date_Date:
        {
            self.date.datePickerMode = UIDatePickerModeDate;
            NSDateFormatter *formate = [[NSDateFormatter alloc]init];
            [formate setDateFormat:@"yyyyMMdd"];
            NSDate *date = [formate dateFromString:@"20170701"];
            self.date.minimumDate = date;
            self.date.maximumDate = [NSDate date];
            [self confDateConstrain];
            [self.cancelBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.confirmBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case Ds_Date_YmdAndSsm:
        {
            self.date.datePickerMode = UIDatePickerModeDate;
            self.date.minimumDate = [NSDate date];
            NSDateFormatter *formate = [[NSDateFormatter alloc]init];
            [formate setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [formate dateFromString:[NSString calculateTimeAgoWithDays:-30 WithFormat:@"yyyy-MM-dd"]];
            self.date.maximumDate = date;
            
            
            self.countDownTimerDate.datePickerMode = UIDatePickerModeTime;
            self.countDownTimerDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            NSDateFormatter *formate2 = [[NSDateFormatter alloc]init];
            [self confYmdAndSms];
            [self.cancelBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.confirmBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
            break;
    }
}

- (void)showDateViewWithType:(Ds_DateType)type DateString:(NSString *)date Formatter:(NSString *)formatter{
    
    [self showDateViewWithType:type];
    switch (self.type) {
        case Ds_Date_YmdAndSsm:
            {
                NSDateFormatter *formate = [[NSDateFormatter alloc]init];
                [formate setDateFormat:formatter];
                NSDate *dat = [formate dateFromString:date];
                [self.countDownTimerDate setDate:dat animated:YES];
                [self.date setDate:dat animated:YES];
            }
            break;
            
        default:
            break;
    }
}

- (void)itemClick:(UIButton *)btn{
    NSInteger tag = btn.tag - DATE_BASE_TAG;
    if (self.type == Ds_Date_YmdAndSsm && self.delegate && [self.delegate respondsToSelector:@selector(sDateViewClick:SlectElement:)]) {
        NSDate *Ymd = self.date.date;
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy-MM-dd"];
        NSDate *Sm = self.countDownTimerDate.date;
        NSDateFormatter *formate1 = [[NSDateFormatter alloc]init];
        [formate1 setDateFormat:@"HH:mm:ss"];
        NSString *str = [NSString stringWithFormat:@"%@ %@",[formate stringFromDate:Ymd], [formate1 stringFromDate:Sm]];
        [self.delegate sDateViewClick:tag?:-1 SlectElement:str];
        return;
    }
    
    if (self.startField.text.length <= 0 && tag && self.type == Ds_Date_StartAndEndDate) {
        self.startField.backgroundColor = [UIColor redColor];
        return;
    }
    if (self.endField.text.length <= 0 && tag && self.type == Ds_Date_StartAndEndDate) {
        self.endField.backgroundColor = [UIColor redColor];
        return;
    }
    if (self.type == Ds_Date_Date && self.delegate && [self.delegate respondsToSelector:@selector(sDateViewClick:SearchDay:)]) {
        NSDate *date = self.date.date;
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyyMMdd"];
        [formate stringFromDate:date];
        [self.delegate sDateViewClick:tag?:-1 SearchDay:[formate stringFromDate:date]];
        return;
    }
    if ( self.type == Ds_Date_StartAndEndDate && self.delegate && [self.delegate respondsToSelector:@selector(sDateViewClick:StartDay:EndDay:)]) {
        if (btn == self.confirmBtn) {
            NSString *start = [self.startField.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.startField.text.length)];
            NSString *end = [self.endField.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.endField.text.length)];
            [self.delegate sDateViewClick:tag?:-1 StartDay:start EndDay:end];
        }else{
            [self.delegate sDateViewClick:tag?:-1 StartDay:@"" EndDay:@""];
        }
    }
    return;
}



/**type == Ds_Date_StartAndEndDate*/
- (void)confStartAndEndTextfielfNormal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow) name:UIKeyboardWillShowNotification object:nil];
    self.date.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formate dateFromString:@"20170701"];
    self.date.minimumDate = date;
    self.date.maximumDate = [NSDate date];
    self.firstField.textColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
}
- (void)keyBoardWillShow{
    [self.startField resignFirstResponder];
    [self.endField resignFirstResponder];
}
- (void)hello{
    
}

- (void)creatUI{
    
    self.userInteractionEnabled = YES;
    self.bgImageV.userInteractionEnabled = YES;
    self.bgImageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgImageV];
    
    [self.bgImageV addSubview:self.cancelBtn];
    [self.bgImageV addSubview:self.confirmBtn];
    
    [self.bgImageV addSubview:self.startField];
    [self.bgImageV addSubview:self.endField];
    //    [self.bgImageV addSubview:self.datePicker];
    [self.bgImageV addSubview:self.date];
    [self.bgImageV addSubview:self.countDownTimerDate];
    
}
/**StartAndEndDate*/
- (void)confStartAndEndDateConstrain{
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgImageV).offset(10);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageV).offset(10);
        make.right.equalTo(self.bgImageV).offset(-10);
    }];
    UILabel *line = [UILabel new];
    line.backgroundColor = DS_COLOR_HEXCOLOR(@"E7E7E7");
    [self.bgImageV addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn.mas_bottom).offset(5);
        make.left.right.equalTo(self.bgImageV);
        make.height.equalTo(@0.5);
    }];
    
    [self.startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageV).offset(10);
        make.top.equalTo(line.mas_bottom).offset(5);
    }];
    
    [self.endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.startField);
        make.right.equalTo(self.bgImageV).offset(-10);
        make.left.equalTo(self.startField.mas_right).offset(10);
    }];
    UILabel *line2 = [UILabel new];
    line2.backgroundColor = DS_COLOR_HEXCOLOR(@"E7E7E7");
    [self.bgImageV addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startField.mas_bottom).offset(5);
        make.left.right.equalTo(self.bgImageV);
        make.height.equalTo(@0.5);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(5);
        make.left.bottom.right.equalTo(self.bgImageV);
    }];
}

- (void)confDateConstrain{
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgImageV).offset(10);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageV).offset(10);
        make.right.equalTo(self.bgImageV).offset(-10);
    }];
    UILabel *line = [UILabel new];
    line.backgroundColor = DS_COLOR_HEXCOLOR(@"E7E7E7");
    [self.bgImageV addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn.mas_bottom).offset(5);
        make.left.right.equalTo(self.bgImageV);
        make.height.equalTo(@0.5);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(5);
        make.left.bottom.right.equalTo(self.bgImageV);
    }];
}
- (void)confYmdAndSms{
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgImageV).offset(10);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageV).offset(10);
        make.right.equalTo(self.bgImageV).offset(-10);
        make.centerY.equalTo(self.cancelBtn);
    }];
    UILabel *line = [UILabel new];
    line.backgroundColor = DS_COLOR_HEXCOLOR(@"E7E7E7");
    [self.bgImageV addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn.mas_bottom).offset(5);
        make.left.right.equalTo(self.bgImageV);
        make.height.equalTo(@0.5);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(5);
        make.left.equalTo(self.bgImageV).offset(-5);
        make.bottom.equalTo(self.bgImageV);
        make.width.equalTo(@(DS_APP_SIZE_WIDTH/5.0*3 + 35));
    }];
    [self.countDownTimerDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(5);
        make.right.bottom.equalTo(self.bgImageV);
        make.width.equalTo(@(DS_APP_SIZE_WIDTH/5.0*2 + 15));
    }];
}

//textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor clearColor];
    if (textField.text.length) {
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy年MM月dd日"];
        NSDate *date = [formate dateFromString:textField.text];
        [self.date setDate:date animated:YES];
        self.firstField = textField;
    }else{
        NSDate *date = self.date.date;
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy年MM月dd日"];
        textField.text =  [formate stringFromDate:date];
        self.firstField = textField;
    }
    [self adjustDate];
    return YES;
}


-(void)dateChanged{
    NSDate *date = self.date.date;
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy年MM月dd日"];
    self.firstField.text =  [formate stringFromDate:date];
    [self adjustDate];
}

- (void)adjustDate{
    
    if (self.firstField == self.startField && self.endField.text.length > 0) {
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy年MM月dd日"];
        NSDate *date = [formate dateFromString:self.endField.text];
        self.date.maximumDate = date;
        [formate setDateFormat:@"yyyyMMdd"];
        self.date.minimumDate = [formate dateFromString:@"20170701"];
        
    }else if (self.firstField == self.endField && self.firstField.text.length > 0){
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy年MM月dd日"];
        NSDate *date = [formate dateFromString:self.startField.text];
        self.date.minimumDate = date;
        self.date.maximumDate = [NSDate date];
    }
    
}

//picker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 10;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (self.cancelBtn.hidden == NO && self.cancelBtn.alpha > 0 && point.y < CGRectGetMaxY(self.cancelBtn.frame) && point.x < CGRectGetMaxX(self.cancelBtn.frame)) {
        return self.cancelBtn;
    } else if (self.confirmBtn.hidden == NO && self.confirmBtn.alpha > 0 && point.y < CGRectGetMaxY(self.cancelBtn.frame) && point.x > CGRectGetMinX(self.confirmBtn.frame)) {
        return self.confirmBtn;
    }
    
    return [super hitTest:point withEvent:event];
}



#pragma mark---------lazy

- (UIImageView *)bgImageV{
    
    if (!_bgImageV) {
        _bgImageV = [UIImageView new];
    }
    return _bgImageV;
}

- (UIButton *)cancelBtn{
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[DS_COLOR_HEXCOLOR(@"57C9E8") colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        _cancelBtn.tag = DATE_BASE_TAG;
        
    }
    return _cancelBtn;
}
- (UIButton *)confirmBtn{
    
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.tag = DATE_BASE_TAG + 1;
        [_confirmBtn setTitleColor:DS_COLOR_HEXCOLOR(@"57C9E8") forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];

    }
    return _confirmBtn;
}

- (UITextField *)startField{
    
    if (!_startField) {
        _startField = [UITextField new];
        _startField.delegate = self;
        _startField.borderStyle = UITextBorderStyleRoundedRect;
        _startField.placeholder = @"请输入开始时间";
    }
    return _startField;
}

- (UITextField *)endField{
    
    if (!_endField) {
        _endField = [UITextField new];
        _endField.delegate = self;
        _endField.borderStyle = UITextBorderStyleRoundedRect;
        _endField.placeholder = @"请输入结束时间";
    }
    return _endField;
}

- (UIPickerView *)datePicker{
    
    if (!_datePicker) {
        
        _datePicker = [UIPickerView new];
        
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
        _datePicker.userInteractionEnabled = YES;
        
    }
    return _datePicker;
}

- (UIDatePicker *)date{
    
    if (!_date) {
        NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans"];
        _date = [UIDatePicker new];
        
        _date.locale = locale;
        [_date addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _date;
}

- (UIDatePicker *)countDownTimerDate{

    if (!_countDownTimerDate) {
        _countDownTimerDate = [UIDatePicker new];
        _countDownTimerDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [_countDownTimerDate addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _countDownTimerDate;
}


@end
