//
//  UITextView+PlaceHolder.h
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UITextView (JKPlaceHolder) <UITextViewDelegate>
@property (nonatomic, strong) UITextView *xyd_placeHolderTextView;
//@property (nonatomic, assign) id <UITextViewDelegate> textViewDelegate;
- (void)xyd_addPlaceHolder:(NSString *)placeHolder;
@end
