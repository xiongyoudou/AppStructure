//
//  UIDevice+Hardware.h
//  TestTable
//
//  Created by Inder Kumar Rathore on 19/01/13.
//  Copyright (c) 2013 Rathore. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kSystemVersion
#define kSystemVersion [[UIDevice xyd_systemVersion]floatValue]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

@interface UIDevice (XYDHardware)
+ (NSString *)xyd_platform;
+ (NSString *)xyd_platformString;


+ (NSString *)xyd_macAddress;

//Return the current device CPU frequency
+ (NSUInteger)xyd_cpuFrequency;
// Return the current device BUS frequency
+ (NSUInteger)xyd_busFrequency;
//current device RAM size
+ (NSUInteger)xyd_ramSize;
//Return the current device CPU number
+ (NSUInteger)xyd_cpuNumber;
//Return the current device total memory

/// 获取iOS系统的版本号
+ (NSString *)xyd_systemVersion;
/// 判断当前系统是否有摄像头
+ (BOOL)xyd_hasCamera;
/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)xyd_totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)xyd_freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)xyd_freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)xyd_totalDiskSpaceBytes;
@end
