//
//  DsMineViewController.m
//  normalShell
//
//  Created by Seven on 2018/2/22.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsMineViewController.h"
#import <UIView+Toast.h>
#import "DsMoreHeadView.h"

//#import "DsTerminalsTableViewCell.h"
#import "DsValue1TableViewCell.h"


//#import "DsServiceViewController.h"
//#import "DsClientViewController.h"
//#import "DsCheckViewController.h"
#import "DsSeetingViewController.h"

//#import "DsMessageViewController.h"


@interface DsMineViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate, sTipsWindowProtocol>


{
    UIImagePickerController *pickerController;
}

@property (nonatomic, strong) DsMoreHeadView *headerView;
@property (nonatomic ,strong) UIImageView *headeImageV;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;


@property (nonatomic, strong) UIImage *tempImage;
@end




#define HEADER_HIGHT            250
#define HEADER_MINY             0

@implementation DsMineViewController

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]initWithArray:@[
                                                             @{@"title": DSLocalizedString(DS_MINE_ABOUTUS_TITLE),
                                                               @"detail": DSLocalizedString(DS_MINE_ABOUTUS_DETAIL),
                                                               @"imageUrl": @"guanyuwomen"},
                                                             @{@"title": DSLocalizedString(DS_MINE_VERSION_TITLE),
                                                               @"detail": DSLocalizedString(DS_MINE_VERSION_DETAIL),
                                                               @"imageUrl": @"dangqianbanben"}
//                                                             ,
//                                                             @{@"title": DSLocalizedString(DS_MINE_SETTING_TITLE),
//                                                               @"detail": DSLocalizedString(DS_MINE_SETTING_DETAIL),
//                                                               @"imageUrl": @"setting"}
                                                             ]];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //不登录不做请求
    // Do any additional setup after loading the view.
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.navigationView.backgroundColor = [UIColor clearColor];
//    self.navigationView.navType = DD_DefaultType;
//    self.navigationView.hidden = YES;
//    self.navigationView.titleLb.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self createData];
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)createData
{
    //初始化pickerController
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.view.backgroundColor = [UIColor whiteColor];
    pickerController.delegate =self;
    pickerController.allowsEditing =YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    DS_APP_DELEGATE.rootTab.selectedIndex = 2;
}



- (void)getMessageNumber{
    
    
    
}

- (void)creatUI{
    [self tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(HEADER_HIGHT, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -HEADER_HIGHT);
    self.headerView = [DsMoreHeadView new];
    UIImage *image;// = [UIImage imageNamed:@"1.jpg"];
    if ([DsUtils fetchFromUserDefaultsWithKey:@"headImage"]) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[DsUtils fetchFromUserDefaultsWithKey:@"headImage"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        image = [UIImage imageWithData:imageData];
    }else{
        image = [UIImage imageNamed:@"1.jpg"];
    }
    self.headeImageV.image = image;
    self.headerView.headImagV.image = image;
    self.headerView.frame = CGRectMake(0, 0, DS_APP_SIZE_WIDTH, HEADER_HIGHT);
    self.headeImageV.frame = self.headerView.frame;
    __weak DsMineViewController *weakSelf = self;
    self.headerView.moreHeadeClickBlock = ^(NSInteger index){
//        [[sShowTisWindow shareTipsWindow] showSheetWithObject:@[DSLocalizedString(DS_MINE_CAMERA),DSLocalizedString(DS_MINE_PHOTOS)] Title:@" " Delegate:weakSelf Type:Ds_Sheet_Default];
//        [sShowTisWindow shareTipsWindow].isClickHide = YES;
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionImg = [UIAlertAction actionWithTitle:DSLocalizedString(DS_MINE_PHOTOS) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                [weakSelf choosePicture];
            }else{
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    [weakSelf choosePicture];
                }else{
//                    [[sShowTisWindow shareTipsWindow] showAlertWithTitle:@"温馨提示" Message:@"请在设置-->隐私-->相片，中开启本应用的相机访问权限！！" Cancel:@"取消" Delegate:weakSelf];
                    [weakSelf.view makeToast:@"请在设置-->隐私-->相片，中开启本应用的相机访问权限！！" duration:0.5 position:CSToastPositionCenter];
                }
            }
        }];
        UIAlertAction *actionCamer = [UIAlertAction actionWithTitle:DSLocalizedString(DS_MINE_CAMERA) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                [weakSelf makePhoto];
            }else{
//                [[sShowTisWindow shareTipsWindow] showAlertWithTitle:@"温馨提示" Message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" Cancel:@"取消" Delegate:weakSelf];
                [weakSelf.view makeToast:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" duration:0.5 position:CSToastPositionCenter];
            }
        }];
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:DSLocalizedString(DS_HOME_CLOCK_BTN_CANCEL) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alertView addAction:actionCamer];
        [alertView addAction:actionImg];
        [alertView addAction:actionCancle];
        [weakSelf presentViewController:alertView animated:YES completion:nil];
    };
    [self.headerView addSubview:self.headeImageV];
    [self.headerView sendSubviewToBack:self.headeImageV];
    [self.view addSubview:_headerView];
    [self.view bringSubviewToFront:self.headerView];
    self.tableView.backgroundColor = DS_COLOR_HEXCOLOR(@"f1f1f1");
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    UIImage *image;// = [UIImage imageNamed:@"1.jpg"];
    if ([DsUtils fetchFromUserDefaultsWithKey:@"headImage"]) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[DsUtils fetchFromUserDefaultsWithKey:@"headImage"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        image = [UIImage imageWithData:imageData];
    }else{
        image = [UIImage imageNamed:@"1.jpg"];
    }
    
    CGFloat wigth = image.size.width;
    CGFloat height = image.size.height;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (offset.y <= 0 && -offset.y >= HEADER_MINY) {
            CGRect newFrame = CGRectMake(0, 0, DS_APP_SIZE_WIDTH, - offset.y);
            _headerView.frame = newFrame;
            if (- offset.y <= HEADER_HIGHT) {
                self.tableView.contentInset = UIEdgeInsetsMake(- offset.y, 0, 0, 0);
                CGRect frame = CGRectMake(0, - (HEADER_HIGHT + offset.y), DS_APP_SIZE_WIDTH,  HEADER_HIGHT);
                self.headerView.frame = frame;
            }
            if(- offset.y > HEADER_HIGHT){
                CGRect fram = CGRectMake(0, 0, MAX(wigth/height*(- offset.y), DS_APP_SIZE_WIDTH), - offset.y);
                self.headeImageV.bounds = fram;
                self.headeImageV.center = self.headerView.center;
            }
        }
        if (- offset.y < HEADER_MINY) {
            CGRect fram = CGRectMake(0, -HEADER_HIGHT, DS_APP_SIZE_WIDTH, HEADER_HIGHT);
            self.headerView.frame = fram;
        }
    }
}

