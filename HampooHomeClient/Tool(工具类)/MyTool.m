//
//  MyTool.m
//  ShopApp
//
//  Created by xiong有都 on 15/11/1.
//  Copyright © 2015年 xiong有都. All rights reserved.
//

#import "MyTool.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>

//#import "KeychainItemWrapper.h"
#import "SSKeychain.h"

@implementation MyTool

/**
 *  给tableView注册cell
 *
 *  @param XIBName cell的XIB名字
 *  @param table   tableview
 */
+(void)registeCellWithCellXib:(NSString *)XIBName andTable:(UITableView *)table {
    [table registerNib:[UINib nibWithNibName:XIBName bundle:nil] forCellReuseIdentifier:XIBName];
}

// 隐藏tableview多余的分割线
+(void)hideExtraTableviewSeparatedLine:(UITableView *)tableview {
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//隐藏多余的分割线
}

/**
 *  根据xib的名称获取xib中的视图对象
 */
+(UIView *)getNibViewByNibName:(NSString *)nibName {
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    UIView *nibView = (UIView *)arrayOfViews[0];
    return nibView;
}


#pragma mark 设置serchBar背景
+(void)customSearchBar:(UISearchBar *)searchBar{
    [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    [searchBar setBackgroundColor :[ UIColor clearColor ]];
//    [searchBar setBackgroundColor :COLOR(235, 235, 235, 1.0)];
}

#pragma mark 获取当前正显示的视图控制器
+(UIViewController *)getShowingViewingCtrl {
    UIViewController *returnCtrl;
    UIViewController *currentViewingCtrl4;
    //    currentViewingCtrl1 = [(UINavigationController *)CurrentWindow.rootViewController visibleViewController];
    //    currentViewingCtrl2 = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    currentViewingCtrl3 = [self getCurrentVC];
    currentViewingCtrl4 = [self activityViewController];
    
    //    NSLog(@"%@,%@,%@,%@",[currentViewingCtrl1 class],[currentViewingCtrl2 class],[currentViewingCtrl3 class],[currentViewingCtrl4 class]);
    //分别打印MainTabBarCtrl,CustomNavigationCtrl,CustomNavigationCtrl,,CustomNavigationCtrl
    returnCtrl = currentViewingCtrl4;
    return  returnCtrl;
}

+(UIViewController *)getRealCurrentViewCtrl:(UIViewController *)ctrl {
    UIViewController *resultCtrl;
    if ([ctrl isKindOfClass:[UINavigationController class]]) {
        resultCtrl = [[(UINavigationController *)ctrl viewControllers] lastObject];
        return [self getRealCurrentViewCtrl:resultCtrl];
    }else if ([ctrl isKindOfClass:[UITabBarController class]]) {
        resultCtrl = [(UITabBarController *)ctrl selectedViewController];
        return [self getRealCurrentViewCtrl:resultCtrl];
    } else {
        resultCtrl = ctrl;
        return resultCtrl;
    }
}

#pragma mark 获取当前活跃控制器方法1
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

#pragma mark 获取当前活跃控制器方法2
+ (UIViewController *)activityViewController {
    UIViewController* activityViewController = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if(tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0){
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            activityViewController = nextResponder;
        } else {
            activityViewController = window.rootViewController;
        }
    }
    return [self getRealCurrentViewCtrl:activityViewController];
}

#pragma mark 开线程处理事务
+(void)UseDispatchQueueDealWithBlock:(void(^)())dealBlock {
    [self UseDispatchQueueDealWithBlock:dealBlock andAterBlockOnMainThread:nil];
}

+(void)UseMainQueueDealWithBlock:(void(^)())dealBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(dealBlock){
            dealBlock();
        }
    });
}

