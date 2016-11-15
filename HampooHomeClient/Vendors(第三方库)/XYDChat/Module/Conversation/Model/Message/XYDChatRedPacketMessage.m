//
//  XYDChatRedPacketMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatRedPacketMessage.h"


@implementation XYDChatRedPacketMessage
@synthesize rpModel = _rpModel;

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return 3;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
//    [self setText:@"红包"];
//    [self lcck_setObject:@"红包" forKey:LCCKCustomMessageTypeTitleKey];
//    [self lcck_setObject:@"这是一条红包消息，当前版本过低无法显示，请尝试升级APP查看" forKey:LCCKCustomMessageDegradeKey];
//    [self lcck_setObject:@"有人向您发送了一条红包消息，请打开APP查看" forKey:LCCKCustomMessageSummaryKey];
    return self;
}

- (void)setRpModel:(RedpacketMessageModel *)rpModel {
    _rpModel = rpModel;
    [rpModel.redpacketMessageModelToDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        [self setObject:obj forKey:key];
    }];
//    [self lcck_setObject:[NSString stringWithFormat:@"%@：[红包]%@",rpModel.redpacketSender.userNickname,rpModel.redpacket.redpacketGreeting] forKey:LCCKCustomMessageTypeTitleKey];
}

- (RedpacketMessageModel *)rpModel {
    if (!_rpModel) {
//        NSError * error;
//        NSDictionary * attributes = [NSJSONSerialization JSONObjectWithData:[self.payload dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
//        if (!error) {
//            _rpModel = [RedpacketMessageModel redpacketMessageModelWithDic:attributes];
//        }else{
//            _rpModel = nil;
//        }
    }
    return _rpModel;
}

@end
