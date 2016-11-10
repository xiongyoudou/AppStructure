//
//  XYDChatKit.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatKit.h"

@interface XYDChatKit ()
/*!
 *  appId
 */
@property (nonatomic, copy, readwrite) NSString *appId;

/*!
 *  appkey
 */
@property (nonatomic, copy, readwrite) NSString *appKey;
@end

@implementation XYDChatKit

#pragma mark -

+ (id)copyWithZone:(NSZone *)zone {
    // Not allow copying to a different zone
    return [self sharedInstance];
}

/**
 * create a singleton instance of LCChatKit
 */
+ (instancetype)sharedInstance {
    static XYDChatKit *_sharedLCChatKit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLCChatKit = [[self alloc] init];
    });
    return _sharedLCChatKit;
}

#pragma mark -
#pragma mark - LCChatKit Method

+ (void)setAppId:(NSString *)appId appKey:(NSString *)appKey {
    [XYDChatKit sharedInstance].appId = appId;
    [XYDChatKit sharedInstance].appKey = appKey;

}

#pragma mark -
#pragma mark - Service Delegate Method

@end
