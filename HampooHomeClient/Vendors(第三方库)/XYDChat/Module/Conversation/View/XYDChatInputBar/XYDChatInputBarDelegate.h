//
//  XYDChatInputBarProtocol.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class XYDChatInputBar;

// 遵守该协议的对象可以代理InputBar做一些事，比如：发送图片,地理位置,文字,语音信息等
@protocol XYDChatInputBarDelegate <NSObject>


@optional

/*!
 *  chatBarFrame改变回调
 *
 */
- (void)chatBarFrameDidChange:(XYDChatInputBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom;

/*!
 *  发送图片信息,支持多张图片
 *
 *  @param pictures 需要发送的图片信息
 */
- (void)chatBar:(XYDChatInputBar *)chatBar sendPictures:(NSArray *)pictures;

/*!
 *  发送地理位置信息
 *
 *  @param locationCoordinate 需要发送的地址位置经纬度
 *  @param locationText       需要发送的地址位置对应信息
 */
- (void)chatBar:(XYDChatInputBar *)chatBar sendLocation:(CLLocationCoordinate2D)locationCoordinate locationText:(NSString *)locationText;

/*!
 *  发送普通的文字信息,可能带有表情
 *
 *  @param message 需要发送的文字信息
 */
- (void)chatBar:(XYDChatInputBar *)chatBar sendMessage:(NSString *)message;

/*!
 *  发送语音信息
 *
 *  @param voiceFileName 语音名称
 *  @param seconds   语音时长
 */
- (void)chatBar:(XYDChatInputBar *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds;

/*!
 *  输入了 @ 的时候
 *
 */
- (void)didInputAtSign:(XYDChatInputBar *)chatBar;

- (NSArray *)regulationForBatchDeleteText;

@end
