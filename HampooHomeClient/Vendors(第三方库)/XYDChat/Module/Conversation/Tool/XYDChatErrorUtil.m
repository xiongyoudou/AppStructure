//
//  XYDChatErrorUtil.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/17.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatErrorUtil.h"

NSString *XYDChatErrorDomain = @"XYDChatErrorDomain";

NSInteger const kXYDChatErrorInvalidCommand = 1;
NSInteger const kXYDChatErrorInvalidArguments = 2;
NSInteger const kXYDChatErrorConversationNotFound = 3;
NSInteger const kXYDChatErrorTimeout = 4;
NSInteger const kXYDChatErrorConnectionLost = 5;
NSInteger const kXYDChatErrorInvalidData = 6;
NSInteger const kXYDChatErrorMessageTooLong = 7;
NSInteger const kXYDChatErrorClientNotOpen = 8;

@implementation XYDChatErrorUtil

+ (NSError *)errorWithCode:(NSInteger)code reason:(NSString *)reason {
    NSMutableDictionary *dict = nil;
    if (reason) {
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:reason forKey:@"reason"];
        [dict setObject:NSLocalizedString(reason, nil) forKey:NSLocalizedFailureReasonErrorKey];
    }
    NSError *error = [NSError errorWithDomain:XYDChatErrorDomain
                                         code:code
                                     userInfo:dict];
    return error;
}

@end
