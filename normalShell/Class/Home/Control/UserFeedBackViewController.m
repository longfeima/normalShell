//
//  UserFeedBackViewController.m
//  wyh
//
//  Created by Lee on 16/1/5.
//  Copyright © 2016年 HW. All rights reserved.
//

#import "UserFeedBackViewController.h"
#import "PlaceholderTextView.h"
#import <UIView+Toast.h>
#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kMaxLength 10
@interface UserFeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) PlaceholderTextView * textView;
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic, strong) UIButton * sendButton;

@end

@implementation UserFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0f];
    [self.view addSubview:self.textF];
    [self.view addSubview:self.textView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.sendButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:_textF];
}
-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况   else{
    if (toBeString.length > kMaxLength) {
        textField.text = [toBeString substringToIndex:kMaxLength];
    }
}

-(UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc] initWithFrame:CGRectMake(40, DS_APP_NAV_HEIGHT + 10, DS_APP_SIZE_WIDTH - 80, 40)];
        _textF.font = [UIFont systemFontOfSize:30];
        _textF.backgroundColor = [UIColor whiteColor];
        _textF.textAlignment = NSTextAlignmentCenter;
        _textF.delegate = self;
    }
    return _textF;
}
-(PlaceholderTextView *)textView{

    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_textF.frame) + 10, self.view.frame.size.width - 40, DS_APP_SIZE_HEIGHT - (CGRectGetMaxY(_textF.frame) + 20) - kTabBarHeight - 40)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = kTextBorderColor.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = DSLocalizedString(DS_NOTE_NOTES_DETAIL1);
    }

    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string] == YES)
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}


- (UIButton *)sendButton{

    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 2.0f;
        _sendButton.frame = CGRectMake(40, CGRectGetMaxY(self.textView.frame)+20, self.view.frame.size.width - 80, 40);
        _sendButton.backgroundColor = [self colorWithRGBHex:0x60cdf8];
        [_sendButton setTitle:DSLocalizedString(DS_NOTE_BTN_SAVE) forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendFeedBack) forControlEvents:UIControlEventTouchUpInside];
    }

    return _sendButton;

}
- (void)sendFeedBack{
    NSString *title = _textF.text;
    NSString *text = _textView.text;
    if ([title isEqualToString:@""] || [text isEqualToString:@""]) {
        [self.view makeToast:@"标题且内容不能为空!"];
        return;
    }
    NSDictionary *dict = @{@"title":title,@"text":text};
    
    id dataArray = [[DsDatabaseManger shareManager] fetchNotes];
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        NSArray *dataArr = (NSArray*)dataArray;
        [tempArr addObjectsFromArray:dataArr];
    }
    [tempArr addObject:dict];
    [[DsDatabaseManger shareManager] saveNotesWithArray:[NSArray arrayWithArray:tempArr]];
    [self back:nil];
    NSLog(@"=======%@",self.textView.text);
}

- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
