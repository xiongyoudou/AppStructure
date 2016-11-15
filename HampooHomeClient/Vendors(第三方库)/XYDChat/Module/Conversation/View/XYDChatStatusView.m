//
//  XYDChatStatusView.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatStatusView.h"
#import "XYDChatHelper.h"

static CGFloat XYDChatStatusImageViewHeight = 20;
static CGFloat XYDChatHorizontalSpacing = 15;
static CGFloat XYDChatHorizontalLittleSpacing = 5;

@interface XYDChatStatusView ()

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation XYDChatStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.statusImageView];
    [self addSubview:self.statusLabel];
}

#pragma mark - Propertys

- (UIImageView *)statusImageView {
    if (_statusImageView == nil) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XYDChatHorizontalSpacing, (XYDChatStatusViewHight - XYDChatStatusImageViewHeight) / 2, XYDChatStatusImageViewHeight, XYDChatStatusImageViewHeight)];
        _statusImageView.image =  ({
            NSString *imageName = @"MessageSendFail";
            UIImage *image = [XYDChatHelper  getImageWithNamed:imageName bundleName:@"MessageBubble" bundleForClass:[self class]];
            image;});
    }
    return _statusImageView;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_statusImageView.frame) + XYDChatHorizontalLittleSpacing, 0, self.frame.size.width - CGRectGetMaxX(_statusImageView.frame) - XYDChatHorizontalSpacing - XYDChatHorizontalLittleSpacing, XYDChatStatusViewHight)];
        _statusLabel.font = [UIFont systemFontOfSize:15.0];
        _statusLabel.textColor = [UIColor grayColor];
//        _statusLabel.text = XYDChatLocalizedStrings(@"netDisconnected");
    }
    return _statusLabel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(statusViewClicked:)]) {
        [self.delegate statusViewClicked:self];
    }
}

@end
