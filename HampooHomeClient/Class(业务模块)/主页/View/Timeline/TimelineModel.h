//
//  TLModel.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 图片标记
typedef NS_ENUM(NSUInteger, TLPictureBadgeType) {
    TLPictureBadgeTypeNone = 0, ///< 正常图片
    TLPictureBadgeTypeLong,     ///< 长图
    TLPictureBadgeTypeGIF,      ///< GIF
};

/**
 一个图片的元数据
 */
@interface TLPictureMetadata : NSObject
@property (nonatomic, strong) NSURL *url; ///< Full image url
@property (nonatomic, assign) int width; ///< pixel width
@property (nonatomic, assign) int height; ///< pixel height
@property (nonatomic, strong) NSString *type; ///< "WEBP" "JPEG" "GIF"
@property (nonatomic, assign) int cutType; ///< Default:1
@property (nonatomic, assign) TLPictureBadgeType badgeType;
@end

/**
 图片
 */
@interface TLPicture : NSObject
@property (nonatomic, strong) NSString *picID;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, assign) int photoTag;
@property (nonatomic, assign) BOOL keepSize; ///< YES:固定为方形 NO:原始宽高比
@property (nonatomic, strong) TLPictureMetadata *thumbnail;  ///< w:180
@property (nonatomic, strong) TLPictureMetadata *bmiddle;    ///< w:360 (列表中的缩略图)
@property (nonatomic, strong) TLPictureMetadata *middlePlus; ///< w:480
@property (nonatomic, strong) TLPictureMetadata *large;      ///< w:720 (放大查看)
@property (nonatomic, strong) TLPictureMetadata *largest;    ///<       (查看原图)
@property (nonatomic, strong) TLPictureMetadata *original;   ///<
@property (nonatomic, assign) TLPictureBadgeType badgeType;
@end

/**
 链接
 */
@interface TLURL : NSObject
@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSString *shortURL; ///< 短域名 (原文)
@property (nonatomic, strong) NSString *oriURL;   ///< 原始链接
@property (nonatomic, strong) NSString *urlTitle; ///< 显示文本，例如"网页链接"，可能需要裁剪(24)
@property (nonatomic, strong) NSString *urlTypePic; ///< 链接类型的图片URL
@property (nonatomic, assign) int32_t urlType; ///< 0:一般链接 36地点 39视频/图片
@property (nonatomic, strong) NSString *log;
@property (nonatomic, strong) NSDictionary *actionLog;
@property (nonatomic, strong) NSString *pageID; ///< 对应着 TLPageInfo
@property (nonatomic, strong) NSString *storageType;
//如果是图片，则会有下面这些，可以直接点开看
@property (nonatomic, strong) NSArray<NSString *> *picIds;
@property (nonatomic, strong) NSDictionary<NSString *, TLPicture *> *picInfos;
@property (nonatomic, strong) NSArray<TLPicture *> *pics;
@end

/**
 话题
 */
@interface TLTopic : NSObject
@property (nonatomic, strong) NSString *topicTitle; ///< 话题标题
@property (nonatomic, strong) NSString *topicURL; ///< 话题链接 sinaweibo://
@end


/**
 标签
 */
@interface TLTag : NSObject
@property (nonatomic, strong) NSString *tagName; ///< 标签名字，例如"上海·上海文庙"
@property (nonatomic, strong) NSString *tagScheme; ///< 链接 sinaweibo://...
@property (nonatomic, assign) int32_t tagType; ///< 1 地点 2其他
@property (nonatomic, assign) int32_t tagHidden;
@property (nonatomic, strong) NSURL *urlTypePic; ///< 需要加 _default
@end

/**
 微博标题
 */
@interface TLTitle : NSObject
@property (nonatomic, assign) int32_t baseColor;
@property (nonatomic, strong) NSString *text; ///< 文本，例如"仅自己可见"
@property (nonatomic, strong) NSString *iconURL; ///< 图标URL，需要加Default
@end

/**
 用户
 */
@interface TLUser : NSObject
@property (nonatomic, strong) NSString *userID; // 用户id
@property (nonatomic, strong) NSString *name; // 用户名称
@property (nonatomic, strong) NSString *screenName; ///< 友好昵称
@property (nonatomic, assign) int32_t gender; /// 0:none 1:男 2:女
@property (nonatomic, strong) NSString *genderString; /// "m":男 "f":女 "n"未知
@property (nonatomic, strong) NSURL *avatarLarge;     ///< 头像 180*180
@end

/**
 动态
 */
@interface TLModel : NSObject

@property (nonatomic, assign) uint64_t modelID; ///< id (number)
@property (nonatomic, strong) NSDate *createdAt; ///< 发布时间

@property (nonatomic, strong) TLUser *user;
@property (nonatomic, assign) int32_t userType;

@property (nonatomic, strong) TLTitle *title; ///< 标题栏 (通常为nil)
@property (nonatomic, strong) NSString *picBg; ///< 微博VIP背景图，需要替换 "os7"
@property (nonatomic, strong) NSString *text; ///< 正文
@property (nonatomic, strong) NSURL *thumbnailPic; ///< 缩略图
@property (nonatomic, strong) NSURL *bmiddlePic; ///< 中图
@property (nonatomic, strong) NSURL *originalPic; ///< 大图


@property (nonatomic, strong) NSArray<NSString *> *picIds;
@property (nonatomic, strong) NSDictionary<NSString *, TLPicture *> *picInfos;

@property (nonatomic, strong) NSArray<TLPicture *> *pics;
@property (nonatomic, strong) NSArray<TLURL *> *urlStruct;
@property (nonatomic, strong) NSArray<TLTopic *> *topicStruct;
@property (nonatomic, strong) NSArray<TLTag *> *tagStruct;

@end


/**
 一次API请求的数据
 */
@interface TLAPIModel : NSObject
@property (nonatomic, strong) NSArray<TLModel *> *statuses;
/*
 groupInfo
 trends
 */
@end

@class TLEmoticonGroup;

typedef NS_ENUM(NSUInteger, TLEmoticonType) {
    TLEmoticonTypeImage = 0, ///< 图片表情
    TLEmoticonTypeEmoji = 1, ///< Emoji表情
};

@interface TLEmoticon : NSObject
@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) TLEmoticonType type;
@property (nonatomic, weak) TLEmoticonGroup *group;
@end


@interface TLEmoticonGroup : NSObject
@property (nonatomic, strong) NSString *groupID; ///< 例如 com.sina.default
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSString *nameCN; ///< 例如 浪小花
@property (nonatomic, strong) NSString *nameEN;
@property (nonatomic, strong) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray<TLEmoticon *> *emoticons;
@end
