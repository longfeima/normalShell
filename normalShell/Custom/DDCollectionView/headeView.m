//
//  headeView.m
//  textCollectionView
//
//  Created by Seven on 2017/4/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？




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
