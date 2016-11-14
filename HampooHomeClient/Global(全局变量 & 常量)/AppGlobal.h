//
//  Global.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/14.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#ifndef Global_h
#define Global_h

#pragma mark - 全局结构体定义

typedef NS_ENUM(NSInteger,FileType) {
    FileTypeFolder,                 // 文件夹
    FileTypeImage,                  // 图片
    FileTypeTxt,                    // 文本
    FileTypeMicroWord,              // word
    FileTypeMicroExcel,             // excel
    FileTypePPT,                    // ppt
    FileTypeZip,                    // zip
    FileTypeMovie,                  // 视频
    FileTypeAudio,                  // 音频
    FileTypeRar,                    // rar
    FileTypeHtml,                   // html
    FileTypeSqlite,                 // 数据库文件
    FileTypeUnknown,                // 未知
};

#pragma mark - 全局常量定义


#pragma mark - 业务相关全局变量

#pragma mark - 网络请求全局变量


extern NSString *requestBaseUrl;

#endif /* Global_h */
