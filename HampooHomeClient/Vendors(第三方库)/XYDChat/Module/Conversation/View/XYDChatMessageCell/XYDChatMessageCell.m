//
//  XYDChatMessageCell.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessageCell.h"
#import "XYDChatConstant.h"
#import "XYDChatMenuItem.h"
#import "XYDChatHelper.h"
#import "XYDChatKit.h"
#import "XYDChatSettingService.h"

#import "XYDChatTextMessageCell.h"
#import "XYDChatImageMessageCell.h"
#import "XYDChatLocationMessageCell.h"
#import "XYDChatSystemMessageCell.h"
#import "XYDChatVoiceMessageCell.h"
#import "XYDChatContentView.h"
#import "XYDMessageSendStateView.h"
#import "XYDChatServiceDefinition.h"

NSMutableDictionary const *XYDChatChatMessageCellMediaTypeDict = nil;
static CGFloat const kAvatarImageViewWidth = 50.f;
static CGFloat const kAvatarImageViewHeight = kAvatarImageViewWidth;
static CGFloat const XYDChatMessageSendStateViewWidthHeight = 30.f;
static CGFloat const XYDChatMessageSendStateViewLeftOrRightToMessageContentView = 2.f;
static CGFloat const XYDChatAvatarToMessageContent = 5.f;

static CGFloat const XYDChatAvatarBottomToMessageContentTop = -1.f;


static CGFloat const XYDChat_MSG_CELL_EDGES_OFFSET = 16;
static CGFloat const XYDChat_MSG_CELL_NICKNAME_HEIGHT = 16;
static CGFloat const XYDChat_MSG_CELL_NICKNAME_FONT_SIZE = 12;


@interface XYDChatMessageCell ()

@property (nonatomic, strong, readwrite) XYDChatMessage *message;
@property (nonatomic, assign, readwrite) XYDChatMessageMediaType mediaType;
@property (nonatomic, strong) UIColor *conversationViewSenderNameTextColor;

@end

@implementation XYDChatMessageCell

+ (void)registerCustomMessageCell {
    [self registerSubclass];
}

+ (void)registerSubclass {
    if ([self conformsToProtocol:@protocol(XYDChatMessageCellSubclassing)]) {
        Class<XYDChatMessageCellSubclassing> class = self;
        XYDChatMessageMediaType mediaType = [class classMediaType];
        [self registerClass:class forMediaType:mediaType];
    }
}

+ (Class)classForMediaType:(XYDChatMessageMediaType)mediaType {
    NSNumber *key = [NSNumber numberWithInteger:mediaType];
    Class class = [XYDChatChatMessageCellMediaTypeDict objectForKey:key];
    if (!class) {
        class = self;
    }
    return class;
}

