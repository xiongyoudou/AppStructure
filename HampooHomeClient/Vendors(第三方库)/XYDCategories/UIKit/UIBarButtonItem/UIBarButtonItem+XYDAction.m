//
//  UIBarButtonItem+XYDAction.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 15/5/22.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

char * const UIBarButtonItemJKActionBlock = "UIBarButtonItemJKActionBlock";
#import "UIBarButtonItem+XYDAction.h"
#import <objc/runtime.h>

@implementation UIBarButtonItem (JKAction)

- (void)xyd_performActionBlock {
    
    dispatch_block_t block = self.xyd_actionBlock;
    
    if (block)
        block();
    
}

- (BarButtonJKActionBlock)xyd_actionBlock {
    return objc_getAssociatedObject(self, UIBarButtonItemJKActionBlock);
}

- (void)setxyd_actionBlock:(BarButtonJKActionBlock)actionBlock
 {
    
    if (actionBlock != self.xyd_actionBlock) {
        [self willChangeValueForKey:@"xyd_actionBlock"];
        
        objc_setAssociatedObject(self,
                                 UIBarButtonItemJKActionBlock,
                                 actionBlock,
                                 OBJC_ASSOCIATION_COPY);
        
        // Sets up the action.
        [self setTarget:self];
        [self setAction:@selector(xyd_performActionBlock)];
        
        [self didChangeValueForKey:@"xyd_actionBlock"];
    }
}
@end
