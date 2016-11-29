//
//  CustomGestureRecognizer.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// State of the gesture
typedef NS_ENUM(NSUInteger, CustomGestureRecognizerState) {
    CustomGestureRecognizerStateBegan, ///< gesture start
    CustomGestureRecognizerStateMoved, ///< gesture moved
    CustomGestureRecognizerStateEnded, ///< gesture end
    CustomGestureRecognizerStateCancelled, ///< gesture cancel
};

/**
 A simple UIGestureRecognizer subclass for receive touch events.
 */
@interface CustomGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGPoint startPoint; ///< start point
@property (nonatomic, readonly) CGPoint lastPoint; ///< last move point.
@property (nonatomic, readonly) CGPoint currentPoint; ///< current move point.

/// The action block invoked by every gesture event.
@property (nullable, nonatomic, copy) void (^action)(CustomGestureRecognizer *gesture, CustomGestureRecognizerState state);

/// Cancel the gesture for current touch.
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
