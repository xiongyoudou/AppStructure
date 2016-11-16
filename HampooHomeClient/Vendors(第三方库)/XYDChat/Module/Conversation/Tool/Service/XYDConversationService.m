//
//  XYDConversationService.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversationService.h"
#import "FMDB.h"
#import "XYDChatClient.h"
#import "XYDConversation.h"
#import "XYDChatConstant.h"
#import "XYDChatSessionService.h"
#import "XYDConversationQuery.h"
#import "XYDChatMessageOption.h"
#import "XYDChatKit.h"
#import "XYDChatUserSystemService.h"
#import "XYDChatSettingService.h"

NSString *const XYDConversationServiceErrorDomain = @"XYDConversationServiceErrorDomain";

@interface XYDConversationService ()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property (nonatomic, strong) XYDChatClient *client;
@property (nonatomic, strong) NSMutableDictionary<NSString *, XYDConversation *> *conversationDictionary;
@property (nonatomic, strong) dispatch_queue_t sqliteQueue;

@end

@implementation XYDConversationService
@synthesize currentConversation = _currentConversation;
@synthesize fetchConversationHandler = _fetchConversationHandler;
@synthesize conversationInvalidedHandler = _conversationInvalidedHandler;
@synthesize loadLatestMessagesHandler = _loadLatestMessagesHandler;
@synthesize filterMessagesBlock = _filterMessagesBlock;
@synthesize sendMessageHookBlock = _sendMessageHookBlock;

/**
 *  根据 conversationId 获取对话
 *  @param conversationId   对话的 id
 */
- (void)fecthConversationWithConversationId:(NSString *)conversationId callback:(XYDChatConversationResultBlock)callback {
    NSAssert(conversationId.length > 0, @"Conversation id is nil");
    XYDConversation *conversation = [self.client conversationForId:conversationId];
    if (conversation) {
        !callback ?: callback(conversation, nil);
        return;
    }
    
    NSSet *conversationSet = [NSSet setWithObject:conversationId];
    [self fetchConversationsWithConversationIds:conversationSet callback:^(NSArray *objects, NSError *error) {
        if (error) {
            !callback ?: callback(nil, error);
        } else {
            if (objects.count == 0) {
                NSString *errorReasonText = [NSString stringWithFormat:@"conversation of %@ are not exists", conversationId];
                NSInteger code = 0;
                NSDictionary *errorInfo = @{
                                            @"code" : @(code),
                                            NSLocalizedDescriptionKey : errorReasonText,
                                            };
                NSError *error = [NSError errorWithDomain:XYDConversationServiceErrorDomain
                                                     code:code
                                                 userInfo:errorInfo];
                !callback ?: callback(nil, error);
            } else {
                !callback ?: callback(objects[0], error);
            }
        }
    }];
}

- (void)fetchConversationsWithConversationIds:(NSSet *)conversationIds
                                     callback:(XYDChatArrayResultBlock)callback {
    XYDConversationQuery *query = [[XYDChatSessionService sharedInstance].client conversationQuery];
    [query whereKey:@"objectId" containedIn:[conversationIds allObjects]];
//    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.limit = 1000;  // default limit:10
    [query findConversationsWithCallback: ^(NSArray *objects, NSError *error) {
        if (error) {
            !callback ?: callback(nil, error);
        } else {
            if (objects.count == 0) {
                NSString *errorReasonText = [NSString stringWithFormat:@"conversations in %@  are not exists", conversationIds];
                NSInteger code = 0;
                NSDictionary *errorInfo = @{
                                            @"code":@(code),
                                            NSLocalizedDescriptionKey : errorReasonText,
                                            };
                NSError *error = [NSError errorWithDomain:XYDConversationServiceErrorDomain
                                                     code:code
                                                 userInfo:errorInfo];
                !callback ?: callback(nil, error);
            } else {
                !callback ?: callback(objects, error);
            }
        }
    }];
}

