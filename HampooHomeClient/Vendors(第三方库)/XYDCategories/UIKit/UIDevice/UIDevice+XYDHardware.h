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

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (XYDHardware)

#pragma mark - Device Information

/// 获取iOS系统的版本号
+ (NSString *)xyd_systemVersion;

// e.g. "iPhone6,1" "iPad4,6"
+ (NSString *)xyd_platform;
// e.g. "iPhone 5s" "iPad mini 2"
+ (NSString *)xyd_platformString;

/// Whether the device is iPad/iPad mini.
@property (nonatomic, readonly) BOOL xyd_isPad;
/// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL xyd_isSimulator;
/// Whether the device is jailbroken.
@property (nonatomic, readonly) BOOL xyd_isJailbroken;
/// Wherher the device can make phone calls.
@property (nonatomic, readonly) BOOL xyd_canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");
/// The System's startup time.
@property (nonatomic, readonly) NSDate *xyd_systemUptime;
/// 判断当前系统是否有摄像头
+ (BOOL)xyd_hasCamera;

#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================

/// WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"
@property (nullable, nonatomic, readonly) NSString *xyd_ipAddressWIFI;

/// Cell IP address of this device (can be nil). e.g. @"10.2.2.222"
@property (nullable, nonatomic, readonly) NSString *xyd_ipAddressCell;

/// e.g. @"hampoo_text"
@property (nullable, nonatomic, readonly) NSString *xyd_SSID;
/// e.g. @"d4:68:ba:89:dc:5d"
@property (nullable, nonatomic, readonly) NSString *xyd_BSSID;


/**
 Network traffic type:
 
 WWAN: Wireless Wide Area Network.
 For example: 3G/4G.
 
 WIFI: Wi-Fi.
 
 AWDL: Apple Wireless Direct Link (peer-to-peer connection).
 For exmaple: AirDrop, AirPlay, GameKit.
 */
typedef NS_OPTIONS(NSUInteger, XYDNetworkTrafficType) {
    XYDNetworkTrafficTypeWWANSent     = 1 << 0,
    XYDNetworkTrafficTypeWWANReceived = 1 << 1,
    XYDNetworkTrafficTypeWIFISent     = 1 << 2,
    XYDNetworkTrafficTypeWIFIReceived = 1 << 3,
    XYDNetworkTrafficTypeAWDLSent     = 1 << 4,
    XYDNetworkTrafficTypeAWDLReceived = 1 << 5,
    
    XYDNetworkTrafficTypeWWAN = XYDNetworkTrafficTypeWWANSent | XYDNetworkTrafficTypeWWANReceived,
    XYDNetworkTrafficTypeWIFI = XYDNetworkTrafficTypeWIFISent | XYDNetworkTrafficTypeWIFIReceived,
    XYDNetworkTrafficTypeAWDL = XYDNetworkTrafficTypeAWDLSent | XYDNetworkTrafficTypeAWDLReceived,
    
    XYDNetworkTrafficTypeALL = XYDNetworkTrafficTypeWWAN |
    XYDNetworkTrafficTypeWIFI |
    XYDNetworkTrafficTypeAWDL,
};

/**
 Get device network traffic bytes.
 
 @discussion This is a counter since the device's last boot time.
 Usage:
 
 uint64_t bytes = [[UIDevice currentDevice] getNetworkTrafficBytes:XYDNetworkTrafficTypeALL];
 NSTimeInterval time = CACurrentMediaTime();
 
 uint64_t bytesPerSecond = (bytes - _lastBytes) / (time - _lastTime);
 
 _lastBytes = bytes;
 _lastTime = time;
 
 
 @param types traffic types
 @return bytes counter.
 */
- (uint64_t)xyd_getNetworkTrafficBytes:(XYDNetworkTrafficType)types;


#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================

/// Total disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_diskSpace;

/// Free disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_diskSpaceFree;

/// Used disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_diskSpaceUsed;


#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// Total physical memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_memoryTotal;

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_memoryUsed;

/// Free memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_memoryFree;

/// Acvite memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_memoryActive;

/// Inactive memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_memoryInactive;

/// Wired memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_memoryWired;

/// Purgable memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xyd_memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// Avaliable CPU processor count.
@property (nonatomic, readonly) NSUInteger xyd_cpuCount;

/// Current CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float xyd_cpuUsage;

/// Current CPU usage per processor (array of NSNumber), 1.0 means 100%. (nil when error occurs)
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *xyd_cpuUsagePerProcessor;

@end

NS_ASSUME_NONNULL_END