//此方法用来对耗时的操作专门开辟线程来处理。如果完成之后需要转到主线程处理其他操作，则可以传递第二个参数（比如在处理数据库的某些不需要及时反馈的写入操作时，可以调用此方法）
+(void)UseDispatchQueueDealWithBlock:(void(^)())dealBlock andAterBlockOnMainThread:(void(^)())afterBlock {
    //    GCD中2中开线程的方式
    
    dispatch_queue_t showMap = dispatch_queue_create("showMap", NULL);
    dispatch_async(showMap, ^{
        if (dealBlock){
            dealBlock();
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(afterBlock){
                afterBlock();
            }
        });
    });
    
    
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
     if (dealBlock){
     dealBlock();
     }
     
     dispatch_async(dispatch_get_main_queue(),^{
     if(afterBlock){
     afterBlock();
     }
     });
     });
     */
}

static NSString *remainTime;

//点击获取验证码后倒计时
+ (void)countDownAfterClick:(UIButton *)btn countDownSeconds:(int)seconds {
    btn.enabled = NO;
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    remainTime = [NSString stringWithFormat:@"%d",seconds];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getRemainingTime:) userInfo:@{@"btn":btn} repeats:YES];
}

+ (void)getRemainingTime:(NSTimer *)timer//定时计
{
    NSDictionary *userInfo = timer.userInfo;
    UIButton *btn = userInfo[@"btn"];
    if ([remainTime intValue] >= 1) {
        remainTime = [NSString stringWithFormat:@"%d",([remainTime intValue]- 1)];
        [btn setTitle:[NSString stringWithFormat:@"%@后可重获",remainTime] forState:UIControlStateNormal];
    }else {
        [timer invalidate];
        timer = nil;
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        btn.enabled = YES;
        #ifdef NavBarColor
        [btn setBackgroundColor:NavBarColor];
        #endif
    }
}

#pragma mark 通过删除指定的字符&字符后面的所有字符，获取字符串前一部分
+ (NSString *)getStrByDeleteAfterOnStr:(NSString *)originStr andDeleteStr:(NSString *)deleteStr {
    NSString *newUserName = originStr;
    NSRange range = [originStr rangeOfString:deleteStr];
    if(range.location != NSNotFound)
    {
        newUserName = [originStr substringToIndex:range.location];
    }
    return newUserName;
}

#pragma mark 通过删除指定字符&字符前面所有字符，获取字符串后一部分
+ (NSString *)getStrNameByDeleteBeforeOnStr:(NSString *)originStr andDeleteStr:(NSString *)deleteStr {
    NSString *newUserName = originStr;
    NSRange range = [originStr rangeOfString:deleteStr];
    if(range.location != NSNotFound) {
        newUserName = [originStr substringFromIndex:(range.location + range.length)];
    }
    return newUserName;
}

#pragma mark 通过删除用户名后缀，获取字符串前一部分
+ (NSString *)getStrByDeleteSuffix:(NSString *)originUserName andDeleteStr:(NSString *)deleteStr//通过删除用户名后缀，获取字符串前一部分
{
    NSString *newUserName = originUserName;
    NSRange range = [originUserName rangeOfString:deleteStr];
    if(range.location != NSNotFound) {
        newUserName = [originUserName substringToIndex:range.location];
    }
    return newUserName;
}


