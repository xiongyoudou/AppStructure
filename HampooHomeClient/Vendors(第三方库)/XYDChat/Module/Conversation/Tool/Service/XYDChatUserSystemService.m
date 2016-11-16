//
//  XYDChatUserSystemService.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/16.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatUserSystemService.h"
#import "XYDChatSessionService.h"

NSString *const XYDChatUserSystemServiceErrorDomain = @"XYDChatUserSystemServiceErrorDomain";

@interface XYDChatUserSystemService ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<XYDChatUserDelegate>> *cachedUsers;
@property (nonatomic, strong) dispatch_queue_t isolationQueue;

@end

@implementation XYDChatUserSystemService
@synthesize fetchProfilesBlock = _fetchProfilesBlock;

- (void)setFetchProfilesBlock:(XYDChatFetchProfilesBlock)fetchProfilesBlock {
    _fetchProfilesBlock = fetchProfilesBlock;
}

- (NSArray<id<XYDChatUserDelegate>> *)getProfilesForUserIds:(NSArray<NSString *> *)userIds error:(NSError * __autoreleasing *)theError {
    __block NSArray<id<XYDChatUserDelegate>> *blockUsers = [NSArray array];
    if (!_fetchProfilesBlock) {
        // This enforces implementing `-setFetchProfilesBlock:`.
        NSString *reason = [NSString stringWithFormat:@"You must implement `-setFetchProfilesBlock:` to allow ChatKit to get user information by user clientId."];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
        return nil;
    }
    XYDChatFetchProfilesCompletionHandler completionHandler = ^(NSArray<id<XYDChatUserDelegate>> *users, NSError *error) {
        blockUsers = users;
        [self cacheUsers:users];
    };
    _fetchProfilesBlock(userIds, completionHandler);
    return blockUsers;
}

