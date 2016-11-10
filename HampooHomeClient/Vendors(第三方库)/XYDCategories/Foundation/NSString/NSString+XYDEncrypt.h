//
//  NSString+XYDEncrypt.h
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 15/1/26.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JKEncrypt)
- (NSString*)xyd_encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)xyd_decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

- (NSString*)xyd_encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)xyd_decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

@end
