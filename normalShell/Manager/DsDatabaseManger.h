//
//  DsDatabaseManger.h
//  normalShell
//
//  Created by Seven on 2018/2/24.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DsDatabaseManger : NSObject

+ (instancetype)shareManager;

- (void)saveClocksWithArray:(NSArray *)clocks;
- (id)fetchClocks;

- (void)saveNotesWithArray:(NSArray *)clocks;
- (id)fetchNotes;


@end
