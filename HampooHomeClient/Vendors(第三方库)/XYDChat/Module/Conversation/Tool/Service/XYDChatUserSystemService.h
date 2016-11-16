//
//  XYDChatUserSystemService.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/16.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDSingleton.h"
#import "XYDChatServiceDefinition.h"
#import "XYDChatUserDelegate.h"

FOUNDATION_EXTERN NSString *const XYDChatKUserSystemServiceErrorDomain;

@interface XYDChatUserSystemService : XYDSingleton<XYDChatUserSystemService>

- (NSArray<id<XYDChatUserDelegate>> *)getProfilesForUserIds:(NSArray<NSString *> *)userIds error:(NSError * __autoreleasing *)theError;

- (void)getProfilesInBackgroundForUserIds:(NSArray<NSString *> *)userIds callback:(XYDChatUserResultsCallBack)callback;

- (id<XYDChatUserDelegate>)getProfileForUserId:(NSString *)userId error:(NSError * __autoreleasing *)theError;

/*!
 * Firstly try memory cache, then fetch.
 */
- (id<XYDChatUserDelegate>)fetchCurrentUser;

/*!
 * Firstly try memory cache, then fetch.
 */
- (void)fetchCurrentUserInBackground:(XYDChatUserResultCallBack)callback;

- (void)cacheUsersWithIds:(NSSet<id<XYDChatUserDelegate>> *)userIds callback:(XYDChatBooleanResultBlock)callback;

- (void)cacheUsers:(NSArray<id<XYDChatUserDelegate>> *)users;


@end
