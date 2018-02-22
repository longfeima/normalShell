//
//  NSString+DDSC.m
//  DDSC
//
//  Created by dnnta on 14-11-14.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#import "NSString+DDSC.h"
#import "NSData+DDSC.h"

#define kAESLocalKey        @"mamwhatisthefuck"

@implementation NSString (DDSC)

#pragma mark - Length
- (float)dd_textWidthWithFont:(UIFont *)font {
    NSDictionary *attributesDictionary = @{NSFontAttributeName: font };
    CGSize size = [self boundingRectWithSize:CGSizeMake(1000, 25)
                                        options:NSStringDrawingUsesFontLeading
                                     attributes:attributesDictionary
                                        context:nil].size;
    return ceilf(size.width);
}

- (float)dd_textWidthWithAttributes:(NSDictionary *)attr {
    CGSize size = [self boundingRectWithSize:CGSizeMake(1000, 25) options:NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
    return ceilf(size.width);
}

#pragma mark - Str Operation
- (NSString *)dd_maskAtRange:(NSRange)range {
    int length = (int)MIN(self.length, range.length);
    NSString *tempStr = [self substringWithRange:NSMakeRange(range.location, length)];
    return [self dd_replace:tempStr withStr:@"*"];
}

- (NSString *)dd_replace:(NSString *)source withStr:(NSString *)desc {
    return [self stringByReplacingOccurrencesOfString:source withString:desc];
}

#pragma mark - Format
- (NSString *)dd_formatWithCodeType:(NSUInteger)rule {
    NSString *formatRule = @[@"6-4-4-4", @"4-4-4-4-4", @"3-4-4"][rule];
    NSArray *rangeLengthArr = [formatRule componentsSeparatedByString:@"-"];
    int codeLength = (int)self.length;
    int splitLengthCount = 0;
    int splitCount = 0;
    NSMutableString *returnStr = [self mutableCopy];
    for (NSString *rangeLenthStr in rangeLengthArr) {
        int rangeIndex = (int)[rangeLenthStr integerValue];
        splitLengthCount += rangeIndex;
        if (splitLengthCount < codeLength) {
            [returnStr insertString:@" " atIndex:splitLengthCount + splitCount];
            splitCount++;
        }
    }
    return returnStr;
}

#pragma mark - TimeAgo
- (NSString *)dd_timeAgo {
    NSDate *date = [self dd_dateFromString];
    NSDate *now = [NSDate date];
    
    double deltaSeconds = fabs([date timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    if (deltaMinutes < 24 * 60.0) {
        return @"今天";
    } else if (deltaMinutes < 24 * 60 * 2.0) {
        return @"昨天";
    } else if (deltaMinutes < 24 * 60 * 3.0) {
        return @"前天";
    } else {
        return self;
    }
}

- (NSDate*)dd_dateFromString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:self];
    return date;
}

+ (NSString *)calculateTimeAgoWithDays:(CGFloat )days WithFormat:(NSString *)format{
    NSDate *date = [NSDate date];
    NSTimeInterval agoTime = - days * 3600 * 24;
    NSDate *agoDate = [date dateByAddingTimeInterval:agoTime];
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:format];
    return [formate stringFromDate:agoDate];
}

- (NSString *)adjustDateWithFormat:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:self];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:format];
    return [formatter1 stringFromDate:date]?:@"";
}


- (NSString *)adjustDateFromFormat:(NSString *)originFormat toFormat:(NSString *)destFormat{
    NSDateFormatter *originF = [[NSDateFormatter alloc] init] ;
    [originF setDateFormat:originFormat];
    NSDate *date=[originF dateFromString:self];
    NSDateFormatter *destF = [[NSDateFormatter alloc] init] ;
    [destF setDateFormat:destFormat];
    return [destF stringFromDate:date]?:@"";
}


