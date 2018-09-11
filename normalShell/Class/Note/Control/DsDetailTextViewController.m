//
//  DsDetailTextViewController.m
//  normalShell
//
//  Created by 孟博 on 2018/2/25.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsDetailTextViewController.h"
#import "UserFeedBackViewController.h"


@interface DsDetailTextViewController ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UIImageView *pickImageV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *textLabel;
@end

@implementation DsDetailTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = DSLocalizedString(DS_NOTE_DETAIL_TITLE);//[_dict objectForKey:@"title"];
    
    [self creatUI];
    [self configConstrains];
    
    UIButton *ri1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [ri1 setTitle:DSLocalizedString(DS_NOTE_DETAIL_EDIT) forState:UIControlStateNormal];
    [ri1 setTitle:DSLocalizedString(DS_NOTE_DETAIL_EDIT) forState:UIControlStateHighlighted];
    ri1.titleLabel.font = [UIFont systemFontOfSize:14];
    [ri1 setTitleColor:DS_COLOR_HEXCOLOR(@"666666") forState:UIControlStateHighlighted];
    [ri1 setTitleColor:DS_COLOR_HEXCOLOR(@"666666") forState:UIControlStateNormal];
    [ri1 addTarget:self action:@selector(editNote:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:ri1];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    id dataArray = [[DsDatabaseManger shareManager] fetchNotes];
    
    if ([dataArray isKindOfClass:[NSArray class]]) {
        NSArray *dataArr = (NSArray*)dataArray;
        for (NSDictionary *dic in dataArr) {
            if ([dic[@"ID"] isEqual:self.dict[@"ID"]]) {
                self.dict = [dic copy];
                break;
            }
        }
    }
    
    self.textLabel.text = [self.dict objectForKey:@"text"];
    self.titleLabel.text = [self.dict objectForKey:@"title"];
    if ([self.dict objectForKey:@"image"]) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[_dict objectForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            self.pickImageV.image = image;
        }
        [self configConstrains];
    }
}


- (void)editNote:(UIButton *)btn{
    UserFeedBackViewController *vc = [UserFeedBackViewController new];
    vc.infoDict = [self.dict copy];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)creatUI{
    
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgScrollView];
    
    [self.bgScrollView addSubview:self.pickImageV];
    [self.bgScrollView addSubview:self.titleLabel];
    [self.bgScrollView addSubview:self.textLabel];
}

- (void)configConstrains{
    if ([_dict objectForKey:@"image"]) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[_dict objectForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            self.pickImageV.image = image;
        }
    }
    
    CGFloat H = 0.0f;
    if (self.pickImageV.image) {
        CGSize size = self.pickImageV.image.size;
        H = (DS_APP_SIZE_WIDTH - 40) / size.width * size.height;
        
        [self.pickImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgScrollView).offset(20);
            make.centerX.equalTo(self.bgScrollView);
            make.left.equalTo(self.bgScrollView).offset(20);
            make.right.equalTo(self.bgScrollView).offset(-20);
            make.height.equalTo(@(H));
        }];
        
        
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgScrollView);
        make.top.equalTo(self.bgScrollView).offset( H + 40);
        make.height.equalTo(@40);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.bgScrollView).offset(15);
        make.right.equalTo(self.bgScrollView).offset(-15);
        make.bottom.equalTo(self.bgScrollView).offset(-50);
    }];
    
    
    
}




- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor = DS_COLOR_HEXCOLOR(@"333333");
        _titleLabel.numberOfLines = 0;
        
    }
    return _titleLabel;
}


-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        
        _textLabel.numberOfLines = 0;
//        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = DS_COLOR_HEXCOLOR(@"666666");
    }
    return _textLabel;
}

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH, DS_APP_SIZE_HEIGHT - DS_APP_NAV_HEIGHT)];
    }
    return _bgScrollView;
}




- (UIImageView *)pickImageV{
    if (!_pickImageV) {
        _pickImageV = [UIImageView new];
        _pickImageV.layer.cornerRadius = 4.0f;
        _pickImageV.clipsToBounds = YES;
    }
    return _pickImageV;
}

@end
