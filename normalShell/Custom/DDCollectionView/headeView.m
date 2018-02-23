//
//  headeView.m
//  textCollectionView
//
//  Created by Seven on 2017/4/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "headeView.h"

@interface headeView ()

{
    UILabel *titleLabel;
}

@end


@implementation headeView


-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=[UIColor greenColor];
        [self createBasicView];
    }
    return self;
    
}


-(void)createBasicView{
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,self.frame.size.width-50, self.frame.size.height)];
    [self addSubview:titleLabel];
    
}


- (void)setHeaderTitle:(NSString *)headerTitle{

    titleLabel.text = headerTitle;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(5, 0,self.frame.size.width-50, self.frame.size.height)];
        _btn.backgroundColor = [UIColor yellowColor];
        [self addSubview:_btn];
    }
    return _btn;
}


@end
