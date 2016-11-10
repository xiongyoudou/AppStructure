//
//  XYDMessageSendStateV.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDMessageSendStateView.h"
#import "NSObject+XYDAssociatedObject.h"
#import "XYDChatHelper.h"


static void * const XYDSendImageViewShouldShowIndicatorViewContext = (void*)&XYDSendImageViewShouldShowIndicatorViewContext;

@interface XYDMessageSendStateView ()

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign, getter=shouldShowIndicatorView) BOOL showIndicatorView;

@end

@implementation XYDMessageSendStateView

- (instancetype)init {
    if (self = [super init]) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidden = YES;
        [self addSubview:self.indicatorView = indicatorView];
        // KVO注册监听
        [self addObserver:self forKeyPath:@"showIndicatorView" options:NSKeyValueObservingOptionNew context:XYDSendImageViewShouldShowIndicatorViewContext];
        __unsafe_unretained typeof(self) weakSelf = self;
        [self xyd_executeAtDealloc:^{
            [weakSelf removeObserver:weakSelf forKeyPath:@"showIndicatorView"];
        }];
        [self addTarget:self action:@selector(failImageViewTap:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)showErrorIcon:(BOOL)showErrorIcon {
    if (showErrorIcon) {
        NSString *imageName = @"MessageSendFail";
        UIImage *image = [XYDChatHelper getImageWithNamed:imageName bundleName:@"MessageBubble" bundleForClass:[self class]];
        [self setImage:image forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicatorView.frame = self.bounds;
}

#pragma mark - Setters
- (void)setMessageSendState:(XYDChatMessageSendState)messageSendState {
    _messageSendState = messageSendState;
    if (_messageSendState == XYDChatMessageSendStateSending) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.indicatorView startAnimating];
        });
        self.showIndicatorView = YES;
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.indicatorView stopAnimating];
        });
        self.showIndicatorView = NO;
    }
    
    switch (_messageSendState) {
        case XYDChatMessageSendStateSending:
            self.showIndicatorView = YES;
            break;
            
        case XYDChatMessageSendStateFailed:
            self.showIndicatorView = NO;
            break;
        default:
            self.hidden = YES;
            break;
    }
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != XYDSendImageViewShouldShowIndicatorViewContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == XYDSendImageViewShouldShowIndicatorViewContext) {
        if ([keyPath isEqualToString:@"showIndicatorView"]) {
            id newKey = change[NSKeyValueChangeNewKey];
            BOOL showIndicatorView = [newKey boolValue];
            if (showIndicatorView) {
                self.hidden = NO;
                self.indicatorView.hidden = NO;
                [self showErrorIcon:NO];
            } else {
                self.hidden = NO;
                self.indicatorView.hidden = YES;
                [self showErrorIcon:YES];
            }
        }
    }
}

- (void)failImageViewTap:(id)sender {
    if (self.shouldShowIndicatorView) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(resendMessage:)]) {
        [self.delegate resendMessage:self];
    }
}

@end
