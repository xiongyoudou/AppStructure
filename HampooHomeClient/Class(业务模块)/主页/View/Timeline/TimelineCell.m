//
//  TimelineCell.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "TimelineCell.h"
#import "TimelineHelper.h"
#import "UIView+XYDFrame.h"
#import "CALayer+XYDExtension.h"
#import "XYDCGUtilities.h"
#import "UIImage+XYDColor.h"
#import "UIControl+XYDBlock.h"
#import "UIImage+XYDResize.h"
#import "CustomControl.h"
#import "TimelineModel.h"
#import "YYWebImage.h"

@implementation TLTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kTLCellTitleHeight;
    }
    self = [super initWithFrame:frame];
    _titleLabel = [YYLabel new];
    _titleLabel.xyd_size = CGSizeMake(kScreenWidth - 100, self.xyd_height);
    _titleLabel.xyd_left = kTLCellLeftPadding;
    _titleLabel.displaysAsynchronously = YES;
    _titleLabel.ignoreCommonProperties = YES;
    _titleLabel.fadeOnHighlight = NO;
    _titleLabel.fadeOnAsynchronouslyDisplay = NO;
    [self addSubview:_titleLabel];
    
    // 标题栏部分下面的横线
    CALayer *line = [CALayer layer];
    line.xyd_size = CGSizeMake(self.xyd_width, CGFloatFromPixel(1));
    line.xyd_bottom = self.xyd_height;
    line.backgroundColor = kTLCellLineColor.CGColor;
    [self.layer addSublayer:line];
    self.exclusiveTouch = YES;
    return self;
}
@end


@implementation TLProfileView {
    BOOL _trackingTouch;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kTLCellProfileHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    WEAKSELF
    _avatarView = [UIImageView new];
    _avatarView.xyd_size = CGSizeMake(40, 40);
    _avatarView.xyd_origin = CGPointMake(kTLCellLeftPadding, kTLCellOtherPadding + 3);
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_avatarView];
    
    CALayer *avatarBorder = [CALayer layer];
    avatarBorder.frame = _avatarView.bounds;
    avatarBorder.borderWidth = CGFloatFromPixel(1);
