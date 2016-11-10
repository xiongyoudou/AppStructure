//
//  XYDEmotionManager.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kEmotionIDKey          @"emotion_id"
#define kEmotionNameKey        @"emotion_name"
#define kEmotionImageNameKey   @"emotion_image_name"

#define kEmotionRankKey        @"emotion_rank"
#define kEmotionClickKey       @"emotion_click"

/**
 *  表情管理类,可以获取所有的表情名称
 *  TODO 直接获取所有的表情Dict,添加排序功能,对表情进行排序,常用表情排在前面
 */
@interface XYDEmotionManager : NSObject

+ (instancetype)shareInstance;

#pragma mark - 静态表情相关

/**
 *  获取所有的表情图片名称
 *
 *  @return 所有的表情图片名称
 */
+ (NSArray *)commonEmotions;
@property (strong, nonatomic, readonly) NSMutableArray *commonemotionArrays;

+ (UIImage *)emotionImageWithEmotionID:(NSUInteger)emotionID;
+ (NSString *)emotionNameWithEmotionID:(NSUInteger)emotionID;
/**
 *  将文字中带表情的字符处理换成图片显示
 *
 *  @param text 未处理的文字
 *
 *  @return 处理后的文字
 */
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text;
+ (void)configEmotionWithMutableAttributedString:(NSMutableAttributedString *)attributeString;

#pragma mark - 动态gif表情相关处理


#pragma mark - 最近表情相关处理

/**
 *  获取最近使用的表情图片
 *
 */
+ (NSArray *)recentEmotions;

/**
 *  存储一个最近使用的face
 *
 *  @param dict 包含以下key-value键值对
 *  face_id     表情id
 *  face_name   表情名称
 *  @return 是否存储成功
 */
+ (BOOL)saveRecentEmotion:(NSDictionary *)dict;


@end
