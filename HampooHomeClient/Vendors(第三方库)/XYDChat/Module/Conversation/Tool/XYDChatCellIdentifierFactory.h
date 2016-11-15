//
//  XYDChatCellIdentifierFactory.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDChatConstant.h"

@interface XYDChatCellIdentifierFactory : NSObject

/**
 *  用来获取cellIdentifier
 */

+ (NSString *)cellIdentifierForMessageConfiguration:(id)message conversationType:(XYDChatConversationType)conversationType;

@end
