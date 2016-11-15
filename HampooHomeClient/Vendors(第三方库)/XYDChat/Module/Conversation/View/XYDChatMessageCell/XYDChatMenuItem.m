//
//  XYDChatMenuItem.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMenuItem.h"

// imp_implementationWithBlock changed it's type in iOS6 (XCode 4.5)
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
#define XYDChatBlockImplCast (__bridge void *)
#else
#define XYDChatBlockImplCast
#endif

NSString *kMenuItemTrailer = @"xyd_performMenuItem";

// Add method + swizzle.
void XYDChatReplaceMethod(Class c, SEL origSEL, SEL newSEL, IMP impl);
void XYDChatReplaceMethod(Class c, SEL origSEL, SEL newSEL, IMP impl) {
    Method origMethod = class_getInstanceMethod(c, origSEL);
    class_addMethod(c, newSEL, impl, method_getTypeEncoding(origMethod));
    Method newMethod = class_getInstanceMethod(c, newSEL);
    if(class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

// Checks for our custom selector.
BOOL XYDChatIsMenuItemSelector(SEL selector);
BOOL XYDChatPIsMenuItemSelector(SEL selector) {
    return [NSStringFromSelector(selector) hasPrefix:kMenuItemTrailer];
}

@interface XYDChatMenuItem ()
@property(nonatomic, assign) SEL customSelector;
@end

@implementation XYDChatMenuItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

/*
 This might look scary, but it's actually not that bad.
 We hook into the three methods of UIResponder and NSObject to capture calls to our custom created selector.
 Then we find the UIMenuController and search for the corresponding XYDChatMenuItem.
 If the kMenuItemTrailer is not detected, we call the original implementation.
 
 This all wouldn't be necessary if UIMenuController would call our selectors with the UIMenuItem as sender.
 */
+ (void)installMenuHandlerForObject:(id)object {
    @autoreleasepool {
        @synchronized(self) {
            // object can be both a class or an instance of a class.
            Class objectClass = class_isMetaClass(object_getClass(object)) ? object : [object class];
            
            // check if menu handler has been already installed.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            SEL canPerformActionSEL = @selector(XYDChat_canPerformAction:withSender:);
#pragma clang diagnostic pop
            if (!class_getInstanceMethod(objectClass, canPerformActionSEL)) {
                
                // add canBecomeFirstResponder if it is not returning YES. (or if we don't know)
                if (object == objectClass || ![object canBecomeFirstResponder]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                    SEL canBecomeFRSEL = @selector(XYDChat_canBecomeFirstResponder);
#pragma clang diagnostic pop
                    IMP canBecomeFRIMP = imp_implementationWithBlock(XYDChatBlockImplCast(^(id _self) {
                        return YES;
                    }));
                    XYDChatReplaceMethod(objectClass, @selector(canBecomeFirstResponder), canBecomeFRSEL, canBecomeFRIMP);
                }
                
                // swizzle canPerformAction:withSender: for our custom selectors.
                // Queried before the UIMenuController is shown.
                IMP canPerformActionIMP = imp_implementationWithBlock(XYDChatBlockImplCast(^(id _self, SEL action, id sender) {
                    return XYDChatPIsMenuItemSelector(action) ? YES : ((BOOL (*)(id, SEL, SEL, id))objc_msgSend)(_self, canPerformActionSEL, action, sender);
                }));
                XYDChatReplaceMethod(objectClass, @selector(canPerformAction:withSender:), canPerformActionSEL, canPerformActionIMP);
                
                // swizzle methodSignatureForSelector:.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                SEL methodSignatureSEL = @selector(XYDChat_methodSignatureForSelector:);
#pragma clang diagnostic pop
                IMP methodSignatureIMP = imp_implementationWithBlock(XYDChatBlockImplCast(^(id _self, SEL selector) {
                    if (XYDChatPIsMenuItemSelector(selector)) {
                        return [NSMethodSignature signatureWithObjCTypes:"v@:@"]; // fake it.
                    } else {
                        return ((NSMethodSignature * (*)(id, SEL, SEL))objc_msgSend)(_self, methodSignatureSEL, selector);
                    }
                }));
                XYDChatReplaceMethod(objectClass, @selector(methodSignatureForSelector:), methodSignatureSEL, methodSignatureIMP);
                
                // swizzle forwardInvocation:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                SEL forwardInvocationSEL = @selector(XYDChat_forwardInvocation:);
#pragma clang diagnostic pop
                IMP forwardInvocationIMP = imp_implementationWithBlock(XYDChatBlockImplCast(^(id _self, NSInvocation *invocation) {
                    if (XYDChatPIsMenuItemSelector([invocation selector])) {
                        for (XYDChatMenuItem *menuItem in [UIMenuController sharedMenuController].menuItems) {
                            if ([menuItem isKindOfClass:[XYDChatMenuItem class]] && sel_isEqual([invocation selector], menuItem.customSelector)) {
                                [menuItem performBlock]; break; // find corresponding MenuItem and forward
                            }
                        }
                    } else {
                        ((void (*)(id, SEL, NSInvocation *))objc_msgSend)(_self, forwardInvocationSEL, invocation);
                    }
                }));
                XYDChatReplaceMethod(objectClass, @selector(forwardInvocation:), forwardInvocationSEL, forwardInvocationIMP);
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithTitle:(NSString *)title block:(void(^)())block {
    // Create a unique, still debuggable selector unique per XYDChatMenuItem.
    NSString *strippedTitle = [[[title componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""] lowercaseString];
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"%@_%@_%@:", kMenuItemTrailer, strippedTitle, uuidString]);
    
    if((self = [super initWithTitle:title action:customSelector])) {
        self.customSelector = customSelector;
        _enabled = YES;
        _block = [block copy];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

// Nils out action selector if we get disabled; auto-hides it from the UIMenuController.
- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.action = enabled ? self.customSelector : NULL;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// Trampuline executor.
- (void)performBlock {
    if (_block) _block();
}


@end