- (void)fecthConversationWithPeerId:(NSString *)peerId callback:(XYDChatConversationResultBlock)callback {
    if (![XYDChatSessionService sharedInstance].connect) {
        NSInteger code = 0;
        NSString *errorReasonText = @"Session not opened";
        NSDictionary *errorInfo = @{
                                    @"code":@(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:XYDConversationServiceErrorDomain
                                             code:code
                                         userInfo:errorInfo];
        
        !callback ?: callback(nil, error);
        return;
    }
    if ([peerId isEqualToString:[[XYDChatSessionService sharedInstance] clientId]]) {
        NSString *formatString = @"\n\n\
        ------ BEGIN NSException Log ---------------\n \
        class name: %@                              \n \
        ------line: %@                              \n \
        ----reason: %@                              \n \
        ------ END -------------------------------- \n\n";
        NSString *reason = [NSString stringWithFormat:formatString,
                            @(__PRETTY_FUNCTION__),
                            @(__LINE__),
                            @"You cannot chat with yourself"];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    NSString *myId = [XYDChatSessionService sharedInstance].clientId;
    NSArray *array = @[ myId, peerId ];
    [self fetchConversationWithMembers:array type:XYDChatConversationTypeSingle callback:callback];
}

- (void)checkDuplicateValueOfArray:(NSArray *)array {
    NSSet *set = [NSSet setWithArray:array];
    if (set.count != array.count) {
        [NSException raise:NSInvalidArgumentException format:@"The array has duplicate value"];
    }
}

- (void)fetchConversationWithMembers:(NSArray *)members type:(XYDChatConversationType)type callback:(XYDChatConversationResultBlock)callback {
    if ([members containsObject:[XYDChatSessionService sharedInstance].clientId] == NO) {
        [NSException raise:NSInvalidArgumentException format:@"members should contain myself"];
    }
    [self checkDuplicateValueOfArray:members];
    [self createConversationWithMembers:members type:type unique:YES callback:callback];
}

- (void)createConversationWithMembers:(NSArray *)members type:(XYDChatConversationType)type unique:(BOOL)unique callback:(XYDChatConversationResultBlock)callback {
    NSString *name = nil;
    if (type == XYDChatConversationTypeGroup) {
        // 群聊默认名字， 老王、小李
        name = [self groupConversaionDefaultNameForUserIds:members];
    }
//    XYDConversationOption options;
//    if (unique) {
//        // 如果相同 members 的对话已经存在，将返回原来的对话
//        options = XYDConversationOptionUnique;
//    } else {
//        // 创建一个新对话
//        options = XYDConversationOptionNone;
//    }
//    [self.client createConversationWithName:name clientIds:members attributes:@{ XYDChat_CONVERSATION_TYPE : @(type) } options:options callback:callback];
}

- (NSString *)groupConversaionDefaultNameForUserIds:(NSArray *)userIds {
    NSError *error = nil;
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:userIds];
//    NSString *currentClientId = [LCChatKit sharedInstance].clientId;
//    [mutableArray addObject:currentClientId];
//    userIds = [mutableArray copy];
//    NSArray<id<XYDChatUserDelegate>> *array = [[XYDChatUserSystemService sharedInstance] getCachedProfilesIfExists:userIds error:&error];
//    if (error || (array.count == 0)) {
//        NSString *groupName = [userIds componentsJoinedByString:@","];
//        return groupName;
//    }
//    
//    NSMutableArray *names = [NSMutableArray array];
//    [array enumerateObjectsUsingBlock:^(id<XYDChatUserDelegate>  _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
//        [names addObject:user.name ?: user.clientId];
//    }];
//    return [names componentsJoinedByString:@","];
    return nil;
}

- (NSString *)databasePathWithUserId:(NSString *)userId {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appId = [XYDChatKit sharedInstance].appId;
    return [libPath stringByAppendingPathComponent:[NSString stringWithFormat:@"com.leancloud.lcchatkit.%@.%@.db", appId, userId]];
}

- (void)setupDatabaseWithUserId:(NSString *)userId {
    NSString *dbPath = [self databasePathWithUserId:userId];
    [self setupSucceedMessageDatabaseWithPath:dbPath];
    [self setupFailedMessagesDBWithDatabasePath:dbPath];
}

- (void)setupSucceedMessageDatabaseWithPath:(NSString *)path {
//    if (!self.databaseQueue) {
        //FIXME:when tom log out then jerry login , log this
//        XYDChatLog(@"database queue should not be nil !!!!");
//    }
//    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
//    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:XYDChatConversatoinTableCreateSQL];
//    }];
}

- (void)updateConversationAsRead {
//    XYDConversation *conversation = self.currentConversation;
//    NSString *conversationId = conversation.conversationId;
//    if (!conversation.createAt || !conversation.imClient) {
//        NSAssert(conversation.imClient, @"类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"imClient or conversation is nil");
//        return;
//    }
//    [self insertRecentConversation:conversation shouldRefreshWhenFinished:NO];
//    [self updateUnreadCountToZeroWithConversationId:conversationId shouldRefreshWhenFinished:NO];
//    [self updateMentioned:NO conversationId:conversationId shouldRefreshWhenFinished:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationUnreadsUpdated object:nil];
}

- (void)setCurrentConversation:(XYDConversation *)currentConversation {
    _currentConversation = currentConversation;
    [self pinIMClientToConversationIfNeeded:currentConversation];
}

- (void)pinIMClientToConversationIfNeeded:(XYDConversation *)conversation {
//    if (!conversation.imClient) {
//        [conversation setValue:[LCChatKit sharedInstance].client forKey:@"imClient"];
//    }
}

- (XYDConversation *)currentConversation {
    [self pinIMClientToConversationIfNeeded:_currentConversation];
    return _currentConversation;
}

- (BOOL)isChatting {
    return (self.currentConversationId.length > 0);
}

#pragma mark - conversations local data

- (NSData *)dataFromConversation:(XYDConversation *)conversation {
//    XYDChatKeyedConversation *keydConversation = [conversation keyedConversation];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:keydConversation];
//    return data;
    return nil;
}

- (XYDConversation *)conversationFromData:(NSData *)data {
//    XYDChatKeyedConversation *keyedConversation = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    XYDConversation *conversation = [[XYDChatSessionService sharedInstance].client conversationWithKeyedConversation:keyedConversation];
//    return conversation;
    return nil;
}

- (void)updateUnreadCountToZeroWithConversationId:(NSString *)conversationId {
    [self updateUnreadCountToZeroWithConversationId:conversationId shouldRefreshWhenFinished:YES];
}

- (void)updateUnreadCountToZeroWithConversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished {
//    XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversationId];
//    cachedConversation.XYDChat_unreadCount = 0;
//    dispatch_async(self.sqliteQueue, ^{
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            [db executeUpdate:XYDConversationTableUpdateUnreadCountSQL  withArgumentsInArray:@[@0, conversationId]];
//        }];
//    });
//    if (shouldRefreshWhenFinished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationListDataSourceUpdated object:self];
//    }
}

- (void)deleteRecentConversationWithConversationId:(NSString *)conversationId {
    [self deleteRecentConversationWithConversationId:conversationId shouldRefreshWhenFinished:YES];
}

- (void)deleteRecentConversationWithConversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished {
//    [self.conversationDictionary removeObjectForKey:conversationId];
//    dispatch_async(self.sqliteQueue, ^{
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            [db executeUpdate:XYDConversationTableDeleteSQL withArgumentsInArray:@[conversationId]];
//        }];
//    });
//    if (shouldRefreshWhenFinished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationListDataSourceUpdated object:self];
//    }
}

- (void)insertRecentConversation:(XYDConversation *)conversation {
    [self insertRecentConversation:conversation shouldRefreshWhenFinished:YES];
}

- (void)insertRecentConversation:(XYDConversation *)conversation shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished {
//    if (!conversation.createAt) {
//        return;
//    }
//    XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversation.conversationId];
//    if (!cachedConversation) {
//        [self.conversationDictionary setObject:conversation forKey:conversation.conversationId];
//    }
//    dispatch_async(self.sqliteQueue, ^{
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            NSData *data = [self dataFromConversation:conversation];
//            [db executeUpdate:XYDConversationTableInsertSQL withArgumentsInArray:@[conversation.conversationId, data, @0, @(NO), @""]];
//        }];
//    });
//    if (shouldRefreshWhenFinished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationListDataSourceUpdated object:self];
//    }
}

- (BOOL)isRecentConversationExistWithConversationId:(NSString *)conversationId {
    XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversationId];
    BOOL exists = NO;
    if (cachedConversation) {
        exists = YES;
    }
    return exists;
}