+ (void)registerClass:(Class)class forMediaType:(XYDChatMessageMediaType)mediaType {
    if (!XYDChatChatMessageCellMediaTypeDict) {
        XYDChatChatMessageCellMediaTypeDict = [[NSMutableDictionary alloc] init];
    }
    NSNumber *key = [NSNumber numberWithInteger:mediaType];
    Class c = [XYDChatChatMessageCellMediaTypeDict objectForKey:key];
    if (!c || [class isSubclassOfClass:c]) {
        [XYDChatChatMessageCellMediaTypeDict setObject:class forKey:key];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

// add support for XYDChatMenuItem. Needs to be called once per class.
+ (void)load {
    [XYDChatMenuItem installMenuHandlerForObject:self];
}

+ (void)initialize {
    [XYDChatMenuItem installMenuHandlerForObject:self];
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - Override Methods

- (BOOL)showName {
    BOOL isMessageOwner = self.messageOwner == XYDChatMessageOwnerTypeOther;
    BOOL isMessageChatTypeGroup = self.messageChatType == XYDChatConversationTypeGroup;
    if (isMessageOwner && isMessageChatTypeGroup) {
        self.nickNameLabel.hidden = NO;
        return YES;
    }
    self.nickNameLabel.hidden = YES;
    return NO;
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.messageOwner == XYDChatMessageOwnerTypeSystem || self.messageOwner == XYDChatMessageOwnerTypeUnknown) {
        return;
    }
    if (self.messageOwner == XYDChatMessageOwnerTypeSelf) {
        if (self.avatarImageView.superview) {
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).with.offset(-XYDChat_MSG_CELL_EDGES_OFFSET);
                make.top.equalTo(self.contentView.mas_top).with.offset(XYDChat_MSG_CELL_EDGES_OFFSET);
                make.width.equalTo(@(kAvatarImageViewWidth));
                make.height.equalTo(@(kAvatarImageViewHeight));
            }];
        }
        if (self.nickNameLabel.superview) {
            [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView.mas_top);
                make.right.equalTo(self.avatarImageView.mas_left).with.offset(-XYDChat_MSG_CELL_EDGES_OFFSET);
                make.width.mas_lessThanOrEqualTo(@120);
                make.height.equalTo(@0);
            }];
        }
        if (self.messageContentView.superview) {
            [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.avatarImageView.mas_left).with.offset(-XYDChatAvatarToMessageContent);
                make.top.equalTo(self.nickNameLabel.mas_bottom).with.offset(self.showName ? 0 : XYDChatAvatarBottomToMessageContentTop);
                CGFloat width = [UIApplication sharedApplication].keyWindow.frame.size.width;
                CGFloat height = [UIApplication sharedApplication].keyWindow.frame.size.height;
                CGFloat widthLimit = MIN(width, height)/10 * 7;
                
                make.width.lessThanOrEqualTo(@(widthLimit)).priorityHigh();
                make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-XYDChat_MSG_CELL_EDGES_OFFSET).priorityLow();
            }];
        }
        if (self.messageSendStateView.superview) {
            [self.messageSendStateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.messageContentView.mas_left).with.offset(-XYDChatMessageSendStateViewLeftOrRightToMessageContentView);
                make.centerY.equalTo(self.messageContentView.mas_centerY);
                make.width.equalTo(@(XYDChatMessageSendStateViewWidthHeight));
                make.height.equalTo(@(XYDChatMessageSendStateViewWidthHeight));
            }];
        }
        if (self.messageReadStateImageView.superview) {
            [self.messageReadStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.messageContentView.mas_left).with.offset(-8);
                make.centerY.equalTo(self.messageContentView.mas_centerY);
                make.width.equalTo(@10);
                make.height.equalTo(@10);
            }];
        }
    } else if (self.messageOwner == XYDChatMessageOwnerTypeOther){
        if (self.avatarImageView.superview) {
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).with.offset(XYDChat_MSG_CELL_EDGES_OFFSET);
                make.top.equalTo(self.contentView.mas_top).with.offset(XYDChat_MSG_CELL_EDGES_OFFSET);
                make.width.equalTo(@(kAvatarImageViewWidth));
                make.height.equalTo(@(kAvatarImageViewHeight));
            }];
        }
        if (self.nickNameLabel.superview) {
            [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView.mas_top);
                make.left.equalTo(self.avatarImageView.mas_right).with.offset(XYDChat_MSG_CELL_EDGES_OFFSET);
                make.width.mas_lessThanOrEqualTo(@120);
                make.height.equalTo(self.messageChatType == XYDChatConversationTypeGroup ? @(XYDChat_MSG_CELL_NICKNAME_HEIGHT) : @0);
            }];
        }
        if (self.messageContentView.superview) {
            [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.avatarImageView.mas_right).with.offset(XYDChatAvatarToMessageContent);
                make.top.equalTo(self.nickNameLabel.mas_bottom).with.offset(self.showName ? 0 : XYDChatAvatarBottomToMessageContentTop);
                CGFloat width = [UIApplication sharedApplication].keyWindow.frame.size.width;
                CGFloat height = [UIApplication sharedApplication].keyWindow.frame.size.height;
                CGFloat widthLimit = MIN(width, height)/10 * 7;
                make.width.lessThanOrEqualTo(@(widthLimit)).priorityHigh();
                make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-XYDChat_MSG_CELL_EDGES_OFFSET).priorityLow();
            }];
        }
        if (self.messageSendStateView.superview) {
            [self.messageSendStateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageContentView.mas_right).with.offset(XYDChatMessageSendStateViewLeftOrRightToMessageContentView);
                make.centerY.equalTo(self.messageContentView.mas_centerY);
                make.width.equalTo(@(XYDChatMessageSendStateViewWidthHeight));
                make.height.equalTo(@(XYDChatMessageSendStateViewWidthHeight));
            }];
        }
        if (self.messageReadStateImageView.superview) {
            [self.messageReadStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageContentView.mas_right).with.offset(8);
                make.centerY.equalTo(self.messageContentView.mas_centerY);
                make.width.equalTo(@10);
                make.height.equalTo(@10);
            }];
        }
    }
    
    if (self.messageContentBackgroundImageView.superview) {
        [self.messageContentBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.messageContentView);
        }];
    }
    
    if (!self.showName) {
        if (self.nickNameLabel.superview) {
            [self.nickNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self.contentView];
    if (CGRectContainsPoint(self.messageContentView.frame, touchPoint)) {
        self.messageContentBackgroundImageView.highlighted = YES;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.messageContentBackgroundImageView.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.messageContentBackgroundImageView.highlighted = NO;
}

#pragma mark - Private Methods

- (BOOL)isAbleToTap {
    BOOL isAbleToTap = NO;
    //For Link handle
    if (self.mediaType < 0 && ![self isKindOfClass:[XYDChatTextMessageCell class]]) {
        isAbleToTap = YES;
    }
    return isAbleToTap;
}

- (void)addGeneralView {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.messageContentView];
    [self.contentView addSubview:self.messageReadStateImageView];
    [self.contentView addSubview:self.messageSendStateView];
    
    [self.messageContentBackgroundImageView setImage:[XYDChatHelper bubbleImageViewForType:self.messageOwner messageType:self.mediaType isHighlighted:NO]];
    [self.messageContentBackgroundImageView setHighlightedImage:[XYDChatHelper bubbleImageViewForType:self.messageOwner messageType:self.mediaType isHighlighted:YES]];
    
    self.messageContentView.layer.mask.contents = (__bridge id _Nullable)(self.messageContentBackgroundImageView.image.CGImage);
    [self.contentView insertSubview:self.messageContentBackgroundImageView belowSubview:self.messageContentView];
    
///!!!:此处的一句代码的使用造成的Constraint的警告花费我好几天时间
/*
最后只需要一句代码稍作替换即没有警告，不知道为何，留待日后钻研！产生警告的原因是生成了一些如下的无用约束:
 <NSLayoutConstraint:0x1702864a0 UITableViewCellContentView:0x100b8eb20.height == 44>,
 <NSAutoresizingMaskLayoutConstraint:0x1702864f0 UITableViewCellContentView:0x100b8eb20.(null) == 0>,
 <NSAutoresizingMaskLayoutConstraint:0x170286540 UITableViewCellContentView:0x100b8eb20.(null) == 0>,
 <NSLayoutConstraint:0x170286450 UITableViewCellContentView:0x100b8eb20.width == 320>
 */
    
//    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
    
    
    self.messageSendStateView.hidden = YES;
    self.messageReadStateImageView.hidden = YES;
    
    
    if (self.isAbleToTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.contentView addGestureRecognizer:tap];
    }
    UITapGestureRecognizer *avatarImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewHandleTap:)];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:avatarImageViewTap];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
}

