//
//  CustomGestureRecognizer.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "CustomGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CustomGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateBegan;
    _startPoint = [(UITouch *)[touches anyObject] locationInView:self.view];
    _lastPoint = _currentPoint;
    _currentPoint = _startPoint;
    if (_action) _action(self, CustomGestureRecognizerStateBegan);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    self.state = UIGestureRecognizerStateChanged;
    _currentPoint = currentPoint;
    if (_action) _action(self, CustomGestureRecognizerStateMoved);
    _lastPoint = _currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateEnded;
    if (_action) _action(self, CustomGestureRecognizerStateEnded);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
    if (_action) _action(self, CustomGestureRecognizerStateCancelled);
}

- (void)reset {
    self.state = UIGestureRecognizerStatePossible;
}

- (void)cancel {
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateCancelled;
        if (_action) _action(self, CustomGestureRecognizerStateCancelled);
    }
}

@end
