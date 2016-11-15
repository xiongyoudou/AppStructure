//
//  XYDConversationViewModel.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDChatConstant.h"

@class XYDConversationVCtrl;
@class XYDChatMessageCell;
@class XYDChatMessage;

@protocol XYDChatConversationViewModelDelegate <NSObject>

@optional
- (void)reloadAfterReceiveMessage;
- (void)messageSendStateChanged:(XYDChatMessageSendState)sendState  withProgress:(CGFloat)progress forIndex:(NSUInteger)index;
- (void)messageReadStateChanged:(XYDChatMessageReadState)readState withProgress:(CGFloat)progress forIndex:(NSUInteger)index;
@end

typedef void (^XYDChatSendMessageSuccessBlock)(NSString *messageUUID);
typedef void (^XYDChatSendMessageSuccessFailedBlock)(NSString *messageUUID, NSError *error);

// 实现tableView的代理和协议
@interface XYDConversationViewModel : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign, readonly) NSUInteger messageCount;

@property (nonatomic, weak) id<XYDChatConversationViewModelDelegate> delegate;

- (instancetype)initWithParentViewController:(XYDConversationVCtrl *)parentViewController;

@property (nonatomic, strong, readonly) NSMutableArray<XYDChatMessage *> *dataArray;

/**
 *  发送一条消息,消息已经通过addMessage添加到XYDChatConversationViewModel数组中了,此方法主要为了XYDChatChatServer发送消息过程
 */
- (void)sendMessage:(id)message;
- (void)sendCustomMessage:(XYDChatMessage *)customMessage;
- (void)sendCustomMessage:(XYDChatMessage *)aMessage
            progressBlock:(XYDChatProgressBlock)progressBlock
                  success:(XYDChatBooleanResultBlock)success
                   failed:(XYDChatBooleanResultBlock)failed;
- (void)sendLocalFeedbackTextMessge:(NSString *)localFeedbackTextMessge;
- (void)loadMessagesFirstTimeWithCallback:(XYDChatBoolResultBlock)callback;
- (void)loadOldMessages;
- (void)getAllVisibleImagesForSelectedMessage:(XYDChatMessage *)message
                             allVisibleImages:(NSArray **)allVisibleImages
                             allVisibleThumbs:(NSArray **)allVisibleThumbs
                         selectedMessageIndex:(NSNumber **)selectedMessageIndex;
- (void)resendMessageForMessageCell:(XYDChatMessageCell *)messageCell;
- (void)resetBackgroundImage;
- (void)setDefaultBackgroundImage;


@end