- (void)increaseUnreadCountWithConversationId:(NSString *)conversationId {
    [self increaseUnreadCountWithConversationId:conversationId shouldRefreshWhenFinished:YES];
}

- (void)increaseUnreadCountWithConversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished {
//    XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversationId];
//    cachedConversation.XYDChat_unreadCount += 1;
//    dispatch_async(self.sqliteQueue, ^{
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            [db executeUpdate:XYDConversationTableIncreaseOneUnreadCountSQL withArgumentsInArray:@[conversationId]];
//        }];
//    });
//    if (shouldRefreshWhenFinished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationListDataSourceUpdated object:self];
//    }
}
- (void)increaseUnreadCount:(NSUInteger)increaseUnreadCount withConversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished {
//    XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversationId];
//    cachedConversation.XYDChat_unreadCount += increaseUnreadCount;
//    dispatch_async(self.sqliteQueue, ^{
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            [db executeUpdate:XYDConversationTableIncreaseUnreadCountSQL withArgumentsInArray:@[@(increaseUnreadCount) ,conversationId]];
//        }];
//    });
//    if (shouldRefreshWhenFinished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationListDataSourceUpdated object:self];
//    }
}
- (void)updateMentioned:(BOOL)mentioned conversationId:(NSString *)conversationId {
    [self updateMentioned:mentioned conversationId:conversationId shouldRefreshWhenFinished:YES];
}

