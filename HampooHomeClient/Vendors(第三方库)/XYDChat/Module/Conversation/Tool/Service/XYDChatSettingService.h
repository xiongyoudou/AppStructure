//
//  XYDChatSettingManager.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatConstant.h"
#import "XYDSingleton.h"
#import "XYDChatSettingProtocol.h"

#define XYDCHAT_STRING_BY_SEL(sel) NSStringFromSelector(@selector(sel))

@interface XYDChatSettingService : XYDSingleton<XYDChatSettingProtocol>

@property (nonatomic, strong, readonly) NSDictionary *defaultSettings;
@property (nonatomic, strong, readonly) NSDictionary *defaultTheme;
@property (nonatomic, strong, readonly) NSDictionary *messageBubbleCustomizeSettings;

//TODO:
/*!
 * 1. 设置离线推送
 * 2. 设置未读消息
 * 3. 推送相关设置
 * 4. Others
 */

/**
 *  图片消息，临时的压缩图片路径
 */
- (NSString *)tmpPath;

/**
 *  根据消息的 id 获取声音文件的路径
 *  @param objectId 消息的 id
 *  @return 文件路径
 */
- (NSString *)getPathByObjectId:(NSString *)objectId;

// please call in application:didFinishLaunchingWithOptions:launchOptions
- (void)registerForRemoteNotification;

// please call in applicationDidBecomeActive:application
- (void)cleanBadge;

//save the local applicationIconBadgeNumber to the server
- (void)syncBadge;

- (UIColor *)defaultThemeColorForKey:(NSString *)key;
- (UIFont *)defaultThemeTextMessageFont;

/**
 * @param capOrEdge 分为：cap_insets和edge_insets
 * @param position 主要分为：CommonLeft、CommonRight等
 */
- (UIEdgeInsets)messageBubbleCustomizeSettingsForPosition:(NSString *)position capOrEdge:(NSString *)capOrEdge;
- (UIEdgeInsets)rightCapMessageBubbleCustomize;
- (UIEdgeInsets)rightEdgeMessageBubbleCustomize;
- (UIEdgeInsets)leftCapMessageBubbleCustomize;
- (UIEdgeInsets)leftEdgeMessageBubbleCustomize;
- (UIEdgeInsets)rightHollowCapMessageBubbleCustomize;
- (UIEdgeInsets)rightHollowEdgeMessageBubbleCustomize;
- (UIEdgeInsets)leftHollowCapMessageBubbleCustomize;
- (UIEdgeInsets)leftHollowEdgeMessageBubbleCustomize;

- (NSString *)imageNameForMessageBubbleCustomizeForPosition:(NSString *)position normalOrHighlight:(NSString *)normalOrHighlight;
- (NSString *)leftNormalImageNameMessageBubbleCustomize;
- (NSString *)leftHighlightImageNameMessageBubbleCustomize;
- (NSString *)rightHighlightImageNameMessageBubbleCustomize;
- (NSString *)rightNormalImageNameMessageBubbleCustomize;
- (NSString *)hollowRightNormalImageNameMessageBubbleCustomize;
- (NSString *)hollowRightHighlightImageNameMessageBubbleCustomize;
- (NSString *)hollowLeftNormalImageNameMessageBubbleCustomize;
- (NSString *)hollowLeftHighlightImageNameMessageBubbleCustomize;

@end
