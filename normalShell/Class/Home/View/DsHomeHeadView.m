//
//  DsHomeHeadView.m
//  DDService
//
//  Created by Seven on 2017/7/13.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsHomeHeadView.h"


@interface DsHomeHeadView ()




@end


@implementation DsHomeHeadView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        UIImage *image = [UIImage imageNamed:@"bg_recommend_blue"];
        [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        
        self.image = image;
        [self creatUI];
        [self confConstrain];
    }
    return self;
}

- (void)creatUI{

    self.dataSource = [NSArray new];//@[@13, @20, @17, @20];
    self.describeSource = [NSArray new];//@[@"helllo",@"HI",@"hhha",@"dsfhak"];

}

- (void)confConstrain{
    
    
}

- (void)setDataSource:(NSArray *)dataSource{

    _dataSource = dataSource;
    
    
}
- (void)setDescribeSource:(NSArray<NSString *> *)describeSource{
    _describeSource = describeSource;
    
}

- (void)setCenterTitle:(NSString *)centerTitle{

    _centerTitle = centerTitle;
    
}





@end
