//
//  XYDChatHelper.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDChatConstant.h"
#import "XYDChatMessage.h"


@interface XYDChatHelper : NSObject

+ (NSBundle *)emotionBundle;
+ (NSBundle *)imageBundle;
+ (UIImage *)getEmotionWithImageName:(NSString *)imageName;
+ (UIImage *)getImageWithNamed:(NSString *)imageName bundleName:(NSString *)bundleName bundleForClass:(Class)aClass;
+ (NSString *)getCustomizedBundlePathForBundleName:(NSString *)bundleName;
+ (NSBundle *)getBundleForName:(NSString *)bundleName class:(Class)aClass;
+ (NSString *)getPathForConversationBackgroundImage;
+ (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(XYDChatMessageOwnerType)owner;
+ (UIImage *)bubbleImageViewForType:(XYDChatMessageOwnerType)owner
                        messageType:(XYDChatMessageMediaType)messageMediaType
                      isHighlighted:(BOOL)isHighlighted;
- (NSString *)pathForConversationBackgroundImageWithStr:(NSString *)str;
+ (void)registerChatMessageCellClassForTableView:(UITableView *)tableView;

@end
