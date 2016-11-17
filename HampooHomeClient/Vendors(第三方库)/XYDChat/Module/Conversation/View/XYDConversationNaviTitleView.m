//
//  XYDConversationNaviTitleView.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/17.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversationNaviTitleView.h"
#import "NSObject+XYDAssociatedObject.h"
#import "XYDConversation.h"
#import "XYDConversation+Extionsion.h"
#import "XYDChatMacro.h"
#import "XYDChatHelper.h"
#import "XYDChatKit.h"

static CGFloat const kXYDTitleFontSize = 17.f;
static void * const XYDConversationNavigationTitleViewShowRemindMuteImageViewContext = (void*)&XYDConversationNavigationTitleViewShowRemindMuteImageViewContext;

@interface XYDConversationNaviTitleView ()

@property (nonatomic, strong) UILabel *conversationNameView;
@property (nonatomic, strong) UILabel *membersCountView;
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UIStackView *containerView;
@property (nonatomic, strong) UIImageView *remindMuteImageView;

@end

@implementation XYDConversationNaviTitleView

- (UIStackView *)containerView {
    if (!_containerView) {
        UIStackView *containerView = [[UIStackView alloc] initWithFrame:CGRectZero];
        containerView.axis = UILayoutConstraintAxisHorizontal;
        containerView.distribution = UIStackViewDistributionFill;
        containerView.alignment = UIStackViewAlignmentCenter;
        
        containerView.frame = ({
            CGRect frame = containerView.frame;
            CGFloat containerViewHeight = self.navigationController.navigationBar.frame.size.height;
            CGFloat containerViewWidth = self.navigationController.navigationBar.frame.size.width - 130;
            frame.size.width = containerViewWidth;
            frame.size.height = containerViewHeight;
            frame;
        });
        [containerView addArrangedSubview:self.conversationNameView];
        [containerView addArrangedSubview:self.membersCountView];
        [containerView addArrangedSubview:self.remindMuteImageView];
        _containerView = containerView;
    }
    return _containerView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != XYDConversationNavigationTitleViewShowRemindMuteImageViewContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == XYDConversationNavigationTitleViewShowRemindMuteImageViewContext) {
        //if ([keyPath isEqualToString:@"showRemindMuteImageView"]) {
        id newKey = change[NSKeyValueChangeNewKey];
        BOOL boolValue = [newKey boolValue];
        self.remindMuteImageView.hidden = !boolValue;
        [self.containerView layoutIfNeeded];//fix member count view won't display when conversationNameView is too long
    }
}

- (instancetype)sharedInit {
    [self addSubview:self.containerView];
    self.showRemindMuteImageView = NO;
    [self addObserver:self forKeyPath:@"showRemindMuteImageView" options:NSKeyValueObservingOptionNew context:XYDConversationNavigationTitleViewShowRemindMuteImageViewContext];
    __unsafe_unretained typeof(self) weakSelf = self;
    [self xyd_executeAtDealloc:^{
        [weakSelf removeObserver:weakSelf forKeyPath:@"showRemindMuteImageView"];
    }];
    [self.containerView layoutIfNeeded];//fix member count view won't display when conversationNameView is too long
    return self;
}

- (instancetype)initWithConversation:(XYDConversation *)conversation navigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        CGFloat membersCount = conversation.members.count;
        NSString *conversationName;
        if ([conversation.xydChat_displayName xyd_containsaString:@","]) {
            self.membersCountView.hidden = NO;
            conversationName = conversation.xydChat_displayName;
        } else {
            conversationName = conversation.xydChat_title;
        }
        if (conversationName.length == 0 || !conversationName) {
            conversationName = XYDChatLocalizedStrings(@"Chat");
        }
        [self setupWithConversationName:conversationName membersCount:membersCount navigationController:navigationController];
        self.remindMuteImageView.hidden = !conversation.muted;
    }
    return self;
}

- (void)setupWithConversationName:(NSString *)conversationName membersCount:(NSInteger)membersCount navigationController:(UINavigationController *)navigationController {
    self.conversationNameView.text = conversationName;
    self.membersCountView.text = [NSString stringWithFormat:@"(%@)", @(membersCount)];
    self.navigationController = navigationController;
    [self sharedInit];
}

- (UIImageView *)remindMuteImageView {
    if (_remindMuteImageView == nil) {
        UIImageView *remindMuteImageView = [[UIImageView alloc] init];
        NSString *remindMuteImageName = @"Connectkeyboad_banner_mute";
        UIImage *remindMuteImage = [XYDChatHelper getImageWithNamed:remindMuteImageName bundleName:@"Other" bundleForClass:[XYDChatKit class]];
        remindMuteImageView.contentMode = UIViewContentModeScaleAspectFill;
        remindMuteImageView.image = remindMuteImage;
        remindMuteImageView.hidden = YES;
        [remindMuteImageView sizeToFit];
        _remindMuteImageView = remindMuteImageView;
    }
    return _remindMuteImageView;
}

- (UILabel *)conversationNameView {
    if (!_conversationNameView) {
        UILabel *conversationNameView = [[UILabel alloc] initWithFrame:CGRectZero];
        conversationNameView.font = [UIFont boldSystemFontOfSize:kXYDTitleFontSize];
        conversationNameView.textColor = [UIColor whiteColor];
        //        conversationNameView.backgroundColor = [UIColor redColor];
        conversationNameView.textAlignment = NSTextAlignmentCenter;
        [conversationNameView sizeToFit];
        conversationNameView.lineBreakMode = NSLineBreakByTruncatingTail;
        _conversationNameView = conversationNameView;
    }
    return _conversationNameView;
}

- (UILabel *)membersCountView {
    if (!_membersCountView) {
        UILabel *membersCountView = [[UILabel alloc] initWithFrame:CGRectZero];
        membersCountView.font = [UIFont boldSystemFontOfSize:kXYDTitleFontSize];
        membersCountView.textColor = [UIColor whiteColor];
        membersCountView.textAlignment = NSTextAlignmentCenter;
        [membersCountView sizeToFit];
        membersCountView.hidden = YES;
        //        membersCountView.backgroundColor = [UIColor blueColor];
        _membersCountView = membersCountView;
    }
    return _membersCountView;
}

@end