- (void)setup {
    if (![self conformsToProtocol:@protocol(XYDChatMessageCellSubclassing)]) {
        [NSException raise:@"XYDChatChatMessageCellNotSubclassException" format:@"Class does not conform XYDChatChatMessageCellSubclassing protocol."];
    }
    self.mediaType = [[self class] classMediaType];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public Methods

- (void)configureCellWithData:(id)message {
    NSString *nickName = nil;
    NSURL *avatarURL = nil;
    XYDChatMessageSendState sendStatus;
    
    /*
    if ([message XYDChat_isCustomMessage]) {
        NSString *senderClientId = [(AVIMTypedMessage *)message clientId];
        NSError *error;
        //TODO:如果我正在群里聊天，这时有人进入群聊，需要异步获取头像等信息，模仿ConversationList的做法。
        [[XYDChatUserSystemService sharedInstance] getCachedProfileIfExists:senderClientId name:&nickName avatarURL:&avatarURL error:&error];
        if (!nickName)  { nickName = senderClientId; }
        self.message = nil;
        sendStatus = (XYDChatMessageSendState)[(AVIMTypedMessage *)message status];
    } else {
     */
        self.message = message;
        nickName = self.message.localDisplayName;
        avatarURL = self.message.sender.avatarURL;
        sendStatus = self.message.sendStatus;
        //FIXME: SDK 暂不支持已读未读
        //        if ([(XYDChatMessage *)message messageReadState]) {
        //            self.messageReadState = self.message.messageReadState;
        //        }
//    }
    self.nickNameLabel.text = nickName;
    [self.avatarImageView sd_setImageWithURL:avatarURL
                            placeholderImage:({
        NSString *imageName = @"Placeholder_Avatar";
        UIImage *image = [XYDChatHelper getImageWithNamed:imageName bundleName:@"Placeholder" bundleForClass:[self class]];
        image;})
     ];
    self.messageSendState = sendStatus;
}

#pragma mark - Private Methods

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [tap locationInView:self.contentView];
        if (CGRectContainsPoint(self.messageContentView.frame, tapPoint)) {
            [self.delegate messageCellTappedMessage:self];
        }  else if (!CGRectContainsPoint(self.avatarImageView.frame, tapPoint)) {
            //FIXME:Never invoked
            [self.delegate messageCellTappedBlank:self];
        }
    }
}

