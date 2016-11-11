//
//  XYDChatKit.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDChatServiceDefinition.h"

@interface XYDChatKit : NSObject<XYDChatSessionService, XYDChatUserSystemService, XYDChatSignatureService, XYDChatSettingService, XYDChatUIService, XYDChatConversationService, XYDChatConversationsListService>

/*!
 *  appId
 */
@property (nonatomic, copy, readonly) NSString *appId;

/*!
 *  appkey
 */
@property (nonatomic, copy, readonly) NSString *appKey;

/*!
 *
 * @brief Set up application id(appId) and client key(appKey) to start LeanCloud service.
 * @attention 请区别 `[AVOSCloud setApplicationId:appId clientKey:appKey];` 与 `[LCChatKit setAppId:appId appKey:appKey];`。
 两者功能并不相同，前者不能代替后者。即使你在 `-[AppDelegate application:didFinishLaunchingWithOptions:]` 方法里已经设置过前者，也不能因此不调用后者。
 前者为 LeanCloud-SDK 初始化，后者为 ChatKit 初始化。后者需要你在**每次**登录操作时调用一次，前者只需要你在程序启动时调用。
 如果你使用了 LeanCloud-SDK 的其他功能，你可能要根据需要，这两个方法都使用到。
 */
+ (void)setAppId:(NSString *)appId appKey:(NSString *)appKey;

/*!
 *  Returns the shared instance of LCChatKit, creating it if necessary.
 *
 *  @return Shared instance of LCChatKit.
 */
+ (instancetype)sharedInstance;

@end
