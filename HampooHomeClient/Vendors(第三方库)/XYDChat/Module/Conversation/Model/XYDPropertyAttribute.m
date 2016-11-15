//
//  XYDPropertyAttribute.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDPropertyAttribute.h"

@implementation XYDPropertyAttribute

- (instancetype)initWithProperty:(objc_property_t)property {
    if ((self = [super init])) {
        _property = property;
        [self parseProperty];
    }
    return self;
}

//Code
//Meaning
//R
//The property is read-only (readonly).
//C
//The property is a copy of the value last assigned (copy).
//&
//The property is a reference to the value last assigned (retain).
//N
//The property is non-atomic (nonatomic).
//G<name>
//The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
//S<name>
//The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
//D
//The property is dynamic (@dynamic).
//W
//The property is a weak reference (__weak).
//P
//The property is eligible for garbage collection.
//t<encoding>
//Specifies the type using old-style encoding.
- (void)parseProperty {
    const char * attrs = property_getAttributes( _property );
    if (!attrs) {
        return;
    }
    NSString *attrsString = [NSString stringWithFormat:@"%s", attrs];
    NSArray *attrArray = [attrsString componentsSeparatedByString:@","];
    for (NSString *attr in attrArray) {
        char a = [attr characterAtIndex:0];
        switch (a) {
            case 'T':
                _typeCode = [attr characterAtIndex:1];
                break;
            case 'R':
                _isReadonly = YES;
                break;
            case 'C':
                _isCopy = YES;
                break;
            case '&':
                _isRetain = YES;
                break;
            case 'N':
                _isNonatomic = YES;
                break;
            case 'D':
                _isDynamic = YES;
                break;
            case 'W':
                _isWeak = YES;
                break;
            case 'G':
                _getter = [attr substringFromIndex:1];
                break;
            case 'S':
                _setter = [attr substringFromIndex:1];
                break;
                
            default:
                break;
        }
    }
    const char *name = property_getName(_property);
    if (name) {
        _name = [[NSString alloc] initWithUTF8String:name];
    }
    if (!_getter) {
        _getter = _name;
    }
    if (!_isReadonly && !_setter && _name) {
        NSString *nameString = _name;
        _setter = [[NSString alloc] initWithFormat:@"set%@%@:",
                   [[nameString substringToIndex:1] uppercaseString],
                   [nameString substringFromIndex:1]];
    }
}

@end
