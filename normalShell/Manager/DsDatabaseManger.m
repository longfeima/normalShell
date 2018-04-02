//
//  DsDatabaseManger.m
//  normalShell
//
//  Created by Seven on 2018/2/24.
//  Copyright © 2018年 Seven. All rights reserved.
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



#import "DsDatabaseManger.h"
#import "YTKKeyValueStore.h"

#define DS_DATABASE_NAME    @"database.db"

/**闹钟相关*/
#define DS_DATABASE_TABLE_CLOCKS  @"DS_DATABASE_TABLE_CLOCKS"
#define DS_DATABASE_KEY_CLOCKS    @"DS_DATABASE_KEY_CLOCKS"

/**记事本相关*/
#define DS_DATABASE_TABLE_NOTES  @"DS_DATABASE_TABLE_NOTES"
#define DS_DATABASE_KEY_NOTES    @"DS_DATABASE_KEY_NOTES"

@interface DsDatabaseManger()

@property (nonatomic, strong) YTKKeyValueStore *store;

@end


@implementation DsDatabaseManger

+ (instancetype)shareManager {
    static DsDatabaseManger *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DsDatabaseManger alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.store = [[YTKKeyValueStore alloc] initDBWithName:DS_DATABASE_NAME];
        [self.store createTableWithName:DS_DATABASE_TABLE_CLOCKS];
        [self.store createTableWithName:DS_DATABASE_TABLE_NOTES];
    }
    return self;
}
- (void)saveClocksWithArray:(NSArray *)clocks{
    [self.store putObject:clocks withId:DS_DATABASE_KEY_CLOCKS intoTable:DS_DATABASE_TABLE_CLOCKS];
}
- (id)fetchClocks{
    return [self.store getObjectById:DS_DATABASE_KEY_CLOCKS fromTable:DS_DATABASE_TABLE_CLOCKS];
}

- (void)saveNotesWithArray:(NSArray *)clocks{
    [self.store putObject:clocks withId:DS_DATABASE_KEY_NOTES intoTable:DS_DATABASE_TABLE_NOTES];
}
- (id)fetchNotes{
    return [self.store getObjectById:DS_DATABASE_KEY_NOTES fromTable:DS_DATABASE_TABLE_NOTES];
}



@end
