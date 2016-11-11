//
//  XYDChatFileMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatFileMessage.h"
#import "XYDFile.h"

@implementation XYDChatFileMessage
@synthesize file = _file;

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeFile;
}

- (XYDFile *)file {
    if (_file)
        return _file;
    
    return nil;
}

- (void)setFile:(XYDFile *)file {
    _file = file;
}

@end
