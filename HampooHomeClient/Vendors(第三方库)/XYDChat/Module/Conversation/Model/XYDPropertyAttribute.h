//
//  XYDPropertyAttribute.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYDPropertyAttribute : NSObject {
    objc_property_t _property;
}

@property(nonatomic)BOOL isReadonly;
@property(nonatomic)BOOL isCopy;
@property(nonatomic)BOOL isRetain;
@property(nonatomic)BOOL isNonatomic;
@property(nonatomic)BOOL isDynamic;
@property(nonatomic)BOOL isWeak;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *getter;
@property(nonatomic, strong)NSString *setter;
@property(nonatomic)char typeCode;

- (instancetype)initWithProperty:(objc_property_t)property;

@end
