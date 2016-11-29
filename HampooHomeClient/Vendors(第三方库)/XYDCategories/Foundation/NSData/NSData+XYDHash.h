//
//  NSData+XYDHash.h

//
//  Created by Jakey on 15/6/1.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (XYDHash)
#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)xyd_md2String;

/**
 Returns an NSData for md2 hash.
 */
- (NSData *)xyd_md2Data;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)xyd_md4String;

/**
 Returns an NSData for md4 hash.
 */
- (NSData *)xyd_md4Data;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)xyd_md5String;

/**
 Returns an NSData for md5 hash.
 */
- (NSData *)xyd_md5Data;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)xyd_sha1String;

/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)xyd_sha1Data;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)xyd_sha224String;

/**
 Returns an NSData for sha224 hash.
 */
- (NSData *)xyd_sha224Data;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)xyd_sha256String;

/**
 Returns an NSData for sha256 hash.
 */
- (NSData *)xyd_sha256Data;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)xyd_sha384String;

/**
 Returns an NSData for sha384 hash.
 */
- (NSData *)xyd_sha384Data;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)xyd_sha512String;

/**
 Returns an NSData for sha512 hash.
 */
- (NSData *)xyd_sha512Data;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key  The hmac key.
 */
- (NSString *)xyd_hmacMD5StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm md5 with key.
 @param key  The hmac key.
 */
- (NSData *)xyd_hmacMD5DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSString *)xyd_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSData *)xyd_hmacSHA1DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSString *)xyd_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSData *)xyd_hmacSHA224DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSString *)xyd_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSData *)xyd_hmacSHA256DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSString *)xyd_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSData *)xyd_hmacSHA384DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSString *)xyd_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSData *)xyd_hmacSHA512DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (NSString *)xyd_crc32String;

/**
 Returns crc32 hash.
 */
- (uint32_t)crc32;

@end
NS_ASSUME_NONNULL_END
