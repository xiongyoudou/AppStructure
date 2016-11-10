//
//  XYDGeoPoint_Internal.h
//  paas
//
//  Created by Zhu Zeng on 3/12/13.
//  Copyright (c) 2013 XYDOS. All rights reserved.
//

#import "AVGeoPoint.h"

@interface XYDGeoPoint ()

+(NSDictionary *)dictionaryFromGeoPoint:(AVGeoPoint *)point;
+(AVGeoPoint *)geoPointFromDictionary:(NSDictionary *)dict;

@end