//change headImage
- (void)changeUserHeadImageWithHeadImgBase64:(NSString *)headImgBase64{
    
    [DsUtils write2UserDefaults:headImgBase64 forKey:@"headImage"];
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:headImgBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:imageData];
    
    self.headerView.headImagV.image =image;
    
    self.headeImageV.image = image;    
}



//sTipsWindowProtocol
- (void)sSheetViewSelectIndex:(NSInteger)index{
    
    switch (index) {
        case -1:
        {
            //取消
        }
            break;
        case 1:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                [self makePhoto];
            }else{
                [[sShowTisWindow shareTipsWindow] showAlertWithTitle:@"温馨提示" Message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" Cancel:@"取消" Delegate:self];
            }
        }
            break;
        case 2:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                [self choosePicture];
            }else{
                [[sShowTisWindow shareTipsWindow] showAlertWithTitle:@"温馨提示" Message:@"请在设置-->隐私-->相片，中开启本应用的相机访问权限！！" Cancel:@"取消" Delegate:self];
            }
            
        }
            break;
            
        default:
            break;
    }
    [[sShowTisWindow shareTipsWindow] hideWindowSubviews];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString *cellInd = @"cellInd";
    DsValue1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInd];
    if (!cell) {
        cell = [[DsValue1TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellInd];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.infoDict = self.dataSource[indexPath.item];
    cell.accessoryImgV.hidden = self.dataSource.count != indexPath.item;
    //    cell.textLabel.text = [NSString stringWithFormat:@"第%lu行",indexPath.item];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 2) {
        [self DDRightBarButtonItem];
        return;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (void)DDRightBarButtonItem{
    DsSeetingViewController *setting = [[DsSeetingViewController alloc]init];
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}








- (void)makePhoto
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated: YES completion:nil];
}
- (void)choosePicture
{
    pickerController.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
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













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---lazy


- (UIImageView *)headeImageV{
    if (!_headeImageV) {
        _headeImageV = [[UIImageView alloc]init];
        _headeImageV.alpha = 0.98;
        UIToolbar *tool = [[UIToolbar alloc]init];
        tool.alpha = 0.5;
        [_headeImageV addSubview:tool];
        [tool mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_headeImageV);
        }];
    }
    return _headeImageV;
}


- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT - 49 - HEADER_MINY) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.001, 0.01)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
