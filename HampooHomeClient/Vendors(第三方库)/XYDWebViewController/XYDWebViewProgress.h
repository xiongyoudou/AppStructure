//
//  XYDWebViewProgress.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif

extern const float XYDInitialProgressValue;
extern const float XYDInteractiveProgressValue;
extern const float XYDFinalProgressValue;

typedef void (^XYDWebViewProgressBlock)(float progress);

@protocol XYDWebViewProgressDelegate;

@interface XYDWebViewProgress : NSObject<UIWebViewDelegate>

@property (nonatomic, njk_weak) id<XYDWebViewProgressDelegate>progressDelegate;
@property (nonatomic, njk_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) XYDWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;

@end

@protocol XYDWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(XYDWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end


