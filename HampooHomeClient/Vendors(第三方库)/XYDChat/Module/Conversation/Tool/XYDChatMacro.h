//
//  XYDChatMacro.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 基本宏
#define WAIT_TIL_TRUE(signal, interval) \
do {                                       \
while(!(signal)) {                     \
@autoreleasepool {                 \
if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:(interval)]]) { \
[NSThread sleepForTimeInterval:(interval)]; \
}                              \
}                                  \
}                                      \
} while (0)

#define WAIT_WITH_ROUTINE_TIL_TRUE(signal, interval, routine) \
do {                                       \
while(!(signal)) {                     \
@autoreleasepool {                 \
routine;                       \
if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:(interval)]]) { \
[NSThread sleepForTimeInterval:(interval)]; \
}                              \
}                                  \
}                                      \
} while (0)

#pragma mark - 通知宏

