//
//  XYDChatVoiceMessageCell.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatVoiceMessageCell.h"
#import "NSObject+XYDAssociatedObject.h"
#import "XYDChatHelper.h"
#import "XYDChatAudioMessage.h"

static void * const XYDChatChatVoiceMessageCellVoiceMessageStateContext = (void*)&XYDChatChatVoiceMessageCellVoiceMessageStateContext;

@interface XYDChatVoiceMessageCell ()

@property (nonatomic, strong) UIImageView *messageVoiceStatusImageView;
@property (nonatomic, strong) UILabel *messageVoiceSecondsLabel;
@property (nonatomic, strong) UIActivityIndicatorView *messageIndicatorView;

@end

@implementation XYDChatVoiceMessageCell

#pragma mark - Override Methods

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setVoiceMessageState:XYDChatVoiceMessageStateNormal];
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.messageOwner == XYDChatMessageOwnerTypeSelf) {
        [self.messageVoiceStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentView.mas_right).with.offset(-12);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        [self.messageVoiceSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageVoiceStatusImageView.mas_left).with.offset(-8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        [self.messageIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.messageContentView);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    } else if (self.messageOwner == XYDChatMessageOwnerTypeOther) {
        [self.messageVoiceStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageContentView.mas_left).with.offset(12);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        
        [self.messageVoiceSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageVoiceStatusImageView.mas_right).with.offset(8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        [self.messageIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.messageContentView);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    }
    
    [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(@(80)).priorityHigh();
    }];
    
}

#pragma mark - Public Methods

- (void)setup {
    [self.messageContentView addSubview:self.messageVoiceSecondsLabel];
    [self.messageContentView addSubview:self.messageVoiceStatusImageView];
    [self.messageContentView addSubview:self.messageIndicatorView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMessageImageViewGestureRecognizerHandler:)];
    [self.messageContentView addGestureRecognizer:recognizer];
    [super setup];
    [self addGeneralView];
    self.voiceMessageState = XYDChatVoiceMessageStateNormal;
    [[XYDAudioPlayer sharePlayer]  addObserver:self forKeyPath:@"audioPlayerState" options:NSKeyValueObservingOptionNew context:XYDChatChatVoiceMessageCellVoiceMessageStateContext];
    __unsafe_unretained typeof(self) weakSelf = self;
    [self xyd_executeAtDealloc:^{
        [[XYDAudioPlayer sharePlayer] removeObserver:weakSelf forKeyPath:@"audioPlayerState"];
    }];
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != XYDChatChatVoiceMessageCellVoiceMessageStateContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == XYDChatChatVoiceMessageCellVoiceMessageStateContext) {
        //if ([keyPath isEqualToString:@"audioPlayerState"]) {
        NSNumber *audioPlayerStateNumber = change[NSKeyValueChangeNewKey];
        XYDChatVoiceMessageState audioPlayerState = [audioPlayerStateNumber intValue];
        switch (audioPlayerState) {
            case XYDChatVoiceMessageStateCancel:
            case XYDChatVoiceMessageStateNormal:
                self.voiceMessageState = XYDChatVoiceMessageStateCancel;
                break;
                
            default: {
                NSString *playerIdentifier = [[XYDAudioPlayer sharePlayer] identifier];
                if (playerIdentifier) {
                    NSString *messageId = self.message.serverMessageId;
                    if (playerIdentifier && [messageId isEqualToString:playerIdentifier]) {
                        self.voiceMessageState = audioPlayerState;
                    }
                }
            }
                break;
        }
    }
}

- (void)singleTapMessageImageViewGestureRecognizerHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(messageCellTappedMessage:)]) {
            [self.delegate messageCellTappedMessage:self];
        }
    }
}

- (void)configureCellWithData:(XYDChatAudioMessage *)message {
    [super configureCellWithData:message];
    NSUInteger voiceDuration = message.voiceDuration;
    NSString *voiceDurationString = [NSString stringWithFormat:@"%@", @(voiceDuration)];
    self.messageVoiceSecondsLabel.text = [NSString stringWithFormat:@"%@''", voiceDurationString];
    //设置正确的voiceMessageCell播放状态
    NSString *identifier = [[XYDAudioPlayer sharePlayer] identifier];
    if (identifier) {
        NSString *messageId = message.serverMessageId;
        if (messageId == identifier) {
            if (message.mediaType == XYDChatMessageMediaTypeAudio) {
                [self setVoiceMessageState:[[XYDAudioPlayer sharePlayer] audioPlayerState]];
            }
        }
    }
    
    if (voiceDuration > 2) {
        __block CGFloat length;
        CGFloat lengthUnit = 10.f;
        // 1-2 长度固定, 2-10s每秒增加一个单位, 10-60s每10s增加一个单位
        do {
            if (voiceDuration <= 10) {
                length = lengthUnit*(voiceDuration-2);
                break;
            }
            if (voiceDuration > 10) {
                length = lengthUnit*(10-2) + lengthUnit*((voiceDuration-2)/10);
                break;
            }
        } while (NO);
        [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80+length));
        }];
    } else {
        [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80));
        }];
    }
}

#pragma mark - Getters

- (UIImageView *)messageVoiceStatusImageView {
    if (!_messageVoiceStatusImageView) {
        _messageVoiceStatusImageView = [XYDChatHelper messageVoiceAnimationImageViewWithBubbleMessageType:self.messageOwner];
    }
    return _messageVoiceStatusImageView;
}

- (UILabel *)messageVoiceSecondsLabel {
    if (!_messageVoiceSecondsLabel) {
        _messageVoiceSecondsLabel = [[UILabel alloc] init];
        _messageVoiceSecondsLabel.font = [UIFont systemFontOfSize:14.0f];
        _messageVoiceSecondsLabel.text = @"0''";
    }
    return _messageVoiceSecondsLabel;
}

- (UIActivityIndicatorView *)messageIndicatorView {
    if (!_messageIndicatorView) {
        _messageIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _messageIndicatorView;
}

#pragma mark - Setters

- (void)setVoiceMessageState:(XYDChatVoiceMessageState)voiceMessageState {
    if (_voiceMessageState != voiceMessageState) {
        _voiceMessageState = voiceMessageState;
    }
    self.messageVoiceSecondsLabel.hidden = NO;
    self.messageVoiceStatusImageView.hidden = NO;
    self.messageIndicatorView.hidden = YES;
    [self.messageIndicatorView stopAnimating];
    
    if (_voiceMessageState == XYDChatVoiceMessageStatePlaying) {
        self.messageVoiceStatusImageView.highlighted = YES;
        [self.messageVoiceStatusImageView startAnimating];
    } else if (_voiceMessageState == XYDChatVoiceMessageStateDownloading) {
        self.messageVoiceSecondsLabel.hidden = YES;
        self.messageVoiceStatusImageView.hidden = YES;
        self.messageIndicatorView.hidden = NO;
        [self.messageIndicatorView startAnimating];
    } else {
        self.messageVoiceStatusImageView.highlighted = NO;
        [self.messageVoiceStatusImageView stopAnimating];
    }
}

#pragma mark -
#pragma mark - XYDChatChatMessageCellSubclassing Method

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeAudio;
}

@end
