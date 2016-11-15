//
//  XYDDynamicObject.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYDDynamicObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary;
- (instancetype)initWithJSON:(NSString *)json;
- (instancetype)initWithMessagePack:(NSData *)data;
- (NSString *)JSONString;
- (NSDictionary *)dictionary;
- (NSData *)messagePack;

- (BOOL)hasKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end
