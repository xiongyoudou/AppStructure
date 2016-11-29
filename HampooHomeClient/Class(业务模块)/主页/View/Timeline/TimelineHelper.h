//
//  TimelineHelper.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"
#import "YYWebImageManager.h"
#import "TimelineModel.h"

/**
 很多都写死单例了，毕竟只是 Demo。。
 */
@interface TLHelper : NSObject

/// 微博图片资源 bundle
+ (NSBundle *)bundle;

/// 微博表情资源 bundle
+ (NSBundle *)emoticonBundle;

/// 微博表情 Array<TLEmotionGroup> (实际应该做成动态更新的)
+ (NSArray<TLEmoticonGroup *> *)emoticonGroups;

/// 微博图片 cache
+ (YYMemoryCache *)imageCache;

/// 从微博 bundle 里获取图片 (有缓存)
+ (UIImage *)imageNamed:(NSString *)name;

/// 从path创建图片 (有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

/// 圆角头像的 manager
+ (YYWebImageManager *)avatarImageManager;

/// 将微博API提供的图片URL转换成可用的实际URL
+ (NSURL *)defaultURLForImageURL:(id)imageURL;

/// 缩短数量描述，例如 51234 -> 5万
+ (NSString *)shortedNumberDesc:(NSUInteger)number;

/// At正则 例如 @王思聪
+ (NSRegularExpression *)regexAt;

/// 话题正则 例如 #暖暖环游世界#
+ (NSRegularExpression *)regexTopic;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 表情字典 key:[偷笑] value:ImagePath
+ (NSDictionary *)emoticonDic;

@end