- (void)avatarImageViewHandleTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self.delegate messageCellTappedHead:self];
    }
}

#pragma mark - Setters

- (void)setMessageSendState:(XYDChatMessageSendState)messageSendState {
    _messageSendState = messageSendState;
    if (self.messageOwner == XYDChatMessageOwnerTypeOther) {
        self.messageSendStateView.hidden = YES;
    }
    self.messageSendStateView.messageSendState = messageSendState;
}

- (void)setMessageReadState:(XYDChatMessageReadState)messageReadState {
    _messageReadState = messageReadState;
    if (self.messageOwner == XYDChatMessageOwnerTypeSelf) {
        self.messageSendStateView.hidden = YES;
    }
    switch (_messageReadState) {
        case XYDChatMessageUnRead:
            self.messageReadStateImageView.hidden = NO;
            break;
        default:
            self.messageReadStateImageView.hidden = YES;
            break;
    }
}

#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        /*
        XYDChatAvatarImageViewCornerRadiusBlock avatarImageViewCornerRadiusBlock = [LCChatKit sharedInstance].avatarImageViewCornerRadiusBlock;
        if (avatarImageViewCornerRadiusBlock) {
            CGSize avatarImageViewSize = CGSizeMake(kAvatarImageViewWidth, kAvatarImageViewHeight);
            CGFloat avatarImageViewCornerRadius = avatarImageViewCornerRadiusBlock(avatarImageViewSize);
            self.avatarImageView.XYDChat_cornerRadius = avatarImageViewCornerRadius;
        }
         */
        [self bringSubviewToFront:_avatarImageView];
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:XYDChat_MSG_CELL_NICKNAME_FONT_SIZE];
        _nickNameLabel.textColor = self.conversationViewSenderNameTextColor;
        _nickNameLabel.text = @"nickname";
        [_nickNameLabel sizeToFit];
    }
    return _nickNameLabel;
}

- (XYDChatContentView *)messageContentView {
    if (!_messageContentView) {
        _messageContentView = [[XYDChatContentView alloc] init];
    }
    return _messageContentView;
}

- (UIImageView *)messageReadStateImageView {
    if (!_messageReadStateImageView) {
        _messageReadStateImageView = [[UIImageView alloc] init];
    }
    return _messageReadStateImageView;
}