- (void)updateMentioned:(BOOL)mentioned conversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished {
//    XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversationId];
//    cachedConversation.XYDChat_mentioned = mentioned;
//    dispatch_async(self.sqliteQueue, ^{
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            [db executeUpdate:XYDConversationTableUpdateMentionedSQL withArgumentsInArray:@[@(mentioned), conversationId]];
//        }];
//    });
//    if (shouldRefreshWhenFinished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationListDataSourceUpdated object:self];
//    }
}

- (NSString *)draftWithConversationId:(NSString *)conversationId {
//    XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversationId];
//    return [cachedConversation.XYDChat_draft copy];
    return nil;
}

- (void)updateDraft:(NSString *)draft conversationId:(NSString *)conversationId {
    [self updateDraft:draft conversationId:conversationId shouldRefreshWhenFinished:YES];
}

- (void)updateDraft:(NSString *)draft conversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished {
//    XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversationId];
//    cachedConversation.XYDChat_draft = [draft copy];
//    dispatch_async(self.sqliteQueue, ^{
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            [db executeUpdate:XYDConversationTableUpdateDraftSQL withArgumentsInArray:@[draft ?: @"", conversationId]];
//        }];
//    });
//    if (shouldRefreshWhenFinished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationListDataSourceUpdated object:self];
//    }
}

- (XYDConversation *)createConversationFromResultSet:(FMResultSet *)resultSet {
//    NSData *data = [resultSet dataForColumn:XYDConversationTableKeyData];
//    NSInteger unreadCount = [resultSet intForColumn:XYDConversationTableKeyUnreadCount];
//    BOOL mentioned = [resultSet boolForColumn:XYDConversationTableKeyMentioned];
//    NSString *draft = [resultSet stringForColumn:XYDConversationTableKeyDraft];
//    XYDConversation *conversation = [self conversationFromData:data];
//    conversation.XYDChat_unreadCount = unreadCount;
//    conversation.XYDChat_mentioned = mentioned;
//    conversation.XYDChat_draft = draft;
//    [self pinIMClientToConversationIfNeeded:conversation];
//    return conversation;
    return nil;
}

- (NSArray *)allRecentConversations {
    NSArray *conversations = [self.conversationDictionary allValues];
    return conversations;
}

- (void)updateRecentConversation:(NSArray *)conversations {
    [self updateRecentConversation:conversations shouldRefreshWhenFinished:YES];
}

- (void)updateRecentConversation:(NSArray *)conversations shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished {
//    for (XYDConversation *conversation in conversations) {
//        XYDConversation *cachedConversation = [self.conversationDictionary objectForKey:conversation.conversationId];
//        if (cachedConversation) {
//            conversation.XYDChat_unreadCount = cachedConversation.XYDChat_unreadCount;
//            conversation.XYDChat_draft = [cachedConversation.XYDChat_draft copy];
//            conversation.XYDChat_mentioned = cachedConversation.XYDChat_mentioned;
//            [self.conversationDictionary setObject:conversation forKey:conversation.conversationId];
//        }
//    }
//    dispatch_async(self.sqliteQueue, ^{
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            [db beginTransaction];
//            for (XYDConversation *conversation in conversations) {
//                [db executeUpdate:XYDConversationTableUpdateDataSQL, [self dataFromConversation:conversation], conversation.conversationId];
//            }
//            [db commit];
//        }];
//    });
//    if (shouldRefreshWhenFinished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationListDataSourceUpdated object:self];
//    }
}

