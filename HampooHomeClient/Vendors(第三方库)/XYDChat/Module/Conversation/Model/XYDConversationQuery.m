//
//  XYDConversationQuery.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversationQuery.h"
#import "XYDChatClient.h"

NSString *const kXYDChatKeyName = @"name";
NSString *const kXYDChatKeyMember = @"m";
NSString *const kXYDChatKeyCreator = @"c";
NSString *const kXYDChatKeyConversationId = @"objectId";

@implementation XYDConversationQuery

+(NSDictionary *)dictionaryFromGeoPoint:(XYDGeoPoint *)point
{
    return @{ @"__type": @"GeoPoint", @"latitude": @(point.latitude), @"longitude": @(point.longitude) };
}

+(XYDGeoPoint *)geoPointFromDictionary:(NSDictionary *)dict
{
    XYDGeoPoint * point = [[XYDGeoPoint alloc]init];
    point.latitude = [[dict objectForKey:@"latitude"] doubleValue];
    point.longitude = [[dict objectForKey:@"longitude"] doubleValue];
    return point;
}

+ (instancetype)orQueryWithSubqueries:(NSArray<XYDConversationQuery *> *)queries {
    XYDConversationQuery *result = nil;
//    
//    if (queries.count > 0) {
//        XYDChatClient *client = [[queries firstObject] client];
//        NSMutableArray *wheres = [[NSMutableArray alloc] initWithCapacity:queries.count];
//        
//        for (XYDConversationQuery *query in queries) {
//            NSString *eachClientId = query.client.clientId;
//            
//            if (!eachClientId || ![eachClientId isEqualToString:client.clientId]) {
//                XYDChatLoggerError(XYDChatLoggerDomainIM, @"Invalid conversation query client id: %@.", eachClientId);
//                return nil;
//            }
//            
//            [wheres addObject:[query where]];
//        }
//        
//        result = [client conversationQuery];
//        result.where[@"$or"] = wheres;
//    }
    
    return result;
}

+ (instancetype)andQueryWithSubqueries:(NSArray<XYDConversationQuery *> *)queries {
    XYDConversationQuery *result = nil;
    
//    if (queries.count > 0) {
//        XYDChatClient *client = [[queries firstObject] client];
//        NSMutableArray *wheres = [[NSMutableArray alloc] initWithCapacity:queries.count];
//        
//        for (XYDConversationQuery *query in queries) {
//            NSString *eachClientId = query.client.clientId;
//            
//            if (!eachClientId || ![eachClientId isEqualToString:client.clientId]) {
//                XYDChatLoggerError(XYDChatLoggerDomainIM, @"Invalid conversation query client id: %@.", eachClientId);
//                return nil;
//            }
//            
//            [wheres addObject:[query where]];
//        }
//        
//        result = [client conversationQuery];
//        
//        if (wheres.count > 1) {
//            result.where[@"$and"] = wheres;
//        } else {
//            [result.where addEntriesFromDictionary:[wheres firstObject]];
//        }
//    }
    
    return result;
}

- (instancetype)init {
    if ((self = [super init])) {
//        _where = [[NSMutableDictionary alloc] init];
//        _cachePolicy = (XYDChatCachePolicy)kXYDChatCachePolicyCacheElseNetwork;
        _cacheMaxAge = 1 * 60 * 60; // an hour
    }
    return self;
}

- (NSString *)whereString {
//    NSDictionary *dic = [XYDChatObjectUtils dictionaryFromDictionary:self.where];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
//    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return nil;
}

- (void)addWhereItem:(NSDictionary *)dict forKey:(NSString *)key {
//    if ([dict objectForKey:@"$eq"]) {
//        if ([self.where objectForKey:@"$and"]) {
//            NSMutableArray *eqArray = [self.where objectForKey:@"$and"];
//            int removeIndex = -1;
//            for (NSDictionary *eqDict in eqArray) {
//                if ([eqDict objectForKey:key]) {
//                    removeIndex = (int)[eqArray indexOfObject:eqDict];
//                }
//            }
//            
//            if (removeIndex >= 0) {
//                [eqArray removeObjectAtIndex:removeIndex];
//            }
//            
//            [eqArray addObject:@{key:[dict objectForKey:@"$eq"]}];
//        } else {
//            NSMutableArray *eqArray = [[NSMutableArray alloc] init];
//            [eqArray addObject:@{key:[dict objectForKey:@"$eq"]}];
//            [self.where setObject:eqArray forKey:@"$and"];
//        }
//    } else {
//        if ([self.where objectForKey:key]) {
//            [[self.where objectForKey:key] addEntriesFromDictionary:dict];
//        } else {
//            NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
//            [self.where setObject:mutableDict forKey:key];
//        }
//    }
}

