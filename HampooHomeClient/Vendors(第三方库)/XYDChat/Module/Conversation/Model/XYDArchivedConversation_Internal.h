//
//  XYDArchivedConversation_Internal.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDArchivedConversation.h"

@interface XYDArchivedConversation ()

@property (nonatomic, copy)   NSString     *conversationId;
@property (nonatomic, copy)   NSString     *clientId;
@property (nonatomic, copy)   NSString     *creator;
@property (nonatomic, strong) NSDate       *createAt;
@property (nonatomic, strong) NSDate       *updateAt;
@property (nonatomic, strong) NSDate       *lastMessageAt;
@property (nonatomic, copy)   NSString     *name;
@property (nonatomic, strong) NSArray      *members;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, assign) BOOL          transient;
@property (nonatomic, assign) BOOL          muted;

@end