- (XYDMessageSendStateView *)messageSendStateView {
    if (!_messageSendStateView) {
        _messageSendStateView = [[XYDMessageSendStateView alloc] init];
        _messageSendStateView.delegate = self;
    }
    return _messageSendStateView;
}

- (UIImageView *)messageContentBackgroundImageView {
    if (!_messageContentBackgroundImageView) {
        _messageContentBackgroundImageView = [[UIImageView alloc] init];
    }
    return _messageContentBackgroundImageView;
}

- (XYDChatConversationType)messageChatType {
    if ([self.reuseIdentifier xyd_containsaString:XYDChatCellIdentifierGroup]) {
        return XYDChatConversationTypeGroup;
    }
    return XYDChatConversationTypeSingle;
}

- (XYDChatMessageOwnerType)messageOwner {
    if ([self.reuseIdentifier xyd_containsaString:XYDChatCellIdentifierOwnerSelf]) {
        return XYDChatMessageOwnerTypeSelf;
    } else if ([self.reuseIdentifier xyd_containsaString:XYDChatCellIdentifierOwnerOther]) {
        return XYDChatMessageOwnerTypeOther;
    } else if ([self.reuseIdentifier xyd_containsaString:XYDChatCellIdentifierOwnerSystem]) {
        return XYDChatMessageOwnerTypeSystem;
    }
    return XYDChatMessageOwnerTypeUnknown;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGes {
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        CGPoint longPressPoint = [longPressGes locationInView:self.contentView];
        if (!CGRectContainsPoint(self.messageContentView.frame, longPressPoint)) {
            if (CGRectContainsPoint(self.avatarImageView.frame, longPressPoint)) {
                if ([self.delegate respondsToSelector:@selector(avatarImageViewLongPressed:)]) {
                    [self.delegate avatarImageViewLongPressed:self];
                }
            }
            return;
        }
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        NSUInteger delaySeconds = XYDChatAnimateDuration;
        dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
        dispatch_after(when, dispatch_get_main_queue(), ^{
            [self becomeFirstResponder];
            XYDChatLongPressMessageBlock longPressMessageBlock = [XYDChatKit sharedInstance].longPressMessageBlock;
            NSArray *menuItems = [NSArray array];
            NSDictionary *userInfo = @{
                                       XYDChatLongPressMessageUserInfoKeyFromController : self.delegate,
                                       XYDChatLongPressMessageUserInfoKeyFromView : self.tableView,
                                       };
            if (longPressMessageBlock) {
                menuItems = longPressMessageBlock(self.message, userInfo);
            } else {
                XYDChatMenuItem *copyItem = [[XYDChatMenuItem alloc] initWithTitle:@"copy"
                                                                       block:^{
//                                                                           UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                                                                           [pasteboard setString:[self.message text]];
                                                                       }];
                //TODO:添加“转发”
                if (self.mediaType == XYDChatMessageMediaTypeText) {
                    menuItems = @[ copyItem ];
                }
            }
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuItems:menuItems];
            [menuController setArrowDirection:UIMenuControllerArrowDown];
            UITableView *tableView = self.tableView;
            CGRect targetRect = [self convertRect:self.messageContentView.frame toView:tableView];
            [menuController setTargetRect:targetRect inView:tableView];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleMenuWillShowNotification:)
                                                         name:UIMenuControllerWillShowMenuNotification
                                                       object:nil];
            [menuController setMenuVisible:YES animated:YES];
        });
    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark -
#pragma mark - XYDChatSendImageViewDelegate Method

- (void)resendMessage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(resendMessage:)]) {
        [self.delegate resendMessage:self];
    }
}

- (UIColor *)conversationViewSenderNameTextColor {
    if (_conversationViewSenderNameTextColor) {
        return _conversationViewSenderNameTextColor;
    }
    _conversationViewSenderNameTextColor = [[XYDChatSettingService sharedInstance] defaultThemeColorForKey:@"ConversationView-SenderName-TextColor"];
    return _conversationViewSenderNameTextColor;
}

@end