- (void)whereKeyExists:(NSString *)key
{
    NSDictionary * dict = @{@"$exists": [NSNumber numberWithBool:YES]};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKeyDoesNotExist:(NSString *)key
{
    NSDictionary * dict = @{@"$exists": [NSNumber numberWithBool:NO]};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key equalTo:(id)object
{
    [self addWhereItem:@{@"$eq":object} forKey:key];
}

- (void)whereKey:(NSString *)key sizeEqualTo:(NSUInteger)count
{
    [self addWhereItem:@{@"$size": [NSNumber numberWithUnsignedInteger:count]} forKey:key];
}


- (void)whereKey:(NSString *)key lessThan:(id)object
{
    NSDictionary * dict = @{@"$lt":object};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object
{
    NSDictionary * dict = @{@"$lte":object};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key greaterThan:(id)object
{
    NSDictionary * dict = @{@"$gt": object};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object
{
    NSDictionary * dict = @{@"$gte": object};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key notEqualTo:(id)object
{
    NSDictionary * dict = @{@"$ne": object};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key containedIn:(NSArray *)array
{
    NSDictionary * dict = @{@"$in": array };
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array
{
    NSDictionary * dict = @{@"$nin": array };
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key containsAllObjectsInArray:(NSArray *)array
{
    NSDictionary * dict = @{@"$all": array };
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key nearGeoPoint:(XYDGeoPoint *)geopoint
{
    NSDictionary * dict = @{@"$nearSphere" : [[self class] dictionaryFromGeoPoint:geopoint]};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key nearGeoPoint:(XYDGeoPoint *)geopoint withinMiles:(double)maxDistance
{
    NSDictionary * dict = @{@"$nearSphere" : [[self class] dictionaryFromGeoPoint:geopoint], @"$maxDistanceInMiles":@(maxDistance)};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key nearGeoPoint:(XYDGeoPoint *)geopoint withinKilometers:(double)maxDistance
{
    NSDictionary * dict = @{@"$nearSphere" : [[self class] dictionaryFromGeoPoint:geopoint], @"$maxDistanceInKilometers":@(maxDistance)};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key nearGeoPoint:(XYDGeoPoint *)geopoint withinRadians:(double)maxDistance
{
    NSDictionary * dict = @{@"$nearSphere" : [[self class] dictionaryFromGeoPoint:geopoint], @"$maxDistanceInRadians":@(maxDistance)};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key withinGeoBoxFromSouthwest:(XYDGeoPoint *)southwest toNortheast:(XYDGeoPoint *)northeast
{
    NSDictionary * dict = @{@"$within": @{@"$box" : @[[[self class] dictionaryFromGeoPoint:southwest], [[self class] dictionaryFromGeoPoint:northeast]]}};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex
{
    NSDictionary * dict = @{@"$regex": regex};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifiers
{
    NSDictionary * dict = @{@"$regex":regex, @"$options":modifiers};
    [self addWhereItem:dict forKey:key];
}

- (void)whereKey:(NSString *)key containsString:(NSString *)substring
{
    [self whereKey:key matchesRegex:[NSString stringWithFormat:@".*%@.*",substring]];
}

- (void)whereKey:(NSString *)key hasPrefix:(NSString *)prefix
{
    [self whereKey:key matchesRegex:[NSString stringWithFormat:@"^%@.*",prefix]];
}

- (void)whereKey:(NSString *)key hasSuffix:(NSString *)suffix
{
    [self whereKey:key matchesRegex:[NSString stringWithFormat:@".*%@$",suffix]];
}

- (void)orderByAscending:(NSString *)key
{
//    self.order = [NSString stringWithFormat:@"%@", key];
}

- (void)addAscendingOrder:(NSString *)key
{
//    if (self.order.length <= 0)
//    {
//        [self orderByAscending:key];
//        return;
//    }
//    self.order = [NSString stringWithFormat:@"%@,%@", self.order, key];
}

- (void)orderByDescending:(NSString *)key
{
//    self.order = [NSString stringWithFormat:@"-%@", key];
}

- (void)addDescendingOrder:(NSString *)key
{
//    if (self.order.length <= 0)
//    {
//        [self orderByDescending:key];
//        return;
//    }
//    self.order = [NSString stringWithFormat:@"%@,-%@", self.order, key];
}

- (void)orderBySortDescriptor:(NSSortDescriptor *)sortDescriptor
{
//    NSString *symbol = sortDescriptor.ascending ? @"" : @"-";
//    self.order = [symbol stringByAppendingString:sortDescriptor.key];
}

- (void)orderBySortDescriptors:(NSArray *)sortDescriptors
{
//    if (sortDescriptors.count == 0) return;
//    
//    self.order = @"";
//    for (NSSortDescriptor *sortDescriptor in sortDescriptors) {
//        NSString *symbol = sortDescriptor.ascending ? @"" : @"-";
//        if (self.order.length) {
//            self.order = [NSString stringWithFormat:@"%@,%@%@", self.order, symbol, sortDescriptor.key];
//        } else {
//            self.order=[NSString stringWithFormat:@"%@%@", symbol, sortDescriptor.key];
//        }
//        
//    }
}

- (void)getConversationById:(NSString *)conversationId
                   callback:(XYDChatConversationResultBlock)callback {
//    [self whereKey:@"objectId" equalTo:conversationId];
//    [self findConversationsWithCallback:^(NSArray *objects, NSError *error) {
//        if (!error && objects.count > 0) {
//            XYDChatConversation *conversation = [objects objectAtIndex:0];
//            [XYDChatBlockHelper callConversationResultBlock:callback conversation:conversation error:nil];
//        } else if (error) {
//            [XYDChatBlockHelper callConversationResultBlock:callback conversation:nil error:error];
//        } else if (objects.count == 0) {
//            NSError *error = [XYDChatErrorUtil errorWithCode:kXYDChatErrorConversationNotFound reason:@"Conversation not found."];
//            [XYDChatBlockHelper callConversationResultBlock:callback conversation:nil error:error];
//        }
//    }];
}

//- (XYDChatGenericCommand *)queryCommand {
//    XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//    genericCommand.needResponse = YES;
//    genericCommand.cmd = XYDChatCommandType_Conv;
//    genericCommand.peerId = self.client.clientId;
//    genericCommand.op = XYDChatOpType_Query;
//    
//    XYDChatConvCommand *command = [[XYDChatConvCommand alloc] init];
//    XYDChatJsonObjectMessage *jsonObjectMessage = [[XYDChatJsonObjectMessage alloc] init];
//    jsonObjectMessage.data_p = [self whereString];
//    command.where = jsonObjectMessage;
//    command.sort = self.order;
//    
//    if (self.skip > 0) {
//        command.skip = (uint32_t)self.skip;
//    }
//    
//    if (self.limit > 0) {
//        command.limit = (uint32_t)self.limit;
//    } else {
//        command.limit = 10;
//    }
//    [genericCommand XYDChat_addRequiredKeyWithCommand:command];
//    return genericCommand;
//}

- (void)findConversationsWithCallback:(XYDChatArrayResultBlock)callback {
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        XYDChatGenericCommand *command = [self queryCommand];
//        [command setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            
//            [self processInCommand:inCommand
//                        outCommand:outCommand
//                          callback:callback
//                             error:error];
//        }];
//        [self processOutCommand:command callback:callback];
//    });
}

- (id)JSONValue:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return result;
}

//- (NSArray *)conversationsWithResults:(XYDChatJsonObjectMessage *)messages {
//    NSArray *results = [self JSONValue:messages.data_p];
//    
//    NSMutableArray *conversations = [NSMutableArray arrayWithCapacity:[results count]];
//    
//    for (NSDictionary *dict in results) {
//        XYDChatConversation *conversation = [[XYDChatConversation alloc] init];
//        
//        NSString *createdAt = dict[@"createdAt"];
//        NSString *updatedAt = dict[@"updatedAt"];
//        NSDictionary *lastMessageAt = dict[@"lm"];
//        
//        conversation.imClient = self.client;
//        conversation.conversationId = [dict objectForKey:@"objectId"];
//        conversation.name = [dict objectForKey:KEY_NAME];
//        conversation.attributes = [dict objectForKey:KEY_ATTR];
//        conversation.creator = [dict objectForKey:@"c"];
//        if (createdAt) conversation.createAt = [XYDChatObjectUtils dateFromString:createdAt];
//        if (updatedAt) conversation.updateAt = [XYDChatObjectUtils dateFromString:updatedAt];
//        if (lastMessageAt) conversation.lastMessageAt = [XYDChatObjectUtils dateFromDictionary:lastMessageAt];
//        conversation.members = [dict objectForKey:@"m"];
//        conversation.muted = [[dict objectForKey:@"muted"] boolValue];
//        conversation.transient = [[dict objectForKey:@"tr"] boolValue];
//        
//        [conversations addObject:conversation];
//    }
//    
//    [self.client cacheConversations:conversations];
//    
//    return conversations;
//}

- (void)bindConversations:(NSArray *)conversations {
    for (XYDConversation *conversation in conversations) {
//        conversation.imClient = self.client;
    }
}

//- (LCIMConversationCache *)conversationCache {
//    return [[LCIMConversationCache alloc] initWithClientId:self.client.clientId];
//}

/*!
 * Get cached conversations for a given command.
 * @param outCommand XYDChatConversationOutCommand object.
 * @param callback Result callback block.
 * NOTE: The conversations passed to callback will be nil if cache not found.
 */
//- (void)fetchCachedResultsForOutCommand:(XYDChatGenericCommand *)outCommand callback:(void(^)(NSArray *conversations))callback {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        LCIMConversationCache *cache = [self conversationCache];
//        NSArray *conversations = [cache conversationsForCommand:[outCommand XYDChat_conversationForCache]];
//        callback(conversations);
//    });
//}

- (void)callCallback:(XYDChatArrayResultBlock)callback withConversations:(NSArray *)conversations {
//    [self bindConversations:conversations];
//    [self.client cacheConversationsIfNeeded:conversations];
//    [XYDChatBlockHelper callArrayResultBlock:callback array:conversations error:nil];
}

//- (void)processInCommand:(XYDChatGenericCommand *)inCommand
//              outCommand:(XYDChatGenericCommand *)outCommand
//                callback:(XYDChatArrayResultBlock)callback
//                   error:(NSError *)error
//{
//    if (!error) {
//        XYDChatConvCommand *conversationInCommand = inCommand.convMessage;
//        XYDChatJsonObjectMessage *results = conversationInCommand.results;
//        
//        NSArray *conversations = [self conversationsWithResults:results];
//        [XYDChatBlockHelper callArrayResultBlock:callback array:conversations error:nil];
//        
//        if (self.cachePolicy != kXYDChatCachePolicyIgnoreCache) {
//            LCIMConversationCache *cache = [self conversationCache];
//            [cache cacheConversations:conversations maxAge:self.cacheMaxAge forCommand:[outCommand XYDChat_conversationForCache]];
//        }
//    } else {
//        if (self.cachePolicy == kXYDChatCachePolicyNetworkElseCache) {
//            [self fetchCachedResultsForOutCommand:outCommand callback:^(NSArray *conversations) {
//                if (conversations) {
//                    [self callCallback:callback withConversations:conversations];
//                } else {
//                    [XYDChatBlockHelper callArrayResultBlock:callback array:nil error:error];
//                }
//            }];
//        } else {
//            [XYDChatBlockHelper callArrayResultBlock:callback array:nil error:error];
//        }
//    }
//}

//- (void)processOutCommand:(XYDChatGenericCommand *)outCommand callback:(XYDChatArrayResultBlock)callback {
//    switch (self.cachePolicy) {
//        case kXYDChatCachePolicyIgnoreCache: {
//            [self.client sendCommand:outCommand];
//        }
//            break;
//        case kXYDChatCachePolicyCacheOnly: {
//            [self fetchCachedResultsForOutCommand:outCommand callback:^(NSArray *conversations) {
//                [self callCallback:callback withConversations:conversations];
//            }];
//        }
//            break;
//        case kXYDChatCachePolicyNetworkOnly: {
//            [self.client sendCommand:outCommand];
//        }
//            break;
//        case kXYDChatCachePolicyCacheElseNetwork: {
//            [self fetchCachedResultsForOutCommand:outCommand callback:^(NSArray *conversations) {
//                if ([conversations count]) {
//                    [self callCallback:callback withConversations:conversations];
//                } else {
//                    [self.client sendCommand:outCommand];
//                }
//            }];
//        }
//            break;
//        case kXYDChatCachePolicyNetworkElseCache: {
//            [self.client sendCommand:outCommand];
//        }
//            break;
//        case kXYDChatCachePolicyCacheThenNetwork: {
//            [self fetchCachedResultsForOutCommand:outCommand callback:^(NSArray *conversations) {
//                [self callCallback:callback withConversations:conversations];
//                [self.client sendCommand:outCommand];
//            }];
//        }
//            break;
//        default:
//            break;
//    }
//}

@end
