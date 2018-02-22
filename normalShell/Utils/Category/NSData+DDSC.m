//
//  NSData+DDSC.m
//  DDSC
//
//  Created by dxw on 14/11/18.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#import "NSData+DDSC.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (DDSC)

- (NSData *)dd_MD5
{
    unsigned char md5Result[CC_MD5_DIGEST_LENGTH + 1];
    CC_MD5([self bytes], (int)[self length], md5Result);
    
    NSMutableData * retData = [[NSMutableData alloc] init];
    if ( nil == retData )
        return nil;
    
    [retData appendBytes:md5Result length:CC_MD5_DIGEST_LENGTH];
    return retData;
}

- (NSString *)dd_MD5String
{
    NSData * value = [self dd_MD5];
    if (value)
    {
        char			tmp[16];
        unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
        unsigned char *	bytes = (unsigned char *)[value bytes];
        unsigned long	length = [value length];
        
        hex[0] = '\0';
        
        for (unsigned long i = 0; i < length; ++i)
        {
            sprintf(tmp, "%02x", bytes[i]);
            strcat((char *)hex, tmp);
        }
        
        NSString * result = [NSString stringWithUTF8String:(const char *)hex];
        free(hex);
        return result;
    }
    else
    {
        return nil;
    }
}

- (NSDictionary *)dd_jsonObject
{
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    return result;    
}

- (NSData *)dd_AES128EncryptWithKey:(NSString *)key {
    NSData *data = [self dd_AES128Operation:kCCEncrypt key:key];
    return [[data base64EncodedStringWithOptions:0] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)dd_AES128DecryptWithKey:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [data dd_AES128Operation:kCCDecrypt key:key];
}


- (NSData *)dd_AES128EncryptWithout64WithKey:(NSString *)key {
     return [self dd_AES128Operation:kCCEncrypt key:key];
}


- (NSData *)dd_AES128Operation:(CCOperation)operation key:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return data;
    }
    free(buffer);
    return nil;
}

@end