/**
 *  删除对话对应的UIProfile缓存，比如当用户信息发生变化时
 *  @param  conversation 对话，可以是单聊，也可是群聊
 */
- (void)removeCacheForConversationId:(NSString *)conversationId {
    [self deleteRecentConversationWithConversationId:conversationId];
}

/**
 *  删除全部缓存，比如当切换用户时，如果同一个人显示的名称和头像需要变更
 */
- (BOOL)removeAllCachedRecentConversations {
    __block BOOL removeAllCachedRecentConversationsSuccess = NO;
//    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        removeAllCachedRecentConversationsSuccess = [db executeUpdate:XYDChatDeleteConversationTable];
//    }];
//    if (removeAllCachedRecentConversationsSuccess) {
//        [self.conversationDictionary removeAllObjects];
//    }
    return removeAllCachedRecentConversationsSuccess;
}

#pragma mark - conversationDictionary

/**
 *  在内存中缓存对话，避免反复查询数据库，与数据库保持一致，只对数据库只做增、删、改操作。
 */
- (NSMutableDictionary *)conversationDictionary{
//    if (!_conversationDictionary) {
//        _conversationDictionary = [[NSMutableDictionary alloc] init];
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//            FMResultSet  *resultSet = [db executeQuery:XYDConversationTableSelectSQL withArgumentsInArray:@[]];
//            while ([resultSet next]) {
//                XYDConversation *conversation = [self createConversationFromResultSet:resultSet];
//                BOOL isAvailable = conversation.createAt;
//                if (isAvailable) {
//                    [_conversationDictionary setObject:conversation forKey:conversation.conversationId];
//                }
//            }
//            [resultSet close];
//        }];
//    }
    return _conversationDictionary;
}

/**
 *  数据库增删改queue，对数据库的操作在这个queue上执行。
 */

- (dispatch_queue_t)sqliteQueue{
    if (!_sqliteQueue) {
        _sqliteQueue = dispatch_queue_create("com.chatkit-oc.sqliteQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _sqliteQueue;
}

#pragma mark - FailedMessageStore
///=============================================================================
/// @name FailedMessageStore
///=============================================================================

/**
 *  openClient 时调用
 *  @param path 与 clientId 相关
 */
- (void)setupFailedMessagesDBWithDatabasePath:(NSString *)path {
//    if (!self.databaseQueue) {
//        XYDChatLog(@"database queue should not be nil !!!!");
//    }
//    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
//    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:XYDChatCreateTableSQL];
//    }];
}

- (NSDictionary *)recordFromResultSet:(FMResultSet *)resultSet {
    NSMutableDictionary *record = [NSMutableDictionary dictionary];
//    NSData *data = [resultSet dataForColumn:XYDChatKeyMessage];
//    if (!data) {
//        return nil;
//    }
//    id message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    [record setObject:message forKey:XYDChatKeyMessage];
//    NSString *idValue = [resultSet stringForColumn:XYDChatKeyId];
//    [record setObject:idValue forKey:XYDChatKeyId];
    return record;
}

- (NSArray *)recordsByConversationId:(NSString *)conversationId {
    NSMutableArray *records = [NSMutableArray array];
//    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *resultSet = [db executeQuery:XYDChatSelectMessagesSQL, conversationId];
//        while ([resultSet next]) {
//            [records addObject:[self recordFromResultSet:resultSet]];
//        }
//        [resultSet close];
//    }];
    return records;
}

- (NSArray *)failedMessagesByConversationId:(NSString *)conversationId {
    NSArray *records = [self recordsByConversationId:conversationId];
    NSMutableArray *messages = [NSMutableArray array];
    for (NSDictionary *record in records) {
//        [messages addObject:record[XYDChatKeyMessage]];
    }
    return messages;
}

- (NSArray *)failedMessageIdsByConversationId:(NSString *)conversationId {
    NSArray *records = [self recordsByConversationId:conversationId];
    NSMutableArray *failedMessageIds = [NSMutableArray array];
    for (NSDictionary *record in records) {
//        [failedMessageIds addObject:record[XYDChatKeyId]];
    }
    return failedMessageIds;
}

- (NSArray *)recordsByMessageIds:(NSArray<NSString *> *)messageIds {
    NSString *messageIdsString = [messageIds componentsJoinedByString:@"','"];
    NSMutableArray *records = [NSMutableArray array];
//    NSString *query = [NSString stringWithFormat:XYDChatSelectMessagesByIDSQL, messageIdsString];
//    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *resultSet = [db executeQuery:query];
//        while ([resultSet next]) {
//            [records addObject:[self recordFromResultSet:resultSet]];
//        }
//        [resultSet close];
//    }];
    
    return records;
}

- (NSArray *)failedMessagesByMessageIds:(NSArray *)messageIds {
    NSArray *records = [self recordsByMessageIds:messageIds];
    if (records.count == 0) {
        return nil;
    }
    NSMutableArray *messages = [NSMutableArray array];
    for (NSDictionary *record in records) {
//        [messages addObject:record[XYDChatKeyMessage]];
    }
    return messages;
}

- (BOOL)deleteFailedMessageByRecordId:(NSString *)recordId {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        result = [db executeUpdate:XYDChatDeleteMessageSQL, recordId];
    }];
    return result;
}

