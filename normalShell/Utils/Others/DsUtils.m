//
//  DsUtils.m
//  WBuild
//
//  Created by Seven on 2017/7/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "DsUtils.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/AdSupport.h>
#import "NSData+DDSC.h"

@implementation DsUtils

+ (void)clearUserInfo{

    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    } seq:1];
}

//MARK: 数据持久化
//用户第一次安装时间
+ (void)saveFirstInstallTime{
    NSString *dateStr = DS_JUMP_DATE_STRING;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:DS_JUMP_DATE_FORMATE];
    
    NSDate *date = [format dateFromString:dateStr];
    NSTimeInterval time = [date timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.lf", time] forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)fetchFirstInstallTime{
   id temp = [[NSUserDefaults standardUserDefaults] valueForKey:@"time"];
    if (temp == nil) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"time"];
}
+ (BOOL) isHaveEnoughTimeToJump{
    NSString *time = [self fetchFirstInstallTime];
    if (time.length) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        double timeDoubleV = [time doubleValue];
        NSDate *nowDate = [NSDate date];
        NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
        return [language hasPrefix:@"zh"] && (nowTime - timeDoubleV)/24/60/60 >= DS_JUMPTIMELIMITDAY;
    }
    return NO;
}




+ (void)write2UserDefaults:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)fetchFromUserDefaultsWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)removeUserDefaultsWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getDataFromDocumentWithFileName:(NSString *)fileName key:(NSString *)key {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
       NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
       NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
       NSDictionary *dataSuorce = [unarchiver decodeObjectForKey:key];
       return dataSuorce;
    } else {
       return nil;
    }
}

+ (void)saveToDocumentWithObject:(id)object fileName:(NSString *)name key:(NSString *)key {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent:name];
    
    [NSKeyedArchiver archiveRootObject:data toFile:path];
}


#pragma mark - IDFV MAC
+ (NSString * )macString {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

+ (NSString *)idfaString {
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

+ (NSString *)idfvString {
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}


//MARK: 唯一标识符
+ (NSString *)getUUID {
    CFUUIDRef UUIDRef = CFUUIDCreate(NULL);
    CFStringRef UUIDStringRef= CFUUIDCreateString(NULL, UUIDRef);
    
    NSString *UUIDString = [NSString stringWithString:(__bridge NSString *)UUIDStringRef];
    
    CFRelease(UUIDRef);
    CFRelease(UUIDStringRef);
    
    NSString *lowercaseUUIDString = [[UUIDString lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [lowercaseUUIDString substringToIndex:16];
}
@end
