//
//  NSString+XYDHash.m

//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSString+XYDHash.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+XYDHash.h"

@implementation NSString (XYDHash)
- (NSString *)xyd_md2String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_md2String];
}

- (NSString *)xyd_md4String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_md4String];
}

- (NSString *)xyd_md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_md5String];
}

- (NSString *)xyd_sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_sha1String];
}

- (NSString *)xyd_sha224String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_sha224String];
}

- (NSString *)xyd_sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_sha256String];
}

- (NSString *)xyd_sha384String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_sha384String];
}

- (NSString *)xyd_sha512String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_sha512String];
}

- (NSString *)xyd_crc32String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xyd_crc32String];
}

- (NSString *)xyd_hmacMD5StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            xyd_hmacMD5StringWithKey:key];
}

- (NSString *)xyd_hmacSHA1StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            xyd_hmacSHA1StringWithKey:key];
}

- (NSString *)xyd_hmacSHA224StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            xyd_hmacSHA224StringWithKey:key];
}

- (NSString *)xyd_hmacSHA256StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            xyd_hmacSHA256StringWithKey:key];
}

- (NSString *)xyd_hmacSHA384StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            xyd_hmacSHA384StringWithKey:key];
}

- (NSString *)xyd_hmacSHA512StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            xyd_hmacSHA512StringWithKey:key];
}
@end