- (BOOL)deleteFile:(NSString *)pathOfFileToDelete error:(NSError **)error {
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:pathOfFileToDelete];
    if(exists) {
        [[NSFileManager defaultManager] removeItemAtPath:pathOfFileToDelete error:error];
    }
    return exists;
}

- (void)insertFailedXYDChatMessage:(XYDChatMessage *)message {
    if (message.conversationId == nil) {
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:@"conversationId is nil"
                                     userInfo:nil];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:message];
    NSAssert(data, @"You can not insert nil message to DB");
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:XYDChatInsertMessageSQL, message.localMessageId, message.conversationId, data];
    }];
}

- (void)insertFailedMessage:(XYDChatMessage *)message {
    if (message.conversationId == nil) {
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:@"conversationId is nil"
                                     userInfo:nil];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:message];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:XYDChatInsertMessageSQL, message.messageId, message.conversationId, data];
    }];
}

#pragma mark - remote notification

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo[@"convid"]) {
        self.remoteNotificationConversationId = userInfo[@"convid"];
    }
}

#pragma mark - utils

- (void)sendMessage:(XYDChatMessage*)message
       conversation:(XYDConversation *)conversation
      progressBlock:(XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)block {
//    [self sendMessage:message conversation:conversation options:nil progressBlock:progressBlock callback:block];
}

- (void)sendMessage:(XYDChatMessage*)message
       conversation:(XYDConversation *)conversation
            options:(XYDChatMessageOption *)options
      progressBlock:(XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)block  {
    id<XYDChatUserDelegate> currentUser = [[XYDChatUserSystemService sharedInstance] fetchCurrentUser];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 云代码中获取到用户名，来设置推送消息, 老王:今晚约吗？
    if (currentUser.name) {
        // 避免为空造成崩溃
        [attributes setObject:currentUser.name forKey:@"username"];
    }
    if ([XYDChatSettingService sharedInstance].useDevPushCerticate) {
        [attributes setObject:@YES forKey:@"dev"];
    }
    if (message.attributes == nil) {
        message.attributes = attributes;
    } else {
        [attributes addEntriesFromDictionary:message.attributes];
        message.attributes = attributes;
    }
    
    // 消息的发送交给XYDConversation类去处理
    [conversation sendMessage:message option:nil progressBlock:progressBlock callback:block];
}

- (void)sendWelcomeMessageToPeerId:(NSString *)peerId text:(NSString *)text block:(XYDChatBooleanResultBlock)block {
    [self fecthConversationWithPeerId:peerId callback:^(XYDConversation *conversation, NSError *error) {
        if (error) {
            !block ?: block(NO, error);
        } else {
//            XYDChatTextMessage *textMessage = [XYDChatTextMessage messageWithText:text attributes:nil];
//            [self sendMessage:textMessage conversation:conversation progressBlock:nil callback:block];
        }
    }];
}