- (void)getProfilesInBackgroundForUserIds:(NSArray<NSString *> *)userIds callback:(XYDChatUserResultsCallBack)callback {
    if (!userIds || userIds.count == 0) {
        dispatch_async(dispatch_get_main_queue(),^{
            NSInteger code = 0;
            NSString *errorReasonText = @"members is 0";
            NSDictionary *errorInfo = @{
                                        @"code":@(code),
                                        NSLocalizedDescriptionKey : errorReasonText,
                                        };
            NSError *error = [NSError errorWithDomain:XYDChatUserSystemServiceErrorDomain
                                                 code:code
                                             userInfo:errorInfo];
            !callback ?: callback(nil, error);
        });
        return;
    }
    NSError *error = nil;
    NSArray *cachedProfiles = [self getCachedProfilesIfExists:userIds error:&error];
    if (cachedProfiles.count == userIds.count) {
        dispatch_async(dispatch_get_main_queue(),^{
            !callback ?: callback(cachedProfiles, nil);
        });
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        if (!_fetchProfilesBlock) {
            // This enforces implementing `-setFetchProfilesBlock:`.
            NSString *reason = [NSString stringWithFormat:@"You must implement `-setFetchProfilesBlock:` to allow ChatKit to get user information by user clientId."];
            @throw [NSException exceptionWithName:NSGenericException
                                           reason:reason
                                         userInfo:nil];
            return;
        }
        _fetchProfilesBlock(userIds, ^(NSArray<id<XYDChatUserDelegate>> *users, NSError *error) {
            if (!error && users && (users.count > 0)) {
                [self cacheUsers:users];
                dispatch_async(dispatch_get_main_queue(),^{
                    !callback ?: callback(users, nil);
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(),^{
                !callback ?: callback(nil, error);
            });
        });
    });
}

- (id<XYDChatUserDelegate>)getProfileForUserId:(NSString *)userId error:(NSError * __autoreleasing *)theError {
    if (!userId) {
        NSInteger code = 0;
        NSString *errorReasonText = @"UserId is nil";
        NSDictionary *errorInfo = @{
                                    @"code" : @(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:XYDChatUserSystemServiceErrorDomain
                                             code:code
                                         userInfo:errorInfo];
        
        if (theError == nil) {
            *theError = error;
        }
        return nil;
    }
    
    id<XYDChatUserDelegate> user = [self getCachedProfileIfExists:userId error:nil];
    if (user) {
        return user;
    }
    NSArray *users = [self getProfilesForUserIds:@[userId] error:theError];
    if (users.count > 0) {
        return users[0];
    }
    return nil;
}

- (void)getProfileInBackgroundForUserId:(NSString *)userId callback:(XYDChatUserResultCallBack)callback {
    if (!userId) {
        NSInteger code = 0;
        NSString *errorReasonText = @"UserId is nil";
        NSDictionary *errorInfo = @{
                                    @"code" : @(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:XYDChatUserSystemServiceErrorDomain
                                             code:code
                                         userInfo:errorInfo];
        !callback ?: callback(nil, error);
        return;
    }
    [self getProfilesInBackgroundForUserIds:@[userId] callback:^(NSArray<id<XYDChatUserDelegate>> *users, NSError *error) {
        if (!error && users && (users.count > 0)) {
            !callback ?: callback(users[0], nil);
            return;
        }
        !callback ?: callback(nil, error);
    }];
}

- (NSArray<id<XYDChatUserDelegate>> *)getCachedProfilesIfExists:(NSArray<NSString *> *)userIds shouldSameCount:(BOOL)shouldSameCount error:(NSError * __autoreleasing *)theError {
    NSArray *cachedProfiles = [self getCachedProfilesIfExists:userIds error:theError];
    if (!shouldSameCount) {
        return cachedProfiles;
    }
    if (cachedProfiles.count == userIds.count) {
        return cachedProfiles;
    }
    return nil;
}

- (NSArray<id<XYDChatUserDelegate>> *)getCachedProfilesIfExists:(NSArray<NSString *> *)userIds error:(NSError * __autoreleasing *)theError {
    if (!userIds || userIds.count == 0) {
        NSInteger code = 0;
        NSString *errorReasonText = @"UserIds is nil";
        NSDictionary *errorInfo = @{
                                    @"code" : @(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:XYDChatUserSystemServiceErrorDomain
                                             code:code
                                         userInfo:errorInfo];
        if (theError) {
            *theError = error;
        }
        return nil;
    }
    NSMutableArray *cachedProfiles = [NSMutableArray arrayWithCapacity:self.cachedUsers.count * 0.5];
    NSArray *allCachedUserIds = [self.cachedUsers allKeys];
    [userIds enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([allCachedUserIds containsObject:obj]) {
            [cachedProfiles addObject:[self getUserForClientId:obj]];
        }
    }];
    return [cachedProfiles copy];
}

- (void)getCachedProfileIfExists:(NSString *)userId name:(NSString **)name avatarURL:(NSURL **)avatarURL error:(NSError * __autoreleasing *)theError {
    if (userId) {
        NSString *userName_ = nil;
        NSURL *avatarURL_ = nil;
        id<XYDChatUserDelegate> user = [self getUserForClientId:userId];
        userName_ = user.name;
        avatarURL_ = user.avatarURL;
        if (userName_ || avatarURL_) {
            if (*name == nil) {
                *name = userName_;
            }
            if (*avatarURL == nil) {
                *avatarURL = avatarURL_;
            }
            return;
        }
        
    }
    NSInteger code = 0;
    NSString *errorReasonText = @"No cached profile";
    NSDictionary *errorInfo = @{
                                @"code" : @(code),
                                NSLocalizedDescriptionKey : errorReasonText,
                                };
    NSError *error = [NSError errorWithDomain:XYDChatUserSystemServiceErrorDomain
                                         code:code
                                     userInfo:errorInfo];
    if (theError) {
        *theError = error;
    }
}

- (void)removeCachedProfileForPeerId:(NSString *)peerId {
    NSString *clientId_ = [peerId copy];
    if (!clientId_) {
        return;
    }
    dispatch_async(self.isolationQueue, ^(){
        [self.cachedUsers removeObjectForKey:peerId];
    });
}

- (void)removeAllCachedProfiles {
    dispatch_async(self.isolationQueue, ^(){
        self.cachedUsers = nil;
    });
}

- (id<XYDChatUserDelegate>)fetchCurrentUser {
    NSError *error = nil;
    id<XYDChatUserDelegate> user = [[XYDChatUserSystemService sharedInstance] getCachedProfileIfExists:[XYDChatSessionService sharedInstance].clientId error:&error];
    if (!error) {
        return user;
    }
    error = nil;
    id<XYDChatUserDelegate> currentUser = [[XYDChatUserSystemService sharedInstance] getProfileForUserId:[XYDChatSessionService sharedInstance].clientId error:&error];
    if (!error) {
        return currentUser;
    }
    //    NSLog(@"%@", error);
    return nil;
}

- (void)fetchCurrentUserInBackground:(XYDChatUserResultCallBack)callback {
    NSError *error = nil;
    id<XYDChatUserDelegate> user = [[XYDChatUserSystemService sharedInstance] getCachedProfileIfExists:[XYDChatSessionService sharedInstance].clientId error:&error];
    if (!error) {
        !callback ?: callback(user, nil);
        return;
    }
    
    [[XYDChatUserSystemService sharedInstance] getProfileInBackgroundForUserId:[XYDChatSessionService sharedInstance].clientId callback:^(id<XYDChatUserDelegate> user, NSError *error) {
        if (!error) {
            !callback ?: callback(user, nil);
            return;
        }
        !callback ?: callback(nil, error);
    }];
}

- (id<XYDChatUserDelegate>)getCachedProfileIfExists:(NSString *)userId error:(NSError * __autoreleasing *)theError {
    id<XYDChatUserDelegate> user;
    if (userId) {
        user = [self getUserForClientId:userId];
    }
    if (user) {
        return user;
    }
    NSInteger code = 0;
    NSString *errorReasonText = @"No cached profile";
    NSDictionary *errorInfo = @{
                                @"code" : @(code),
                                NSLocalizedDescriptionKey : errorReasonText,
                                };
    NSError *error = [NSError errorWithDomain:XYDChatUserSystemServiceErrorDomain
                                         code:code
                                     userInfo:errorInfo];
    if (theError) {
        *theError = error;
    }
    return nil;
}

- (void)cacheUsersWithIds:(NSSet<id<XYDChatUserDelegate>> *)userIds callback:(XYDChatBooleanResultBlock)callback {
    NSMutableSet *uncachedUserIds = [[NSMutableSet alloc] init];
    for (NSString *userId in userIds) {
        if ([self getCachedProfileIfExists:userId error:nil] == nil) {
            [uncachedUserIds addObject:userId];
        }
    }
    if ([uncachedUserIds count] > 0) {
        [self getProfilesInBackgroundForUserIds:[[NSMutableArray alloc] initWithArray:[uncachedUserIds allObjects]] callback:^(NSArray<id<XYDChatUserDelegate>> *users, NSError *error) {
            if (users) {
                [self cacheUsers:users];
            }
            !callback ?: callback(YES, error);
        }];
    } else {
        !callback ?: callback(YES, nil);
    }
}

//TODO:改为异步操作，启用本地缓存。只在关键操作时更新本地缓存，比如：签名机制对应的几个操作：加人、踢人等。
- (void)cacheUsers:(NSArray<id<XYDChatUserDelegate>> *)users {
    if (users.count > 0) {
        for (id<XYDChatUserDelegate> user in users) {
            [self setUser:user forClientId:user.clientId];
        }
    }
}

#pragma mark -
#pragma mark - LazyLoad Method

/**
 *  lazy load cachedUsers
 *
 *  @return NSMutableDictionary
 */
- (NSMutableDictionary *)cachedUsers {
    if (_cachedUsers == nil) {
        _cachedUsers = [[NSMutableDictionary alloc] init];
    }
    return _cachedUsers;
}

- (dispatch_queue_t)isolationQueue {
    if (_isolationQueue) {
        return _isolationQueue;
    }
    NSString *queueBaseLabel = [NSString stringWithFormat:@"com.ChatKit.%@", NSStringFromClass([self class])];
    const char *queueName = [[NSString stringWithFormat:@"%@.ForIsolation",queueBaseLabel] UTF8String];
    _isolationQueue = dispatch_queue_create(queueName, NULL);
    return _isolationQueue;
}

#pragma mark -
#pragma mark - set or get cached user Method

- (void)setUser:(id<XYDChatUserDelegate>)user forClientId:(NSString *)clientId {
    NSString *clientId_ = [clientId copy];
    if (!clientId_) {
        return;
    }
    dispatch_async(self.isolationQueue, ^(){
        if (!user) {
            [self.cachedUsers removeObjectForKey:clientId_];
        } else {
            [self.cachedUsers setObject:user forKey:clientId_];
        }
    });
}

- (id<XYDChatUserDelegate>)getUserForClientId:(NSString *)clientId {
    if (!clientId) {
        return nil;
    }
    __block id<XYDChatUserDelegate> user = nil;
    dispatch_sync(self.isolationQueue, ^(){
        user = self.cachedUsers[clientId];
    });
    return user;
}

@end
