//
//  XYDChatMessageOption.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XYDChatessagePriority) {
    XYDChatessagePriorityDefault = 0,
    XYDChatessagePriorityHigh    = 1,
    XYDChatessagePriorityNormal  = 2,
    XYDChatessagePriorityLow     = 3,
};

NS_ASSUME_NONNULL_BEGIN

// 消息的一些选项
@interface XYDChatMessageOption : NSObject

@property (nonatomic, assign)           BOOL                 receipt;
@property (nonatomic, assign)           BOOL                 transient;     //消息是否短暂显示
@property (nonatomic, assign)           XYDChatessagePriority  priority;    // 消息的优先级
@property (nonatomic, strong, nullable) NSDictionary            *pushData;

@end


NS_ASSUME_NONNULL_END
