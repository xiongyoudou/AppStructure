//
//  CALayer+XYDExtension.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (XYDExtension)

/**
 Take snapshot without transform, image's size equals to bounds.
 */
- (nullable UIImage *)xyd_snapshotImage;

/**
 Take snapshot without transform, PDF's page size equals to bounds.
 */
- (nullable NSData *)xyd_snapshotPDF;

/**
 Shortcut to set the layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)xyd_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Remove all sublayers.
 */
- (void)xyd_removeAllSublayers;

@property (nonatomic) CGFloat xyd_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat xyd_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat xyd_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat xyd_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat xyd_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat xyd_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGPoint xyd_center;      ///< Shortcut for center.
@property (nonatomic) CGFloat xyd_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat xyd_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint xyd_origin;      ///< Shortcut for frame.origin.
@property (nonatomic, getter=xyd_frameSize, setter=setXyd_frameSize:) CGSize xyd_size; ///< Shortcut for frame.size.


@property (nonatomic) CGFloat xyd_transformRotation;     ///< key path "tranform.rotation"
@property (nonatomic) CGFloat xyd_transformRotationX;    ///< key path "tranform.rotation.x"
@property (nonatomic) CGFloat xyd_transformRotationY;    ///< key path "tranform.rotation.y"
@property (nonatomic) CGFloat xyd_transformRotationZ;    ///< key path "tranform.rotation.z"
@property (nonatomic) CGFloat xyd_transformScale;        ///< key path "tranform.scale"
@property (nonatomic) CGFloat xyd_transformScaleX;       ///< key path "tranform.scale.x"
@property (nonatomic) CGFloat xyd_transformScaleY;       ///< key path "tranform.scale.y"
@property (nonatomic) CGFloat xyd_transformScaleZ;       ///< key path "tranform.scale.z"
@property (nonatomic) CGFloat xyd_transformTranslationX; ///< key path "tranform.translation.x"
@property (nonatomic) CGFloat xyd_transformTranslationY; ///< key path "tranform.translation.y"
@property (nonatomic) CGFloat xyd_transformTranslationZ; ///< key path "tranform.translation.z"

/**
 Shortcut for transform.m34, -1/1000 is a good value.
 It should be set before other transform shortcut.
 */
@property (nonatomic) CGFloat xyd_transformDepth;

/**
 Wrapper for `contentsGravity` property.
 */
@property (nonatomic) UIViewContentMode xyd_contentMode;

/**
 Add a fade animation to layer's contents when the contents is changed.
 
 @param duration Animation duration
 @param curve    Animation curve.
 */
- (void)xyd_addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

/**
 Cancel fade animation which is added with "-addFadeAnimationWithDuration:curve:".
 */
- (void)xyd_removePreviousFadeAnimation;

@end

NS_ASSUME_NONNULL_END
