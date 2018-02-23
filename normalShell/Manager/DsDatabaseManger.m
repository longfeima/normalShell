//
//  DsDatabaseManger.m
//  normalShell
//
//  Created by Seven on 2018/2/24.
//  Copyright © 2018年 Seven. All rights reserved.
//

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
