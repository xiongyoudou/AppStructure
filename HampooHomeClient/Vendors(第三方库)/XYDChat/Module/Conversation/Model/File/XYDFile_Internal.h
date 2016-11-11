//
//  XYDFile_Internal.h
//  LeanCloud
//
//  Created by Zhu Zeng on 3/20/13.
//  Copyright (c) 2013 XYDOS. All rights reserved.
//

#import "XYDFile.h"

@interface XYDFile  ()

@property (readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *localPath;
@property (nonatomic, readwrite, copy) NSString *bucket;
@property (readwrite) NSString *url;
@property (readwrite, strong) NSData * data;
//@property (readwrite, strong) XYDHTTPRequestOperation * downloadOperation;
@property (nonatomic) BOOL isDirty;
@property (atomic, assign) BOOL onceCallGetFileSize;

@property(nonatomic, strong) NSString *cachePath;

+(XYDFile *)fileFromDictionary:(NSDictionary *)dict;
+(NSDictionary *)dictionaryFromFile:(XYDFile *)file;

+(NSString *)className;
-(NSString *)mimeType;
-(NSDictionary *)updateMetaData;
- (void)addACLToDict:(NSMutableDictionary *)dict;

+ (void)saveData:(NSData *)data withRemotePath:(NSString *)remotePath;
+ (void)cacheFile:(XYDFile *)file;
@end
