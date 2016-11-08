//
//  MyTool.h
//  ShopApp
//
//  Created by xiong有都 on 15/11/1.
//  Copyright © 2015年 xiong有都. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  与特定程序无关的工具方法
 */

@interface MyTool : NSObject


+(void)registeCellWithCellXib:(NSString *)XIBName andTable:(UITableView *)table;
+(void)hideExtraTableviewSeparatedLine:(UITableView *)tableview;
+(UIView *)getNibViewByNibName:(NSString *)nibName;
+(void)customSearchBar:(UISearchBar *)searchBar;
+(UIViewController *)getShowingViewingCtrl;
+(void)UseDispatchQueueDealWithBlock:(void(^)())dealBlock;
+(void)UseMainQueueDealWithBlock:(void(^)())dealBlock;
+(void)UseDispatchQueueDealWithBlock:(void(^)())dealBlock andAterBlockOnMainThread:(void(^)())afterBlock;
+ (void)countDownAfterClick:(UIButton *)btn countDownSeconds:(int)seconds;
+ (NSString *)getStrByDeleteAfterOnStr:(NSString *)originStr andDeleteStr:(NSString *)deleteStr;
+ (NSString *)getStrNameByDeleteBeforeOnStr:(NSString *)originStr andDeleteStr:(NSString *)deleteStr;
+ (NSString *)getStrByDeleteSuffix:(NSString *)originUserName andDeleteStr:(NSString *)deleteStr;
+(NSString *)dealWithChineseWithUTF8:(NSString *)chineseStr;
+(NSString *)dealWithDecodedChineseWithUTF8:(NSString *)decodedChineseStr;
+(NSString *)removeSpaceOnTheTopAndEnd:(NSString *)originStr;
+(NSString *)replaceString:(NSString *)str1 WithStr:(NSString *)str2 OnOriginalStr:(NSString *)originalStr;
+(NSString *)replaceTStringWithBlankOnStr:(NSString *)originalStr;
+ (BOOL)isCameraDenied;
+ (BOOL)isPhotoDenied;
+ (BOOL)isMicroPhoneDenied;
+ (BOOL)isMobileContractsDenied;
+ (BOOL)isLocationDenied;
+ (id)getUserDefaultWithKey:(NSString *)key onUser:(NSString *)userId;
+ (void)setUserDefaultWithKey:(NSString *)key onUser:(NSString *)userId value:(id)value;
+ (void)removeUserDefaultWithKey:(NSString *)key onUser:(NSString *)userId;

BOOL hasNSURLSession();
BOOL hasAts();
BOOL allowsArbitraryLoads();

+ (NSString *)setKeyChainValue;
+ (NSString *)getKeyChainValue;

+ (BOOL)isEqualCaseInsensitive:(NSString *)str1 otherStr:(NSString *)str2;
+ (NSString *)isValidString:(NSString *)str;
+ (id)isValidObj:(id)obj;

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
+ (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset;
+ (NSData *)isValidResumeData:(NSData *)data;

@end