- (void)sendWelcomeMessageToConversationId:(NSString *)conversationId text:(NSString *)text block:(XYDChatBooleanResultBlock)block {
    [self fecthConversationWithConversationId:conversationId callback:^(XYDConversation *conversation, NSError *error) {
        if (error) {
            !block ?: block(NO, error);
        } else {
//            XYDChatTextMessage *textMessage = [XYDChatTextMessage messageWithText:text attributes:nil];
//            [self sendMessage:textMessage conversation:conversation progressBlock:nil callback:block];
        }
    }];
}

#pragma mark - query msgs

- (void)setFetchConversationHandler:(XYDChatFetchConversationHandler)fetchConversationHandler {
    _fetchConversationHandler = fetchConversationHandler;
}

//- (void)setConversationInvalidedHandler:(XYDConversationInvalidedHandler)conversationInvalidedHandler {
//    _conversationInvalidedHandler = conversationInvalidedHandler;
//}

- (void)setLoadLatestMessagesHandler:(XYDChatLoadLatestMessagesHandler)loadLatestMessagesHandler {
    _loadLatestMessagesHandler = loadLatestMessagesHandler;
}

- (void)queryTypedMessagesWithConversation:(XYDConversation *)conversation
                                 timestamp:(int64_t)timestamp
                                     limit:(NSInteger)limit
                                     block:(XYDChatArrayResultBlock)block {
//    XYDChatArrayResultBlock callback = ^(NSArray *messages, NSError *error) {
//        if (!messages) {
//            NSString *errorReason = [NSString stringWithFormat:@"类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"SDK处理异常，请联系SDK维护者修复luohanchenyilong@163.com"];
//            NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), errorReason);
//            // NSAssert(messages, errorReason);
//        }
//        //以下过滤为了避免非法的消息，引起崩溃，确保展示的只有 XYDChatMessage 类型
//        NSMutableArray *typedMessages = [NSMutableArray array];
//        for (XYDChatMessage *message in messages) {
//            [typedMessages addObject:[message XYDChat_getValidTypedMessage]];
//        }
//        !block ?: block(typedMessages, error);
//    };
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        if(timestamp == 0) {
//            // 该方法能确保在有网络时总是从服务端拉取最新的消息，首次拉取必须使用该方法
//            // sdk 会设置好 timestamp
//            [conversation queryMessagesWithLimit:limit callback:callback];
//        } else {
//            //会先根据本地缓存判断是否有必要从服务端拉取，这个方法不能用于首次拉取
//            [conversation queryMessagesBeforeId:nil timestamp:timestamp limit:limit callback:callback];
//        }
//    });
}

+ (void)cacheFileTypeMessages:(NSArray<XYDChatMessage *> *)messages callback:(XYDChatBooleanResultBlock)callback {
    NSString *queueBaseLabel = [NSString stringWithFormat:@"com.chatkit.%@", NSStringFromClass([self class])];
    const char *queueName = [[NSString stringWithFormat:@"%@.ForBarrier",queueBaseLabel] UTF8String];
    dispatch_queue_t queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT);
    
//    for (XYDChatMessage *message in messages) {
//        dispatch_async(queue, ^(void) {
//            if (message.mediaType == kXYDChatMessageMediaTypeImage || message.mediaType == kXYDChatMessageMediaTypeAudio) {
//                AVFile *file = message.file;
//                if (file && file.isDataAvailable == NO) {
//                    NSError *error;
//                    // 下载到本地
//                    NSData *data = [file getData:&error];
//                    if (error || data == nil) {
//                        XYDChatLog(@"download file error : %@", error);
//                    }
//                }
//            } else if (message.mediaType == kXYDChatMessageMediaTypeVideo) {
//                NSString *path = [[XYDChatSettingService sharedInstance] videoPathOfMessage:(XYDChatVideoMessage *)message];
//                if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                    NSError *error;
//                    NSData *data = [message.file getData:&error];
//                    if (error) {
//                        XYDChatLog(@"download file error : %@", error);
//                    } else {
//                        [data writeToFile:path atomically:YES];
//                    }
//                }
//            }
//        });
//    }
//    dispatch_barrier_async(queue, ^{
//        dispatch_async(dispatch_get_main_queue(),^{
//            !callback ?: callback(YES, nil);
//        });
//    });
}

- (XYDChatClient *)client {
    if (!_client) {
        XYDChatClient *client = [XYDChatSessionService sharedInstance].client;
        _client = client;
    }
    return _client;
}

@end