//    avatarBorder.borderColor = [UIColor colorWithWhite:0.000 alpha:0.090].CGColor;
    avatarBorder.content = [UIColor redColor].CGColor;
    avatarBorder.cornerRadius = _avatarView.xyd_height / 2;
    avatarBorder.shouldRasterize = YES;
    avatarBorder.rasterizationScale = kScreenScale;
    [_avatarView.layer addSublayer:avatarBorder];
    
    _nameLabel = [YYLabel new];
    _nameLabel.xyd_size = CGSizeMake(kTLCellNameWidth, 24);
    _nameLabel.xyd_left = _avatarView.xyd_right + kTLCellNamePaddingLeft;
    _nameLabel.xyd_centerY = 27;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self addSubview:_nameLabel];
    
    _sourceLabel = [YYLabel new];
    _sourceLabel.frame = _nameLabel.frame;
    _sourceLabel.xyd_centerY = 47;
    _sourceLabel.displaysAsynchronously = YES;
    _sourceLabel.ignoreCommonProperties = YES;
    _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
    _sourceLabel.fadeOnHighlight = NO;
    _sourceLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weakSelf.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weakSelf.cell.delegate cell:weakSelf.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [self addSubview:_sourceLabel];
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _trackingTouch = NO;
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView:_avatarView];
    if (CGRectContainsPoint(_avatarView.bounds, p)) {
        _trackingTouch = YES;
    }
    p = [t locationInView:_nameLabel];
    if (CGRectContainsPoint(_nameLabel.bounds, p) && _nameLabel.textLayout.textBoundingRect.size.width > p.x) {
        _trackingTouch = YES;
    }
    if (!_trackingTouch) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesEnded:touches withEvent:event];
    } else {
        if ([_cell.delegate respondsToSelector:@selector(cell:didClickUser:)]) {
            [_cell.delegate cell:_cell didClickUser:_cell.statusView.layout.model.user];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end

@implementation TLView {
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    WEAKSELF
    
    _contentView = [UIView new];
    _contentView.xyd_width = kScreenWidth;
    _contentView.xyd_height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_contentView];
    
    _titleView = [TLTitleView new];
    _titleView.hidden = YES;
    [_contentView addSubview:_titleView];
    
    _profileView = [TLProfileView new];
    [_contentView addSubview:_profileView];
    
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.xyd_size = CGSizeMake(30, 30);
    [_menuButton setImage:[TLHelper imageNamed:@"timeline_icon_more"] forState:UIControlStateNormal];
    [_menuButton setImage:[TLHelper imageNamed:@"timeline_icon_more_highlighted"] forState:UIControlStateHighlighted];
    _menuButton.xyd_centerX = self.xyd_width - 20;
    _menuButton.xyd_centerY = 18;
    [_menuButton xyd_touchUpInside:^{
        if ([weakSelf.cell.delegate respondsToSelector:@selector(cellDidClickMenu:)]) {
            [weakSelf.cell.delegate cellDidClickMenu:weakSelf.cell];
        }
    }];
    [_contentView addSubview:_menuButton];
    
    _textLabel = [YYLabel new];
    _textLabel.xyd_left = kTLCellLeftPadding;
    _textLabel.xyd_width = kTLCellContentWidth;
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weakSelf.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weakSelf.cell.delegate cell:weakSelf.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_textLabel];
    
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        CustomControl *imageView = [CustomControl new];
        imageView.xyd_size = CGSizeMake(100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = kTLCellHighlightColor;
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(CustomControl *view, CustomGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (![weakSelf.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)]) return;
            if (state == CustomGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [weakSelf.cell.delegate cell:weakSelf.cell didClickImageAtIndex:i];
                }
            }
        };
        
        UIView *badge = [UIImageView new];
        badge.userInteractionEnabled = NO;
        badge.contentMode = UIViewContentModeScaleAspectFit;
        badge.xyd_size = CGSizeMake(56 / 2, 36 / 2);
        badge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        badge.xyd_right = imageView.xyd_width;
        badge.xyd_bottom = imageView.xyd_height;
        badge.hidden = YES;
        [imageView addSubview:badge];
        
        [picViews addObject:imageView];
        [_contentView addSubview:imageView];
    }
    _picViews = picViews;
    
    return self;
}


- (void)setLayout:(TLLayout *)layout {
    _layout = layout;
    
    self.xyd_height = layout.height;
    _contentView.xyd_top = layout.marginTop;
    _contentView.xyd_height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    if (layout.titleHeight > 0) {
        _titleView.hidden = NO;
        _titleView.xyd_height = layout.titleHeight;
        _titleView.titleLabel.textLayout = layout.titleTextLayout;
        top = layout.titleHeight;
    } else {
        _titleView.hidden = YES;
    }
    
    /// 圆角头像
    [_profileView.avatarView yy_setImageWithURL:layout.model.user.avatarLarge //profileImageURL
                                 placeholder:nil
                                     options:kNilOptions
                                     manager:[TLHelper avatarImageManager]
                                    progress:nil
                                   transform:nil
                                  completion:nil];
    
    _profileView.nameLabel.textLayout = layout.nameTextLayout;
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
    _profileView.xyd_height = layout.profileHeight;
    _profileView.xyd_top = top;
    top += layout.profileHeight;
    
    _textLabel.xyd_top = top;
    _textLabel.xyd_height = layout.textHeight;
    _textLabel.textLayout = layout.textLayout;
    top += layout.textHeight;
    
    if (layout.picHeight == 0) {
        [self _hideImageViews];
    }
    
    if (layout.picHeight > 0) {
        [self _setImageViewWithTop:top];
    }
}