#pragma mark 对中文进行编码，返回编码后的字符串
+(NSString *)dealWithChineseWithUTF8:(NSString *)chineseStr
{
    NSString *encodedStr = [chineseStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//对得到的字符串进行UTF-8解码
    return encodedStr;
}

#pragma mark 对已编码的中文字符串进行解码，返回正常中文字符串
+(NSString *)dealWithDecodedChineseWithUTF8:(NSString *)decodedChineseStr
{
    NSString *decodeStr = [decodedChineseStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//对得到的字符串进行UTF-8解码
    return decodeStr;
}

#pragma mark 去掉首位两端空格
+(NSString *)removeSpaceOnTheTopAndEnd:(NSString *)originStr {
    NSString *resultStr = [originStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return resultStr;
}

#pragma mark 对字符串中的特定字符串进行替换
+(NSString *)replaceString:(NSString *)str1 WithStr:(NSString *)str2 OnOriginalStr:(NSString *)originalStr {
    if (originalStr.length){
        return [originalStr stringByReplacingOccurrencesOfString:str1 withString:str2];
    }
    return nil;
}

// 对服务器返回的时间类型字符串去掉T,替换成空格
+(NSString *)replaceTStringWithBlankOnStr:(NSString *)originalStr {
    if (originalStr.length){
        return [originalStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
    return nil;
}

#pragma mark 是否允许访问摄像头
+ (BOOL)isCameraDenied {
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    // 被拒绝访问摄像头
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied || TARGET_IPHONE_SIMULATOR) {
        [[[UIAlertView alloc] initWithTitle:@"无法访问相机" message:@"请在iPhone的“设置-隐私-相机”选项中，允许任易清单访问你的手机相机。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        return YES;
    }
    return NO;
}

+ (BOOL)isPhotoDenied
{
    ALAuthorizationStatus state = [ALAssetsLibrary authorizationStatus];
    if (state == ALAuthorizationStatusDenied || state == ALAuthorizationStatusRestricted) {
        [[[UIAlertView alloc] initWithTitle:@"无法访问照片" message:@"请在iPhone的“设置-隐私-照片”选项中，允许任易清单访问你的手机照片。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        return YES;
    }
    return NO;
}

#pragma mark 是否允许访问麦克风
+ (BOOL)isMicroPhoneDenied
{
    __block BOOL isDenied = NO;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    isDenied = NO;
                }
                else {
                    isDenied = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"无法录音"
                                                    message:@"请在iPhone的“设置-隐私-麦克风”选项中，允许任易清单访问你的手机麦克风。"
                                                   delegate:nil
                                          cancelButtonTitle:@"好"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return isDenied;
}

+ (BOOL)isMobileContractsDenied;
{
    // 取得授权状态
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus == kABAuthorizationStatusDenied || authStatus == kABAuthorizationStatusRestricted)
    {
        [[[UIAlertView alloc] initWithTitle:@"无法访问通讯录" message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许任易清单访问你的手机通讯录。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil] show];
        return YES;
    }
    
    return NO;
}

+ (BOOL)isLocationDenied
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        [[[UIAlertView alloc] initWithTitle:@"无法获取位置" message:@"请在iPhone的“设置-隐私-定位服务”选项中，允许任易清单定位获取附近的人。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil] show];
        return YES;
    }
    return NO;
}

// 此方法时为了处理多用户登录时，从NsuderDefaults获取应用的某些属性配置信息时而不至混淆。我根据userId和key一种固定key的格式，再从userDefaluts中读取数据
+ (id)getUserDefaultWithKey:(NSString *)key onUser:(NSString *)userId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *realKey;
    if (userId) {
        realKey = [NSString stringWithFormat:@"%@_%@",userId,key];
    } else {
        //该种情况可能就是存储的数据不会因为切换用户的不同而有区别，多用户共享的数据
        realKey = key;
    }
    
    return [defaults objectForKey:realKey];//注意，此处返回的都是Id数据类型，所以在使用时如果是基本数据类型，需要通过具体的boolValue、intValue方法获取具体的数值
}

// 注意：此处我设置了存入的数据必须是对象类型，即使打算存入的是bool，int，也将其转换成NSNumber
+ (void)setUserDefaultWithKey:(NSString *)key onUser:(NSString *)userId value:(id)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *realKey;
    if (userId) {
        realKey = [NSString stringWithFormat:@"%@_%@",userId,key];
    }else {
        //该种情况可能就是存储的数据不会因为切换用户的不同而有区别，多用户共享的数据
        realKey = key;
    }
    [defaults setObject:value forKey:realKey];
    [defaults synchronize];
}

+ (void)removeUserDefaultWithKey:(NSString *)key onUser:(NSString *)userId  {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *realKey;
    if (userId) {
        realKey = [NSString stringWithFormat:@"%@_%@",userId,key];
    }else {
        //该种情况可能就是存储的数据不会因为切换用户的不同而有区别，多用户共享的数据
        realKey = key;
    }
    [defaults removeObjectForKey:realKey];
    [defaults synchronize];
}

BOOL hasNSURLSession() {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVersion < 7.0) {
        return NO;
    }
#else
    NSOperatingSystemVersion sysVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
    if ((sysVersion.majorVersion <= 10 && sysVersion.minorVersion < 9)) {
        return NO;
    }
#endif
    return YES;
}

BOOL hasAts() {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVersion < 9.0) {
        return NO;
    }
#else
    NSOperatingSystemVersion sysVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
    
    if ((sysVersion.majorVersion <= 10 && sysVersion.minorVersion < 11)) {
        return NO;
    }
#endif
    return YES;
}

BOOL allowsArbitraryLoads() {
    if (!hasAts()) {
        return YES;
    }
    
    // for unit test
    NSDictionary* d = [[NSBundle mainBundle] infoDictionary];
    if (d == nil || d.count == 0) {
        return YES;
    }
    
    NSDictionary* sec = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSAppTransportSecurity"];
    if (sec == nil) {
        return NO;
    }
    NSNumber* ats = [sec objectForKey:@"NSAllowsArbitraryLoads"];
    if (ats == nil) {
        return NO;
    }
    return ats.boolValue;
}

// 设置uuid，并通过keyChain保存
+ (NSString *)setKeyChainValue {
    NSString *strUUID = [SSKeychain passwordForService:@"com.hampoo.MiniPC" account:@"UUID"];
    if (strUUID==nil||[strUUID isEqualToString:@""]) {
        [SSKeychain setPassword:[[NSUUID UUID] UUIDString] forService:@"com.hampoo.MiniPC"  account:@"UUID"];
    }
    return strUUID;
}

// 从keyChain中取出uuid
+ (NSString *)getKeyChainValue {
     NSString *strUUID = [SSKeychain passwordForService:@"com.hampoo.MiniPC" account:@"UUID"];
    if (!strUUID) {
        strUUID = [self setKeyChainValue];
    }
    return strUUID;
}

// 不区分大小写，判断两个字符串是否相同
+ (BOOL)isEqualCaseInsensitive:(NSString *)str1 otherStr:(NSString *)str2 {
    // NSLiteralSearch 区分大小写(完全比较)
    // NSCaseInsensitiveSearch 不区分大小写
    // NSNumericSearch 只比较字符串的个数，而不比较字符串的字面值
    NSComparisonResult result = [str1 compare:str2 options:NSCaseInsensitiveSearch];
    return result == NSOrderedSame;
}

// 判断字符串是否是无效的字符串
+ (NSString *)isValidString:(NSString *)str {
    if (!str) return nil;
    if ([str isKindOfClass:[NSNull class]] || [str isEqual:[NSNull null]] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"] || [str isEqualToString:@"null"] || [str isEqualToString:@""] || [str isEqualToString:@"\0000"]) {
        return nil;
    }
    return str;
}

+ (id)isValidObj:(id)obj {
    if (!obj) return nil;
    if ([obj isKindOfClass:[NSNull class]] || [obj isEqual:[NSNull null]]) {
        return nil;
    }
    return obj;
}

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }else {
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }else {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


// 存储大文件至沙盒
+ (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset {
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle) {
        return NO;
    }
    static const NSUInteger BufferSize = 1024*1024;
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:nil];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            return NO;
        }
    } while (bytesRead > 0);
    free(buffer);
    return YES;
}

// 验证resumeData是否依旧有效
+ (NSData *)isValidResumeData:(NSData *)data {
    if (!data || [data length] < 1) return nil;
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return nil;
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"]; // ios8上有该字段
    if ([localFilePath length] < 1) {
        NSString *tempFileName = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoTempFileName"]; // ios9上有该字段
        localFilePath = [NSString stringWithFormat:@"%@/%@",kTempPath,tempFileName];
        if (localFilePath.length < 1) {
            return nil;
        }
        BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
        return isExists ? data : nil;
    }else {
        // 如果有该路径，需要将绝对路径替换成每次生成的路径
        NSString *tempFileName = [MyTool getStrNameByDeleteBeforeOnStr:localFilePath andDeleteStr:@"/tmp/"];
        localFilePath = [NSString stringWithFormat:@"%@%@",kTempPath,tempFileName];
        [resumeDictionary setValue:localFilePath forKey:@"NSURLSessionResumeInfoLocalPath"];
        NSString *error;
        NSData *newResumeData = [NSPropertyListSerialization dataFromPropertyList:resumeDictionary
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        return newResumeData;
    }
}

@end
