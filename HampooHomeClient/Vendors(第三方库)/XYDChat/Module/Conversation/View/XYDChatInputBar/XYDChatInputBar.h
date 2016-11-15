//
//  XYDChatInputView.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDChatInputBarDelegate.h"

static CGFloat const kOffsetBetweenBtnAndBar = 8.f; // bar上按钮（语音按钮、表情按钮）距离底部的间距
static CGFloat const kOffsetBetweenTextViewAndBar = 6; // bar上输入框距离底部的距离
static CGFloat const kTextViewFrameMinHeight = 37.f; //kXYDChatChatBarMinHeight - 2*kChatBarTextViewBottomOffset;
static CGFloat const kTextViewFrameMaxHeight = 102.f; //kXYDChatChatBarMaxHeight - 2*kChatBarTextViewBottomOffset;
static CGFloat const kChatBarMaxHeight = kTextViewFrameMaxHeight + 2*kOffsetBetweenTextViewAndBar; //114.0f;
static CGFloat const kChatBarMinHeight = kTextViewFrameMinHeight + 2*kOffsetBetweenTextViewAndBar; //49.0f;

/**
 *  functionView(当前显示的功能视图) 类型
 */
typedef NS_ENUM(NSUInteger, XYDFunctionViewShowType){
    XYDFunctionViewShowNothing /**< 不显示functionView */,
    XYDFunctionViewShowFace /**< 显示表情View */,
    XYDFunctionViewShowVoice /**< 显示录音view */,
    XYDFunctionViewShowMore /**< 显示更多view */,
    XYDFunctionViewShowKeyboard /**< 显示键盘 */,
};

@interface XYDChatInputBar : UIView

// 作为InputBar的代理处理一些事件
@property (weak, nonatomic) id<XYDChatInputBarDelegate> delegate;
// InputBar显示的类型
@property (nonatomic, assign) XYDFunctionViewShowType showType;
@property (nonatomic, readonly) UIViewController *controllerRef;

/*!
 *
 缓存输入框文字，兼具内存缓存和本地数据库缓存的作用。同时也负责着输入框内容被清空时的监听，收缩键盘。内部重写了setter方法，self.cachedText 就相当于self.textView.text，使用最重要的场景：为了显示voiceButton，self.textView.text = nil;
 
 */
@property (copy, nonatomic) NSString *cachedText;

/*!
 * 在 `-presentViewController:animated:completion:` 的completion回调中调用该方法，屏蔽来自其它 ViewController 的键盘通知事件。
 */
- (void)close;

/*!
 * 对应于 `-close` 方法。
 */
- (void)open;

/*!
 * 追加后，输入框默认开启编辑模式
 */
- (void)appendString:(NSString *)string;
- (void)appendString:(NSString *)string beginInputing:(BOOL)beginInputing;

/**
 *  结束输入状态
 */
- (void)endInputing;

/**
 *  进入输入状态
 */
- (void)beginInputing;

@end
