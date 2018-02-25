//
//  DsUtils.h
//  WBuild
//
//  Created by Seven on 2017/7/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DsUtils : NSObject

+ (void)saveFirstInstallTime;
//+ (NSString *)fetchFirstInstallTime;
+ (BOOL) isHaveEnoughTimeToJump;

+ (void)write2UserDefaults:(id)value forKey:(NSString *)key;
+ (id)fetchFromUserDefaultsWithKey:(NSString *)key;
+ (void)removeUserDefaultsWithKey:(NSString *)key;
+ (id)getDataFromDocumentWithFileName:(NSString *)fileName key:(NSString *)key;
+ (void)saveToDocumentWithObject:(id)object fileName:(NSString *)name key:(NSString *)key;
+ (void)clearUserInfo;


+ (NSString *)macString;
+ (NSString *)idfvString;
+ (NSString *)idfaString;


+ (NSString *)getUUID;
@end
