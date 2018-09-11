//
//  DsNoteTableViewCell.h
//  normalShell
//
//  Created by 龙飞马 on 2018/9/3.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DsNoteTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLine;
@property (nonatomic, strong) UILabel *buttomLine;

@property (nonatomic, strong) NSDictionary *infoDict;

@end
