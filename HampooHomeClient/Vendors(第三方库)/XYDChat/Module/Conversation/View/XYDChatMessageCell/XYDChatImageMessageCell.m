//
//  XYDChatImageMessageCell.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatImageMessageCell.h"
#import "XYDChatConstant.h"
#import "XYDChatSettingService.h"
#import "XYDChatHelper.h"
#import "XYDChatImageMessage.h"

@interface XYDChatImageMessageCell ()

/**
 *  用来显示image的UIImageView
 */
@property (nonatomic, strong) UIImageView *messageImageView;

/**
 *  用来显示上传进度的UIView
 */
@property (nonatomic, strong) UIView *messageProgressView;

/**
 *  显示上传进度百分比的UILabel
 */
@property (nonatomic, weak) UILabel *messageProgressLabel;

@end

@implementation XYDChatImageMessageCell

#pragma mark - Override Methods

#pragma mark - Public Methods

- (void)setup {
    [self.messageContentView addSubview:self.messageImageView];
    [self.messageContentView addSubview:self.messageProgressView];
    UIEdgeInsets edgeMessageBubbleCustomize;
    if (self.messageOwner == XYDChatMessageOwnerTypeSelf) {
        UIEdgeInsets rightEdgeMessageBubbleCustomize = [XYDChatSettingService sharedInstance].rightHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = rightEdgeMessageBubbleCustomize;
    } else {
        UIEdgeInsets leftEdgeMessageBubbleCustomize = [XYDChatSettingService sharedInstance].leftHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = leftEdgeMessageBubbleCustomize;
    }
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).with.insets(edgeMessageBubbleCustomize);
        make.height.lessThanOrEqualTo(@200).priorityHigh();
    }];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMessageImageViewGestureRecognizerHandler:)];
    [self.messageContentView addGestureRecognizer:recognizer];
    [super setup];
    [self addGeneralView];
}

- (void)singleTapMessageImageViewGestureRecognizerHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(messageCellTappedMessage:)]) {
            [self.delegate messageCellTappedMessage:self];
        }
    }
}

- (void)configureCellWithData:(XYDChatImageMessage *)message {
    [super configureCellWithData:message];
    UIImage *thumbnailPhoto = message.thumbnailPhoto;
    do {
        if (self.messageImageView.image && (self.messageImageView.image == thumbnailPhoto)) {
            break;
        }
        if (thumbnailPhoto) {
            self.messageImageView.image = thumbnailPhoto;
            break;
        }
        NSString *imageLocalPath = message.localThumbnailPath;
        BOOL isLocalPath = ![imageLocalPath hasPrefix:@"http"];
        //note: this will ignore contentMode.
        if (imageLocalPath && isLocalPath) {
            NSData *imageData = [NSData dataWithContentsOfFile:imageLocalPath];
            UIImage *image = [UIImage imageWithData:imageData];
            UIImage *resizedImage = [image xyd_imageByScalingAspectFillWithLimitSize:CGSizeMake(200, 200)];
            self.messageImageView.image = resizedImage;
            message.photo = image;
            message.thumbnailPhoto = resizedImage;
            break;
        }
        
        // requied!
        if (message.originPhotoURLStr) {
            [self.messageImageView  sd_setImageWithURL:[NSURL URLWithString:message.originPhotoURLStr] placeholderImage:[self imageInBundleForImageName:@"Placeholder_Image"]
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 dispatch_async(dispatch_get_main_queue(),^{
                                                     if (image){
                                                         message.photo = image;
                                                         message.thumbnailPhoto = [image xyd_imageByScalingAspectFillWithLimitSize:CGSizeMake(200, 200)];
                                                         if ([self.delegate respondsToSelector:@selector(fileMessageDidDownload:)]) {
                                                             [self.delegate fileMessageDidDownload:self];
                                                         }
                                                     }
                                                 });
                                                 
                                             }
             ];
            break;
        }
        
    } while (NO);
}

- (UIImage *)imageInBundleForImageName:(NSString *)imageName {
    return ({
        UIImage *image = [XYDChatHelper getImageWithNamed:imageName bundleName:@"Placeholder" bundleForClass:[self class]];
        image;});
}

#pragma mark - Setters

- (void)setUploadProgress:(CGFloat)uploadProgress {
    [self setMessageSendState:XYDChatMessageSendStateSending];
    [self.messageProgressView setFrame:CGRectMake(0, 0, self.messageImageView.bounds.size.width, self.messageImageView.bounds.size.height * (1 - uploadProgress))];
    [self.messageProgressLabel setText:[NSString stringWithFormat:@"%.0f%%",uploadProgress * 100]];
}

- (void)setMessageSendState:(XYDChatMessageSendState)messageSendState {
    [super setMessageSendState:messageSendState];
    if (messageSendState == XYDChatMessageSendStateSending) {
        if (!self.messageProgressView.superview) {
            [self.messageContentView addSubview:self.messageProgressView];
        }
        [self.messageProgressLabel setFrame:CGRectMake(0, self.messageImageView.image.size.height/2 - 8, self.messageImageView.image.size.width, 16)];
    } else {
        [self removeProgressView];
    }
}

- (void)removeProgressView {
    [self.messageProgressView removeFromSuperview];
    [[self.messageProgressView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.messageProgressView = nil;
    self.messageProgressLabel = nil;
}

#pragma mark - Getters

- (UIImageView *)messageImageView {
    if (!_messageImageView) {
        _messageImageView = [[UIImageView alloc] init];
        //FIXME:这一行可以不需要
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _messageImageView;
    
}

- (UIView *)messageProgressView {
    if (!_messageProgressView) {
        _messageProgressView = [[UIView alloc] init];
        _messageProgressView.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.3f];
        _messageProgressView.translatesAutoresizingMaskIntoConstraints = NO;
        _messageProgressView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UILabel *progressLabel = [[UILabel alloc] init];
        progressLabel.font = [UIFont systemFontOfSize:14.0f];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        [_messageProgressView addSubview:self.messageProgressLabel = progressLabel];
    }
    return _messageProgressView;
}

#pragma mark -
#pragma mark - XYDChatChatMessageCellSubclassing Method

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeImage;
}

@end
