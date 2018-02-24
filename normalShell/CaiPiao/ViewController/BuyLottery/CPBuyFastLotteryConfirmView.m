//
//  CPBuyCustomLotteryConfirmView.m
//  lottery
//
//  Created by wayne on 2017/9/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBuyFastLotteryConfirmView.h"

@interface CPBuyFastLotteryConfirmView ()<UITextFieldDelegate>
{
    IBOutlet UIView *_contentView;
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_contentLabel;
    
    IBOutlet UITextField *_betAmountTf;
    
    NSString *_numberPeriods;
    NSArray *_lotterys;
}


@property(nonatomic,copy)CPBuyFastLotteryConfirmAction confirm;
@property(nonatomic,assign)int specailType;
@end

@implementation CPBuyFastLotteryConfirmView

+(void)showFastLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                                comfirm:(CPBuyFastLotteryConfirmAction)confirm
{
    [CPBuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:supView lotterys:lotterys numberPeriods:numberPeriods specailType:0 comfirm:confirm];
}

+(void)showFastLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                            specailType:(int)specailType
                                comfirm:(CPBuyFastLotteryConfirmAction)confirm
{
    CPBuyFastLotteryConfirmView *view = [CPBuyFastLotteryConfirmView createViewFromNib];
    view.specailType = specailType;
    [view showOnView:supView lotterys:lotterys numberPeriods:numberPeriods comfirm:confirm];
}

#pragma mark- buttonAction


- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.confirm) {
        BOOL isConfirm = (sender.tag == 11)?NO:YES;
        if (isConfirm && [_betAmountTf.text intValue] == 0) {
            [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请填写下注金额"];
            return;
        }
        self.confirm(isConfirm,_betAmountTf.text);
    }
    [self dismiss];
}

-(void)showOnView:(UIView *)onView
         lotterys:(NSArray *)lotterys
    numberPeriods:(NSString *)numberPeriods
          comfirm:(CPBuyFastLotteryConfirmAction)confirm
{
    _numberPeriods = numberPeriods;
    _lotterys = lotterys;
    self.confirm = confirm;

    self.frame = CGRectMake(0, 0, onView.width, onView.height);
    [self layoutSubviews];
    

    
    NSString *title = [NSString stringWithFormat:@"请确认当前第%@期",numberPeriods];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[title rangeOfString:numberPeriods]];
    _titleLabel.attributedText = att;

    int line = 4;
    if (self.specailType == 2) {
        line = 2;
    }
    
    CGFloat gap = 3;
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat height = 40.0f;
    CGFloat width = (_scrollView.width - (2+line)*gap)/line;
    if (self.specailType == 1) {
        width = _scrollView.width - 2*gap;
    }else if(self.specailType == 2){
        width = (_scrollView.width - 3*gap)/2.0f;
    }
    NSInteger row = lotterys.count/line;
    row = lotterys.count%line>0?row+1:row;
    
    CGFloat contentHeight = 0;
    for (int r = 0; r<row; r++) {
        originY = gap+(gap+height)*r;
        for (int l = 0; l<line; l++) {
            originX = gap+(gap+width)*l;
            NSInteger index = r*line + l;
            if (index>=lotterys.count) {
                break;
            }
            NSDictionary *info = [lotterys objectAtIndex:index];
            NSString *sectionName = [info DWStringForKey:@"sectionName"];
            NSString *haoString = [SUMUser shareUser].buyLotteryDetailHasNumberPan?@"号":@"";
            NSString *title = [NSString stringWithFormat:@"%@%@%@",sectionName,[info DWStringForKey:@"playName"],haoString];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY,width,height)];
            label.text = title;
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = kCOLOR_R_G_B_A(252, 14, 28, 1);
            label.numberOfLines = 0;
            [_scrollView addSubview:label];
            contentHeight = label.bottomY;
        }
    }
    
    CGFloat othersHeight = 215;
    CGFloat scrollHeight = (contentHeight+othersHeight>=self.height*0.7)?(self.height*0.7-othersHeight):contentHeight;
    
    _contentView.height = othersHeight+scrollHeight;
    [_contentView layoutSubviews];
    
    _contentView.centerY = (self.height-_contentView.height)/2.0f+_contentView.height/2.0f;
    _scrollView.contentSize = CGSizeMake(_scrollView.width,contentHeight);
    
    [self showOnView:onView];
}



- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 11:
        {
            //清空充值金额
            _betAmountTf.text = nil;
        }break;
        case 12:
        {
            //充值100
            NSInteger money = [_betAmountTf.text integerValue];
            money += 100;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 13:
        {
            //充值500
            NSInteger money = [_betAmountTf.text integerValue];
            money += 500;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
        }break;
        case 14:
        {
            //充值一千
            NSInteger money = [_betAmountTf.text integerValue];
            money += 1000;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 15:
        {
            //充值五千
            NSInteger money = [_betAmountTf.text integerValue];
            money += 5000;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 16:
        {
            //充值一万
            NSInteger money = [_betAmountTf.text integerValue];
            money += 10000;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 17:
        {
            //充值五万
            NSInteger money = [_betAmountTf.text integerValue];
            money += 50000;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        default:
            break;
    }
    
    [self countContentLabel];

}

#pragma mark- textfieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length>0 && ![self validateNumber:string]) {
        return NO;
    }else if (textField.text.length == 0 && [string intValue]==0) {
        return NO;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self countContentLabel];
    });
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark-

-(void)countContentLabel
{
    
    NSInteger count = _lotterys.count;
    NSInteger allPay = 0;
    CGFloat award = 0;
    CGFloat win = 0;
    NSInteger betValue = [_betAmountTf.text integerValue];
    for (NSDictionary *info in _lotterys) {
        NSInteger bouns = [[NSString stringWithFormat:@"%ld",(NSInteger)([[info DWStringForKey:@"bonus"]floatValue]*100)]integerValue];
        allPay += betValue;
        award = award+(betValue *bouns)/100.0f;
        win = award - allPay;
    }
    
    NSString *countString = [NSString stringWithFormat:@"%ld",count];
    NSString *allPayString = [NSString stringWithFormat:@"%ld",allPay];
    NSString *awardString = [NSString stringWithFormat:@"%.2f",award];
    NSString *winString = [NSString stringWithFormat:@"%.2f",win];
    
    NSString *contentString = [NSString stringWithFormat:@"%@注共%@元，若中奖，奖金%@元，盈利%@元",countString,allPayString,awardString,winString];
    NSMutableAttributedString * attContent = [[NSMutableAttributedString alloc]initWithString:contentString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[contentString rangeOfString:allPayString]];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[contentString rangeOfString:awardString]];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[contentString rangeOfString:winString]];
    _contentLabel.attributedText = attContent;
    

}

-(void)showOnView:(UIView *)onView
{
    self.layer.opacity = 0;
    [onView addSubview:self];
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 1;
    }];
    
}

-(void)dismiss
{
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
