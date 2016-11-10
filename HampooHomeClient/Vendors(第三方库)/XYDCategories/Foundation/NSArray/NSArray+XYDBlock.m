//
//  NSArray+Block.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSArray+XYDBlock.h"

@implementation NSArray (JKBlock)
- (void)xyd_each:(void (^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)xyd_eachWithIndex:(void (^)(id object, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (NSArray *)xyd_map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        [array addObject:block(object) ?: [NSNull null]];
    }
    
    return array;
}

- (NSArray *)xyd_filter:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
}

- (NSArray *)xyd_reject:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !block(evaluatedObject);
    }]];
}

- (id)xyd_detect:(BOOL (^)(id object))block {
    for (id object in self) {
        if (block(object))
            return object;
    }
    return nil;
}

- (id)xyd_reduce:(id (^)(id accumulator, id object))block {
    return [self xyd_reduce:nil withBlock:block];
}

- (id)xyd_reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block {
    id accumulator = initial;
    
    for(id object in self)
        accumulator = accumulator ? block(accumulator, object) : object;
    
    return accumulator;
}
@end
