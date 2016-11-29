//
//  NSString+XYDHash.h

//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XYDHash)
#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 Returns a lowercase NSString for md2 hash.
 */
- (nullable NSString *)xyd_md2String;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (nullable NSString *)xyd_md4String;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (nullable NSString *)xyd_md5String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (nullable NSString *)xyd_sha1String;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (nullable NSString *)xyd_sha224String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (nullable NSString *)xyd_sha256String;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (nullable NSString *)xyd_sha384String;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (nullable NSString *)xyd_sha512String;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key The hmac key.
 */
- (nullable NSString *)xyd_hmacMD5StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key The hmac key.
 */
- (nullable NSString *)xyd_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key The hmac key.
 */
- (nullable NSString *)xyd_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key The hmac key.
 */
- (nullable NSString *)xyd_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key The hmac key.
 */
- (nullable NSString *)xyd_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key The hmac key.
 */
- (nullable NSString *)xyd_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (nullable NSString *)xyd_crc32String;

@end

NS_ASSUME_NONNULL_END
