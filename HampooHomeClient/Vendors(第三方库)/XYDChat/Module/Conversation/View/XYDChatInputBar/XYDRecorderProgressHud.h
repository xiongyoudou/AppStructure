//
//  XYDRecorderProgressHud.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  状态指示器对应状态
 */
typedef NS_ENUM(NSUInteger, LCCKProgressState){
    LCCKProgressSuccess /**< 成功 */,
    LCCKProgressError /**< 出错,失败 */,
    LCCKProgressShort /**< 时间太短失败 */,
    LCCKProgressMessage /**< 自定义失败提示 */,
};

/**
 *  录音加载的指示器
 */
@interface XYDRecorderProgressHud : UIView

#pragma mark - Class Methods

/**
 *  上次成功录音时长
 *
 */
+ (NSTimeInterval)seconds;

/**
 *  显示录音指示器
 */
+ (void)show;

/**
 *  隐藏录音指示器,使用自带提示语句
 *
 *  @param message 提示信息
 */
+ (void)dismissWithMessage:(NSString *)message;

/**
 *  隐藏hud,带有录音状态
 *
 *  @param progressState 录音状态
 */
+ (void)dismissWithProgressState:(LCCKProgressState)progressState;

/**
 *  修改录音的subTitle显示文字
 *
 *  @param str 需要显示的文字
 */
+ (void)changeSubTitle:(NSString *)str;


@end
