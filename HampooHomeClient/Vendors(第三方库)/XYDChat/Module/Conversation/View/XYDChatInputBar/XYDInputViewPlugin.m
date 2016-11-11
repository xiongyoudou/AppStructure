//
//  XYDInputViewwPlugin.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDInputViewPlugin.h"
#import "XYDChatInputBar.h"
#import "XYDChatSettingService.h"

NSMutableDictionary const *XYDChatInputViewPluginDict = nil;
NSMutableArray const *XYDChatInputViewPluginArray = nil;

@interface XYDInputViewPlugin ()

@property (nonatomic, readwrite) XYDChatInputViewPluginType pluginType;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UIColor *messageInputViewMorePanelTextColor;

@end

@implementation XYDInputViewPlugin
@synthesize delegate = _delegate;
@synthesize inputViewRef = _inputViewRef;
@synthesize pluginContentView = _pluginContentView;
@synthesize pluginType = _pluginType;
@synthesize pluginIconImage = _pluginIconImage;
@synthesize pluginTitle = _pluginTitle;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;

- (instancetype)init {
    if (![self conformsToProtocol:@protocol(XYDChatInputViewPluginSubclassing)]) {
        [NSException raise:@"XYDChatInputViewPluginNotSubclassException" format:@"Class does not conform XYDChatInputViewPluginSubclassing protocol."];
    }
    if ((self = [super init])) {
        self.pluginType = [[self class] classPluginType];
    }
    return self;
}

+ (void)registerCustomInputViewPlugin {
    [self registerSubclass];
}

+ (void)registerSubclass {
    if ([self conformsToProtocol:@protocol(XYDChatInputViewPluginSubclassing)]) {
        Class<XYDChatInputViewPluginSubclassing> class = self;
        XYDChatInputViewPluginType type = [class classPluginType];
        [self registerClass:class forMediaType:type];
    }
}

+ (Class)classForMediaType:(XYDChatInputViewPluginType)type {
    NSNumber *typeKey = [NSNumber numberWithInteger:type];
    Class class = [XYDChatInputViewPluginDict objectForKey:typeKey];
    if (!class) {
        class = self;
    }
    return class;
}

+ (void)registerClass:(Class)class forMediaType:(XYDChatInputViewPluginType)type {
    if (!XYDChatInputViewPluginDict) {
        XYDChatInputViewPluginDict = [[NSMutableDictionary alloc] init];
    }
    if (!XYDChatInputViewPluginArray) {
        XYDChatInputViewPluginArray = [[NSMutableArray alloc] init];
    }
    NSNumber *typeKey = [NSNumber numberWithInteger:type];
    Class c = [XYDChatInputViewPluginDict objectForKey:typeKey];
    if (!c || [class isSubclassOfClass:c]) {
        [XYDChatInputViewPluginDict setObject:class forKey:typeKey];
        NSDictionary *dictionary = @{
                                     XYDChatInputViewPluginTypeKey : typeKey,
                                     XYDChatInputViewPluginClassKey : class,
                                     };
        [XYDChatInputViewPluginArray addObject:dictionary];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [self setup];
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(4);
        make.centerX.equalTo(self);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).with.offset(3);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

#pragma mark - Public Methods

- (void)fillWithPluginTitle:(NSString *)pluginTitle
            pluginIconImage:(UIImage *)pluginIconImage {
    self.titleLabel.text = pluginTitle;
    [self.button setBackgroundImage:pluginIconImage forState:UIControlStateNormal];
}

#pragma mark - Private Methods

- (void)setup {
    [self addSubview:self.button];
    [self addSubview:self.titleLabel];
    [self updateConstraintsIfNeeded];
}

- (void)buttonAction {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.button setHighlighted:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.button setHighlighted:NO];
}

#pragma mark - Getters
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.textColor = self.messageInputViewMorePanelTextColor;
    }
    return _titleLabel;
}

- (void)pluginDidClicked {
    [self sendCustomMessageHandler];
}

- (XYDConversationVCtrl *)conversationViewController {
    if ([self.inputViewRef.controllerRef isKindOfClass:[XYDChatSettingService class]]) {
        return (XYDConversationVCtrl *)self.inputViewRef.controllerRef;
    } else {
        return nil;
    }
}

- (UIColor *)messageInputViewMorePanelTextColor {
    if (_messageInputViewMorePanelTextColor) {
        return _messageInputViewMorePanelTextColor;
    }
    _messageInputViewMorePanelTextColor = [[XYDChatSettingService sharedInstance] defaultThemeColorForKey:@"MessageInputView-MorePanel-TextColor"];
    return _messageInputViewMorePanelTextColor;
}


@end
