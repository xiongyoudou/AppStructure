//
//  XYDChatSettingProtocol.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYDChatSettingProtocol <NSObject>

/*!
 * You should always use like this, never forgive to cancel log before publishing.
 
 ```
 #ifndef __OPTIMIZE__
 [[LCChatKit sharedInstance] setAllLogsEnabled:YES];
 #endif
 ```
 
 */
//+ (void)setAllLogsEnabled:(BOOL)enabled;
//+ (BOOL)allLogsEnabled;
+ (NSString *)ChatKitVersion;
- (void)syncBadge;

/*!
 * 禁止预览id
 * 如果不设置，或者设置为NO，在群聊需要显示最后一条消息的发送者时，会在网络请求用户昵称成功前，先显示id，然后，成功后再显示昵称。
 */
@property (nonatomic, assign, getter=isDisablePreviewUserId) BOOL disablePreviewUserId;

/*!
 *  是否使用开发证书去推送，默认为 NO。如果设为 YES 的话每条消息会带上这个参数，云代码利用 Hook 设置证书
 *  参考 https://github.com/leancloud/leanchat-cloudcode/blob/master/cloud/mchat.js
 */
@property (nonatomic, assign) BOOL useDevPushCerticate;
- (void)setBackgroundImage:(UIImage *)image forConversationId:(NSString *)conversationId scaledToSize:(CGSize)scaledToSize;

@end
