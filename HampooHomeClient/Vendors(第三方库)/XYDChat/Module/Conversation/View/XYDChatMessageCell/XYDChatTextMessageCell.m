//
//  XYDChatTextMessageCell.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTextMessageCell.h"
#import "XYDChatTypeMessage.h"
#import "XYDEmotionManager.h"
#import "XYDChatSettingService.h"


@interface XYDChatTextMessageCell ()

/**
 *  用于显示文本消息的文字
 */
@property (nonatomic, strong) MLLinkLabel *messageTextLabel;
@property (nonatomic, copy, readonly) NSDictionary *textStyle;
@property (nonatomic, strong) NSArray *expressionData;
@property (nonatomic, strong) UIColor *conversationViewMessageLeftTextColor; /**< 左侧文本消息文字颜色 */
@property (nonatomic, strong) UIColor *conversationViewMessageRightTextColor; /**< 右侧文本消息文字颜色 */
@property (nonatomic, strong) UIColor *conversationViewMessageLinkColorLeft; /**< 左侧消息中链接文字颜色，如果没有该项，则使用统一的消息链接文字颜色 */
@property (nonatomic, strong) UIColor *conversationViewMessageLinkColorRight; /**< 右侧消息中链接文字颜色，如果没有该项，则使用统一的消息链接文字颜色 */
@property (nonatomic, strong) UIColor *conversationViewMessageLinkColor; /**< 右侧消息中链接文字颜色，如果没有该项，则使用统一的消息链接文字颜色 */

//TODO:
//ConversationView-Message-Middle-TextColor: 居中文本消息文字颜色

@end

@implementation XYDChatTextMessageCell
@synthesize textStyle = _textStyle;

#pragma mark - Override Methods

- (void)updateConstraints {
    [super updateConstraints];
    UIEdgeInsets edgeMessageBubbleCustomize;
    if (self.messageOwner == XYDChatMessageOwnerTypeSelf) {
        UIEdgeInsets rightEdgeMessageBubbleCustomize = [XYDChatSettingService sharedInstance].rightEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = rightEdgeMessageBubbleCustomize;
    } else {
        UIEdgeInsets leftEdgeMessageBubbleCustomize = [XYDChatSettingService sharedInstance].leftEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = leftEdgeMessageBubbleCustomize;
    }
    [self.messageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).with.insets(edgeMessageBubbleCustomize);
    }];
}

#pragma mark - Public Methods

- (void)setup {
    [self.messageContentView addSubview:self.messageTextLabel];
    UIColor *linkColor = [UIColor blueColor];
    if (self.messageOwner == XYDChatMessageOwnerTypeSelf) {
        self.messageTextLabel.textColor = self.conversationViewMessageRightTextColor;
        if (self.conversationViewMessageLinkColorRight) {
            linkColor = self.conversationViewMessageLinkColorRight;
        } else if (self.conversationViewMessageLinkColor) {
            linkColor = self.conversationViewMessageLinkColor;
        }
    } else {
        self.messageTextLabel.textColor = self.conversationViewMessageLeftTextColor;
        if (self.conversationViewMessageLinkColorLeft) {
            linkColor = self.conversationViewMessageLinkColorLeft;
        } else if (self.conversationViewMessageLinkColor) {
            linkColor = self.conversationViewMessageLinkColor;
        }
    }
    self.messageTextLabel.linkTextAttributes = @{ NSForegroundColorAttributeName : linkColor };
    self.messageTextLabel.activeLinkTextAttributes = @{
                                                       NSForegroundColorAttributeName : linkColor ,
                                                       NSBackgroundColorAttributeName : kDefaultActiveLinkBackgroundColorForMLLinkLabel
                                                       };
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapMessageContentViewGestureRecognizerHandle:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.messageContentView addGestureRecognizer:tapGestureRecognizer];
    [super setup];
    [self addGeneralView];
    
}

- (void)configureCellWithData:(XYDChatTypeMessage *)message {
    [super configureCellWithData:message];
    NSMutableAttributedString *attrS = [XYDEmotionManager emotionStrWithString:message.text];
    [attrS addAttributes:self.textStyle range:NSMakeRange(0, attrS.length)];
    self.messageTextLabel.attributedText = attrS;
}

#pragma mark - Getters

- (MLLinkLabel *)messageTextLabel {
    if (!_messageTextLabel) {
        _messageTextLabel = [[MLLinkLabel alloc] init];
        _messageTextLabel.font = [XYDChatSettingService sharedInstance].defaultThemeTextMessageFont;
        _messageTextLabel.numberOfLines = 0;
        _messageTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        __weak __typeof(self) weakSelf = self;
        [_messageTextLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            if ([weakSelf.delegate respondsToSelector:@selector(messageCell:didTapLinkText:linkType:)]) {
                [weakSelf.delegate messageCell:weakSelf didTapLinkText:linkText linkType:link.linkType];
            }
        }];
    }
    return _messageTextLabel;
}

- (void)doubleTapMessageContentViewGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(textMessageCellDoubleTapped:)]) {
            [self.delegate textMessageCellDoubleTapped:self];
        }
    }
}

- (NSDictionary *)textStyle {
    if (!_textStyle) {
        UIFont *font = [XYDChatSettingService sharedInstance].defaultThemeTextMessageFont;
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentLeft;
        style.paragraphSpacing = 0.25 * font.lineHeight;
        style.hyphenationFactor = 1.0;
        _textStyle = @{NSFontAttributeName: font,
                       NSParagraphStyleAttributeName: style};
    }
    return _textStyle;
}

#pragma mark -
#pragma mark - LCCKChatMessageCellSubclassing Method

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeText;
}

- (UIColor *)conversationViewMessageLeftTextColor {
    if (_conversationViewMessageLeftTextColor) {
        return _conversationViewMessageLeftTextColor;
    }
    _conversationViewMessageLeftTextColor = [[XYDChatSettingService sharedInstance] defaultThemeColorForKey:@"ConversationView-Message-Left-TextColor"];
    return _conversationViewMessageLeftTextColor;
}

- (UIColor *)conversationViewMessageRightTextColor {
    if (_conversationViewMessageRightTextColor) {
        return _conversationViewMessageRightTextColor;
    }
    _conversationViewMessageRightTextColor = [[XYDChatSettingService sharedInstance] defaultThemeColorForKey:@"ConversationView-Message-Right-TextColor"];
    return _conversationViewMessageRightTextColor;
}

- (UIColor *)conversationViewMessageLinkColorLeft {
    if (_conversationViewMessageLinkColorLeft) {
        return _conversationViewMessageLinkColorLeft;
    }
    _conversationViewMessageLinkColorLeft = [[XYDChatSettingService sharedInstance] defaultThemeColorForKey:@"ConversationView-Message-LinkColor-Left"];
    return _conversationViewMessageLinkColorLeft;
}

- (UIColor *)conversationViewMessageLinkColorRight {
    if (_conversationViewMessageLinkColorRight) {
        return  _conversationViewMessageLinkColorRight;
    }
    _conversationViewMessageLinkColorRight = [[XYDChatSettingService sharedInstance] defaultThemeColorForKey:@"ConversationView-Message-LinkColor-Right"];
    return _conversationViewMessageLinkColorRight;
}

- (UIColor *)conversationViewMessageLinkColor {
    if (_conversationViewMessageLinkColor) {
        return _conversationViewMessageLinkColor;
    }
    _conversationViewMessageLinkColor = [[XYDChatSettingService sharedInstance] defaultThemeColorForKey:@"ConversationView-Message-LinkColor"];
    return _conversationViewMessageLinkColor;
}


@end
