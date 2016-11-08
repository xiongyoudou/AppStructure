//
//  HttpMacro.h
//  MiniPC
//
//  Created by xiongyoudou on 16/4/27.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#ifndef HttpMacro_h
#define HttpMacro_h

#pragma mark - 初始化相关接口

// 服务器测试是否可连接（其实替代下面接口，下面接口还返回设备信息）
#define KDeviceTest @"/api/server/test"
// 获取服务器信息
#define KGetDeviceInfo @"/api/server/search"
// 服务端初始化
#define KDeviceInit @"/api/server/init"
// 获取token
#define KGetToken @"/token"
// 修改用户名
#define KModifyUserName @" /api/user/edit"

#pragma mark - 网盘操作相关接口

// 列出网盘某一级目录
#define KGetList @"/api/store/list"
// 获取目录树列表（用于多选下载获取目录结构）
#define KGetListTree @"/api/store/listtrees"
// 获取上一级目录
#define KGetParentList @"/api/store/listparent"
// 新建文件夹
#define KCreateFolder @"/api/store/createdirectory"
//  重命名
#define KReName @"/api/store/rename"
// 移动（支持批量移动）
#define KMove @"/api/store/move"
// 删除（支持批量操作）
#define KDelete @"/api/store/delete"
// 上传
#define KUpload @"/api/store/upload"
// 下载
#define KDownload @"/api/store/download"
// 获取缩略图
#define KGetThumb @"/api/store/thumb"
#define KPlayVideoOrAudio @"/api/store/play"
// 获取单个文件进度信息（未上传完的单个文件）
#define KGetSingleUploadProgress @"/api/store/singleuploadprogress"
// 获取所有断点续传文件记录
#define KGetAllUploadProgress @"/api/store/alluploadprogress"
// 获取小于4M文件的断点续传文件记录
#define KGetUploadOffset @"/api/store/GetUploadOffSet"
// 获取最后一次自动备份的文件的修改时间
#define KGetLastAutoBackUpTime @"/api/store/getlastbackupfiletime"
// 删除缓存文件
#define KDeleteTempFile @"/api/store/deltempfile"


#endif /* HttpMacro_h */
