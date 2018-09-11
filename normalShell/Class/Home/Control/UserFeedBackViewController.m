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
@interface UserFeedBackViewController ()<UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>

{
    UIImagePickerController *pickerController;
}


@property (nonatomic, strong) PlaceholderTextView * textView;
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic, strong) UIButton * sendButton;

@property (nonatomic, strong) NSString *picDataStr;
@property (nonatomic, strong) UIImage *tempImage;



@end

@implementation UserFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0f];
    [self.view addSubview:self.textF];
    [self.view addSubview:self.textView];
    
    if (self.infoDict && self.infoDict[@"title"]) {
        self.textF.text = self.infoDict[@"title"];
    }
    if (self.infoDict && self.infoDict[@"text"]) {
        self.textView.text = self.infoDict[@"text"];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.sendButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:_textF];
    
    
    //初始化pickerController
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.view.backgroundColor = [UIColor whiteColor];
    pickerController.delegate =self;
    pickerController.allowsEditing =YES;
    
    UIButton *ri1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [ri1 setTitle:DSLocalizedString(DS_NOTE_DETAIL_INSETRTIMAGE) forState:UIControlStateNormal];
    [ri1 setTitle:DSLocalizedString(DS_NOTE_DETAIL_INSETRTIMAGE) forState:UIControlStateHighlighted];
    ri1.titleLabel.font = [UIFont systemFontOfSize:14];
    [ri1 setTitleColor:DS_COLOR_HEXCOLOR(@"666666") forState:UIControlStateHighlighted];
    [ri1 setTitleColor:DS_COLOR_HEXCOLOR(@"666666") forState:UIControlStateNormal];
    [ri1 addTarget:self action:@selector(configPic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:ri1];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)configPic{
    
   
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionImg = [UIAlertAction actionWithTitle:DSLocalizedString(DS_MINE_PHOTOS) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [self choosePicture];
        }else{
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                [self choosePicture];
            }else{
                //                    [[sShowTisWindow shareTipsWindow] showAlertWithTitle:@"温馨提示" Message:@"请在设置-->隐私-->相片，中开启本应用的相机访问权限！！" Cancel:@"取消" Delegate:weakSelf];
                [self.view makeToast:@"请在设置-->隐私-->相片，中开启本应用的相机访问权限！！" duration:0.5 position:CSToastPositionCenter];
            }
        }
    }];
    UIAlertAction *actionCamer = [UIAlertAction actionWithTitle:DSLocalizedString(DS_MINE_CAMERA) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            [self makePhoto];
        }else{
            //                [[sShowTisWindow shareTipsWindow] showAlertWithTitle:@"温馨提示" Message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" Cancel:@"取消" Delegate:weakSelf];
            [self.view makeToast:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" duration:0.5 position:CSToastPositionCenter];
        }
    }];
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:DSLocalizedString(DS_HOME_CLOCK_BTN_CANCEL) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:actionCamer];
    [alertView addAction:actionImg];
    [alertView addAction:actionCancle];
    [self presentViewController:alertView animated:YES completion:nil];
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
        _textF.font = [UIFont systemFontOfSize:15];
        _textF.textColor = DS_COLOR_HEXCOLOR(@"333333");
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
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [DS_COLOR_HEXCOLOR(@"333333") colorWithAlphaComponent:0.7];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
    NSDate *date = [NSDate new];
    NSTimeInterval timer = [date timeIntervalSince1970];
    NSString *timeS = [NSString stringWithFormat:@"%.0lf", timer];
    if (self.infoDict[@"ID"] && [self.infoDict[@"ID"] length]) {
        timeS = self.infoDict[@"ID"];
    }
    NSDictionary *cureDict = @{@"title":title, @"text":text, @"ID": timeS, @"image": self.picDataStr ?: self.infoDict[@"image"] ?:@""};
    
    id dataArray = [[DsDatabaseManger shareManager] fetchNotes];
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        NSArray *dataArr = (NSArray*)dataArray;
        [tempArr addObjectsFromArray:dataArr];
    }
    BOOL isReEdit = NO;
    for (int i = 0; i < tempArr.count; i ++) {
        NSDictionary *dict = tempArr[i];
        if ([self.infoDict isEqual:dict]) {
            isReEdit = YES;
            [tempArr replaceObjectAtIndex:i withObject:cureDict];
            break;
        }
    }
    if (!isReEdit) {
        [tempArr addObject:cureDict];
    }
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

//change headImage
- (void)changeUserHeadImageWithHeadImgBase64:(NSString *)headImgBase64{
    
//    [DsUtils write2UserDefaults:headImgBase64 forKey:@"headImage"];
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:headImgBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:imageData];
    
//    self.headerView.headImagV.image =image;
//
//    self.headeImageV.image = image;
}

- (void)makePhoto
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated: YES completion:nil];
}
- (void)choosePicture
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerController animated: YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSData *imageData = nil;
    UIImage *userImage = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    self.tempImage = userImage;
    NSString *str = @"";
    if ([self imageHasAlpha:userImage]) {
        imageData = UIImagePNGRepresentation(userImage);
        //        str = @"data:image/png;base64,";
    } else {
        imageData =UIImageJPEGRepresentation(userImage,0.3f);
        //        str = @"data:image/jpeg;base64,";
    }
    NSString * dataStr = [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    NSString *pictureDataString = [NSString stringWithFormat:@"%@%@",str,dataStr];
    self.picDataStr = [pictureDataString copy];
    [self changeUserHeadImageWithHeadImgBase64:pictureDataString];
    [picker dismissViewControllerAnimated:YES completion:nil];
}




-(BOOL)imageHasAlpha:(UIImage *)image{
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

//缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0,0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    return scaledImage;
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform =CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform =CGAffineTransformRotate(transform,M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform =CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform =CGAffineTransformRotate(transform,M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform =CGAffineTransformTranslate(transform,0, aImage.size.height);
            transform =CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform =CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform =CGAffineTransformScale(transform, -1,1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform =CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform =CGAffineTransformScale(transform, -1,1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}




@end
