//
//  NSData+DDSC.h
//  DDSC
//
//  Created by dxw on 14/11/18.
//  Copyright (c) 2014年 ddsoucai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DDSC)

- (NSData *)dd_MD5;
- (NSString *)dd_MD5String;
- (NSDictionary *)dd_jsonObject;

- (NSData *)dd_AES128EncryptWithKey:(NSString *)key;
- (NSData *)dd_AES128DecryptWithKey:(NSString *)key;
- (NSData *)dd_AES128EncryptWithout64WithKey:(NSString *)key;
@end
