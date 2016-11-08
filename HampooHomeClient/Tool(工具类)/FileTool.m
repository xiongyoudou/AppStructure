//
//  FileHelper.m
//  MiniPC
//
//  Created by xiongyoudou on 16/5/25.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "FileTool.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation FileTool

#pragma mark 写文件
+ (void)writeDictDataToPlistFile:(NSMutableDictionary *)aSaveDic fileName:(NSString *)fileName
{
    [aSaveDic writeToFile:[self getFileNamePath:fileName] atomically:YES];
}

+ (void)writeDict:(NSDictionary *)dict toPath:(NSString *)filePath
{
    BOOL isSuccess = [dict writeToFile:filePath atomically:YES];
    NSLog(@"%d",isSuccess);
}

#pragma mark 取文件
+ (NSMutableDictionary *)getPListFileData:(NSString *)fileName
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self getFileNamePath:fileName]];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    return dict;
}

#pragma mark 获取文件路径/不存在即创建

+ (void)createFilePahtIfNotExists:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //不存在即创建，初始化contents（文件内容）、attributes（文件属性）为nil
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

+ (NSString *)getFileNamePath:(NSString *)fileName
{
    NSString * filePath = [kDocumentsPath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //不存在即创建，初始化contents（文件内容）、attributes（文件属性）为nil
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}

#pragma mark 获取文件夹路径/不存在即创建
+ (NSString *)getFolderNamePath:(NSString *)folderName fileName:(NSString *)fileName PathExtension:(NSString *)pathExtension
{
    NSString * folderPath = [kDocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",folderName]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        //不存在即创建，初始化contents（文件内容）、attributes（文件属性）为nil
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];;
    }
    if (fileName && pathExtension) {
        return [[folderPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:pathExtension];
    } else {
        return folderPath;
    }
}

#pragma mark 沙盒是否存在此文件
+ (BOOL)isExistAtDocumentFile:(NSString *)fileName
{
    NSString * filePath = [kDocumentsPath stringByAppendingPathComponent:fileName];
    return ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) ? YES : NO;
}

+ (BOOL)isExistAtPath:(NSString *)filePath
{
    return ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) ? YES : NO;
}

#pragma mark 沙盒文件删除
+ (void)deleteDocumentFile:(NSString *)fileName
{
    NSString * filePath = [kDocumentsPath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}
#pragma mark 根据沙盒文件路径删除
+ (BOOL)deleteWithContentPath:(NSString *)path
{
    NSError *error=nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:&error];
    }
    if (error) {
        KMyLog(@"删除文件时出现问题:%@",[error localizedDescription]);
        return NO;
    }
    return YES;
}

/**
 *  返回文件类型
 *
 *  @param fileName 文件名
 *  @param isFolder 是否是文件夹
 *
 *  @return 文件类型
 */
+ (FileType)getFileTypeWithFileName:(NSString *)fileName isFolder:(BOOL)isFolder {
    if(isFolder) {
        // 文件夹
        return FileTypeFolder;
    }else {
        NSString *pathExtension = [fileName pathExtension];
        if (!pathExtension)return FileTypeUnknown;
        if ([MyTool isEqualCaseInsensitive:pathExtension otherStr:@"jpg"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"gif"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"png"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"jpeg"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"jpg"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"gif"]) {
            // 图片类型
            return FileTypeImage;
        }else if ([MyTool isEqualCaseInsensitive:pathExtension otherStr:@"txt"]) {
            return FileTypeTxt;
        }else if ([MyTool isEqualCaseInsensitive:pathExtension otherStr:@"doc"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"docx"]) {
            return FileTypeMicroWord;
        }else if ([MyTool isEqualCaseInsensitive:pathExtension otherStr:@"xlsx"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"xls"]) {
            return FileTypeMicroExcel;
        }else if ([MyTool isEqualCaseInsensitive:pathExtension otherStr:@"ppt"]) {
            return FileTypePPT;
        }else if ([MyTool isEqualCaseInsensitive:pathExtension otherStr:@"zip"]) {
            return FileTypeZip;
        }else if ([MyTool isEqualCaseInsensitive:pathExtension otherStr:@"mp4"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"avi"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"mov"]) {
            return FileTypeMovie;
        }else if ([MyTool isEqualCaseInsensitive:pathExtension otherStr:@"mp3"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"wav"] || [MyTool isEqualCaseInsensitive:pathExtension otherStr:@"wma"]) {
            return FileTypeAudio;
        }else if ([pathExtension isEqualToString:@"rar"]) {
            return FileTypeRar;
        }else if ([pathExtension isEqualToString:@"html"]) {
            return FileTypeHtml;
        }else if ([pathExtension isEqualToString:@"sqlite"] || [pathExtension isEqualToString:@"db"]) {
            return FileTypeSqlite;
        }else {
            return FileTypeUnknown;
        }
    }
}

/**
 *  根据文件类型返回文件所应显示的ICon图标
 *
 *  @param fileType 文件类型
 *
 *  @return 返回对应图片对象
 */
+ (UIImage *)getIconImageWithFileType:(FileType)fileType {
    switch (fileType) {
        case FileTypeFolder:return KFileFolderIcon;
        case FileTypeImage:return KFileImageIcon;
        case FileTypeTxt:return KFileTxtIcon;
        case FileTypeMicroWord:return KFileMicroWordIcon;
        case FileTypeMicroExcel:return KFileMicroExcelIcon;
        case FileTypePPT:return KFilePPTIcon;
        case FileTypeZip:return KFileZipIcon;
        case FileTypeMovie:return KFileMovieIcon;
        case FileTypeAudio:return KFileAudioIcon;
        case FileTypeRar:return KFileRarIcon;
        case FileTypeHtml:return KFileHtmlIcon;
        case FileTypeSqlite:return KFileSqlIcon;
        case FileTypeUnknown:return KFileUnknownIcon;
        default:return KFileUnknownIcon;
    }
}

// 根据实际字节大小调整显示内容
+ (NSString *)getFileSizeWithByteCounts:(long long)byteCounts {
    NSString *fileSize;
    CGFloat fsize = byteCounts / 1024.0;
    if (fsize <= 1024) {
        fileSize = [NSString stringWithFormat:@"%.1fKB",fsize];
    }else {
        fsize = fsize / 1024.0;
        if (fsize <= 1024) {
            fileSize = [NSString stringWithFormat:@"%.1fM",fsize];
        }else {
            fsize = fsize / 1024.0;
            fileSize = [NSString stringWithFormat:@"%.1fG",fsize];
        }
    }
    return fileSize;
}

// 获取路径文件的大小
+ (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString*) folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeForPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

// 清理缓存
+ (void)clearCache:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

@end