- (void)_hideImageViews {
    for (UIImageView *imageView in _picViews) {
        imageView.hidden = YES;
    }
}

- (void)_setImageViewWithTop:(CGFloat)imageTop {
    CGSize picSize = _layout.picSize;
    NSArray *pics = _layout.model.pics;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIView *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView.layer yy_cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kTLCellLeftPadding;
                    origin.y = imageTop;
                } break;
                case 4: {
                    origin.x = kTLCellLeftPadding + (i % 2) * (picSize.width + kTLCellPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kTLCellPaddingPic);
                } break;
                default: {
                    origin.x = kTLCellLeftPadding + (i % 3) * (picSize.width + kTLCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kTLCellPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            TLPicture *pic = pics[i];
            
            UIView *badge = imageView.subviews.firstObject;
            switch (pic.largest.badgeType) {
                case TLPictureBadgeTypeNone: {
                    if (badge.layer.contents) {
                        badge.layer.contents = nil;
                        badge.hidden = YES;
                    }
                } break;
                case TLPictureBadgeTypeLong: {
                    badge.layer.contents = (__bridge id)([TLHelper imageNamed:@"timeline_image_longimage"].CGImage);
                    badge.hidden = NO;
                } break;
                case TLPictureBadgeTypeGIF: {
                    badge.layer.contents = (__bridge id)([TLHelper imageNamed:@"timeline_image_gif"].CGImage);
                    badge.hidden = NO;
                } break;
            }
            
            @weakify(imageView);
            [imageView.layer yy_setImageWithURL:pic.bmiddle.url
                                 placeholder:nil
                                     options:YYWebImageOptionAvoidSetImage
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                      @strongify(imageView);
                                      if (!imageView) return;
                                      if (image && stage == YYWebImageStageFinished) {
                                          int width = pic.bmiddle.width;
                                          int height = pic.bmiddle.height;
                                          CGFloat scale = (height / width) / (imageView.xyd_height / imageView.xyd_width);
                                          if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                              imageView.contentMode = UIViewContentModeScaleAspectFill;
                                              imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                          } else { // 高图只保留顶部
                                              imageView.contentMode = UIViewContentModeScaleToFill;
                                              imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                                          }
                                          ((CustomControl *)imageView).image = image;
                                          if (from != YYWebImageFromMemoryCacheFast) {
                                              CATransition *transition = [CATransition animation];
                                              transition.duration = 0.15;
                                              transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                              transition.type = kCATransitionFade;
                                              [imageView.layer addAnimation:transition forKey:@"contents"];
                                          }
                                      }
                                  }];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
     [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:kTLCellHighlightColor afterDelay:0.15];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    
    if ([_cell.delegate respondsToSelector:@selector(cellDidClick:)]) {
        [_cell.delegate cellDidClick:_cell];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:_contentView selector:@selector(setBackgroundColor:) object:kTLCellHighlightColor];
    
    _contentView.backgroundColor = [UIColor whiteColor];
}

@end


@implementation TLCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delaysContentTouches = NO; // Remove touch delay for iOS 7
            break;
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    _statusView = [TLView new];
    _statusView.cell = self;
    _statusView.titleView.cell = self;
    _statusView.profileView.cell = self;
    [self.contentView addSubview:_statusView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@3);
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(extraTimelineMargin);
    }];
    
    UIView *circle = [[UIView alloc]initWithFrame:CGRectZero];
    circle.layer.cornerRadius = extraTimelineMargin/2.0;
    circle.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:circle];
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@extraTimelineMargin);
        make.top.equalTo(@extraTimelineTopMargin);
        make.left.mas_equalTo(self.mas_left).offset(11);
    }];
    
    return self;
}

- (void)prepareForReuse {
    // ignore
}

- (void)setLayout:(TLLayout *)layout {
    self.xyd_height = layout.height;
    self.contentView.xyd_height = layout.height;
    _statusView.layout = layout;
}


@end
