//
//  NSString+DDSC.h
//  DDSC
//
//  Created by dnnta on 14-11-14.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,DDErrorType) {
    DDShowErrorMessage,
    DDVerifyOverRun,
    DDClodePayAlert,
    DDUndefinedError
};

@interface NSString (DDSC)

- (float)dd_textWidthWithFont:(UIFont *)font;
- (float)dd_textWidthWithAttributes:(NSDictionary *)attr;
    
- (NSString *)dd_replace:(NSString *)source withStr:(NSString *)desc;
- (NSString *)dd_maskAtRange:(NSRange)range;                            //用“*”替换对应的字符串

- (NSString *)dd_formatWithCodeType:(NSUInteger)rule;                  //按照规则添加空格

+ (NSString *)calculateTimeAgoWithDays:(CGFloat )days WithFormat:(NSString *)format;
- (NSString *)adjustDateWithFormat:(NSString *)format;
- (NSString *)adjustDateFromFormat:(NSString *)originFormat toFormat:(NSString *)destFormat;
- (NSString *)dd_timeAgo;
- (double)dd_timeIntevel;

- (NSString *)dd_MD5String;

+ (NSString *)dd_toStringWithJson:(id)jsonData;



- (NSString *)dd_AES128Decrypt;
- (NSString *)dd_AES128Encrypt;

- (NSString *)dd_AES128EncryptWithKey:(NSString *)key;
- (NSString *)dd_AES128DecryptWithKey:(NSString *)key;

- (NSString *)dd_AESEncryptWithKey:(NSString *)key;
- (NSString *)dd_AESDecryptWithKey:(NSString *)key;

- (NSString *)dd_decodeBase64;


- (NSString *)dd_dynamicH5URLWithParamer:(id)paramer;



- (BOOL)dd_pwdJudgeWithOtherString:(NSString *)otherStr type:(NSInteger) type;

- (BOOL)dd_isPhone;                               //判断是否是电话号码
- (BOOL)dd_isIDCard;                              //判断身份证
- (BOOL)dd_isName;
- (BOOL)dd_isChars;                                //是否是合法字符
- (NSMutableString *)getSavePointUrl;             //打点行为截取的需要的url
- (BOOL)stringContainsEmoji;                      //字符当中是否包含emoji表情

- (DDErrorType)getErrorType;

@end
