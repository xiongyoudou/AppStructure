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

@interface XYDChatMessageOption : NSObject

@property (nonatomic, assign)           BOOL                 receipt;
@property (nonatomic, assign)           BOOL                 transient;
@property (nonatomic, assign)           XYDChatessagePriority  priority;
@property (nonatomic, strong, nullable) NSDictionary        *pushData;

@end


NS_ASSUME_NONNULL_END
