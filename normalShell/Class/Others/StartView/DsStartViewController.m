//
//  DsStartViewController.m
//  WBuild
//
//  Created by Seven on 2017/7/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsStartViewController.h"

static NSInteger const kPageCount = 4;

@interface DsStartViewController ()

@property (nonatomic, strong) UIImageView *startIV;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DsStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == LanuchTypeGuide) {
        [self initGuideView];
    } else {
        [self getLaunchImage];
        [self setupStartImage];
    }
    
    // Do any additional setup after loading the view.
}

- (void)initGuideView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor blueColor];
    _scrollView.contentSize = CGSizeMake(DS_APP_SIZE_WIDTH * kPageCount, DS_APP_SIZE_HEIGHT);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];

    for (int i = 0; i < kPageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d_%d.jpg", (int)DS_APP_SIZE_HEIGHT, i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(DS_APP_SIZE_WIDTH * i, 0, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT);
        imageView.backgroundColor = DS_COLOR_RANDOM;
        [_scrollView addSubview:imageView];

        if (i == (kPageCount - 1)) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterMainVC:)];
            [imageView addGestureRecognizer:tapGesture];
            imageView.userInteractionEnabled = YES;
        }
    }
}


- (void)setupStartImage {
//    DsGlobalModel *globalModel = [DsGlobalManager sharedClient].globalModel;
//
//    NSString *imageUrl = globalModel.welcomeImageUrl;
//    if (imageUrl.length > 0) {
//        NSString *key = [imageUrl dd_MD5String];
//
//        [[SDImageCache sharedImageCache] queryCacheOperationForKey:key done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
//            if (image) {
//                [self animationStartImage:image];
//            } else {
//                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl]
//                                                                      options:SDWebImageDownloaderContinueInBackground
//                                                                     progress:nil
//                                                                    completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                                                                        if (image && finished) {
//                                                                                [self animationStartImage:image];
//                                                                                [[SDImageCache sharedImageCache] storeImage:image forKey:key toDisk:YES completion:nil];
//                                                                        }
//                                                                    }];
//            }
//        }];
//    }
//    [self performSelector:@selector(enterMainVC:) withObject:nil afterDelay:globalModel.welcomeLaunchTime];
}


- (void)animationStartImage:(UIImage *)image {
//    self.startIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT)];
//    self.startIV.contentMode = UIViewContentModeScaleToFill;
    self.startIV.image = image;
    //[self.view addSubview:self.startIV];
}


- (void)enterMainVC:(id)sender {
//    if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
//        [DsUtils write2UserDefaults:@(YES) forKey:UD_FIRST_START([DsGlobalManager sharedClient].globalModel.appVersion)];
//    }
//
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enterMainVC:) object:nil];
//    [UIView animateWithDuration:0.6 animations:^{
//        DS_APP_DELEGATE.startWindow.alpha = 0;
//    } completion:^(BOOL finished) {
//
//        [DS_APP_DELEGATE.startWindow resignKeyWindow];
//        [DS_APP_DELEGATE.window makeKeyAndVisible];
//        DS_APP_DELEGATE.startWindow.hidden = YES;
//        [self removeFromParentViewController];
//    }];
}

- (void)getLaunchImage{
//    NSString *viewOrientation = @"Portrait";
//    NSString *lanuchImage = nil;
//    NSArray *imagedDict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchImages"];
//    for (NSDictionary *dict in imagedDict) {
//        CGSize imageSize =CGSizeFromString(dict[@"UILaunchImageSize"]);
//        if (CGSizeEqualToSize(imageSize, DS_APP_SIZE) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
//            lanuchImage = dict[@"UILaunchImageName"];
//        }
//    }
//    if (lanuchImage.length) {
//        self.startIV.image = [UIImage imageNamed:lanuchImage];
//    }
}

- (UIImageView *)startIV{
    
    if (!_startIV) {
        _startIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT)];
        _startIV.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:_startIV];
    }
    return _startIV;
}

@end

