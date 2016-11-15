//
//  XYDWebViewProgressView.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYDWebViewProgressView : UIView

@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
