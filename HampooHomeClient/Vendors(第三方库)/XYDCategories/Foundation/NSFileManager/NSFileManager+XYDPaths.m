//
//  NSFileManager+Paths.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSFileManager+XYDPaths.h"
#include <sys/xattr.h>

@implementation NSFileManager (XYDPaths)
+ (NSURL *)xyd_URLForDirectory:(NSSearchPathDirectory)directory
{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)xyd_pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)xyd_documentsURL
{
    return [self xyd_URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)xyd_documentsPath
{
    return [self xyd_pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)xyd_libraryURL
{
    return [self xyd_URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)xyd_libraryPath
{
    return [self xyd_pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)xyd_cachesURL
{
    return [self xyd_URLForDirectory:NSCachesDirectory];
}

+ (NSString *)xyd_cachesPath
{
    return [self xyd_pathForDirectory:NSCachesDirectory];
}

+ (BOOL)xyd_addSkipBackupAttributeToFile:(NSString *)path
{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (double)xyd_availableDiskSpace
{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.xyd_documentsPath error:nil];
    
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}
@end