- (double)dd_timeIntevel{
    if (self.length <= 0) {
        return -1;
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"]];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:self];
    return ([inputDate timeIntervalSinceReferenceDate] - [date timeIntervalSinceReferenceDate] + 8 * 3600)/60.0/60/24;
}

//  优先判断是否是纯数字密码
- (BOOL)dd_pwdJudgeWithOtherString:(NSString *)otherStr type:(NSInteger) type{
        if (self.length != 6) {
            return NO;
        }
        else{
            NSString *temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
            if(temp.length > 0)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
    return NO;
}


/**
 转
 */
+ (NSString *)dd_toStringWithJson:(id)jsonData{
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


#pragma mark - Valid
- (BOOL)dd_isPhone {
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)dd_isIDCard {
    if (self.length != 18) {
        return NO;
    }
    NSString *subString = [self substringToIndex:17];
    
    NSArray *weight = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @2];
    NSArray *validate = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    int sum = 0;
    int mode = 0;
    for (int index = 0; index < subString.length; index++) {
        NSString *charStr = [subString substringWithRange:NSMakeRange(index, 1)];
        sum = sum + [charStr intValue] * [weight[index] intValue];
    }
    mode = sum % 11;

    NSString *lastCode = [[self substringWithRange:NSMakeRange(17, 1)] uppercaseString];
    
    return [validate[mode] isEqualToString:lastCode];
}

- (BOOL)dd_isName{

    NSString *pattern = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    //       return isMatch;
    if (self.length == 0) {
        return NO;
    }
    NSInteger count = 0;
    for (NSInteger i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            count += 1;
        }
    }
    return count == self.length;
}

- (BOOL)dd_isChars{
    NSInteger count = 0;
    NSString *pattern = @"([\u3000-\u301e\u4e00-\u9fa5\ufe10-\ufe19\ufe30-\ufe44\ufe50-\ufe6b\uff01-\uffee]*)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
//    for (NSInteger i = 0; i < [self length]; i++) {
//        int a = [self characterAtIndex:i];
//        UniChar charac = [self characterAtIndex:i];
//        BOOL isMatch = [pred evaluateWithObject:@(charac)];
//        if ((a > 0x4e00 && a < 0x9fff) || (isMatch && (a > 31 && a < 127) && ![@[@(60),@(62),@(47),@(123),@(125)] containsObject:@(a)])) {
//            count += 1;
//        }
//    }
//    return count == self.length;
}

- (NSString *)dd_decodeBase64 {
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:self options:0];
    
   return [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
}

#pragma mark - Encry
- (NSString *)dd_MD5String {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data dd_MD5String];
}

- (NSString *)dd_AES128Encrypt {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryData = [data dd_AES128EncryptWithKey:kAESLocalKey];
    return [[NSString alloc] initWithData:encryData encoding:NSUTF8StringEncoding];
}

- (NSString *)dd_AES128Decrypt {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryData = [data dd_AES128DecryptWithKey:kAESLocalKey];
    return [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
}


- (NSString *)dd_AES128EncryptWithKey:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryData = [data dd_AES128EncryptWithKey:key];
    return [[NSString alloc] initWithData:encryData encoding:NSUTF8StringEncoding];
}

- (NSString *)dd_AES128DecryptWithKey:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryData = [data dd_AES128DecryptWithKey:key];
    return [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
}


- (NSString *)dd_AESEncryptWithKey:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryData = [data dd_AES128EncryptWithKey:key];
    return [[NSString alloc] initWithData:encryData encoding:NSUTF8StringEncoding];
}

- (NSString *)dd_AESDecryptWithKey:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryData = [data dd_AES128DecryptWithKey:key];
    return [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
}

// h5动态拼接阐述
- (NSString *)dd_dynamicH5URLWithParamer:(id)paramer{

    if ([paramer isKindOfClass:[NSNull class]]) {
        return self;
    }else if ([paramer isKindOfClass:[NSString class]]){
        NSString *temp = (NSString *)paramer;
        if ([temp hasPrefix:@"/"]) {
            return [NSString stringWithFormat:@"%@%@",self,temp];
        }else{
            return [NSString stringWithFormat:@"%@/%@",self,temp];
        }
    }else if ([paramer isKindOfClass:[NSDictionary class]]){
    
        NSDictionary *tempDict = (NSDictionary *)paramer;
        NSArray *keysArr = [tempDict allKeys];
        if (keysArr.count <= 0) {
            return self;
        }
        NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%@?",[self mutableCopy]];
        for (NSString *key in keysArr) {
            tempStr = [NSMutableString stringWithFormat:@"%@%@=%@",tempStr,key, tempDict[key]];
        }
        return tempStr;
    }
    return self;
}


#pragma mark - savePoint
- (NSMutableString *)getSavePointUrl {
    NSMutableArray *webUrlCharacter = [[self componentsSeparatedByString:@"/"] mutableCopy];
    NSIndexSet *indexs = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 3)];
    [webUrlCharacter removeObjectsAtIndexes:indexs];
    NSMutableString *eventid = [@"" mutableCopy];
    for (NSString *character in webUrlCharacter) {
        [eventid appendFormat:@"%@/",character];
    }
    return eventid;
}

- (BOOL)stringContainsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}


- (DDErrorType)getErrorType {
    NSString *errorLevelString = [self componentsSeparatedByString:@"-"][3];
    if ([errorLevelString isEqualToString:@"01"]) {
        return DDShowErrorMessage;
    } else if ([errorLevelString isEqualToString:@"02"]){
        return  DDVerifyOverRun;
    } else if ([errorLevelString isEqualToString:@"03"]) {
        return DDClodePayAlert;
    } else {
        return  DDUndefinedError;
    }
}
@end
