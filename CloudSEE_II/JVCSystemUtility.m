//
//  JVCSystemUtility.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCSystemUtility.h"
#import "JVCDeviceMacro.h"

static NSString const *APPLANGUAGE = @"zh-Hans";//简体中文的标志

@implementation JVCSystemUtility

static JVCSystemUtility *shareInstance = nil;


+ (JVCSystemUtility *)shareSystemUtilityInstance
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            
            shareInstance = [[self alloc] init];
        }
        return shareInstance;
    }
    return shareInstance;
}


+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            
            shareInstance = [super allocWithZone: zone];
            
            return shareInstance;
        }
    }
    return nil;
}


/**
 *  根据设备类型，自动获取iphone5图片的类型，如果是iphone5的情况下，返回图片1_iphone5.png 如果不是iphone5返回原来的图片
 *
 *  @param imageStr 图片的名称
 *
 *  @return 如果是iphone5 在图片的后面追加_iphone5.png 如果不是返回图片的原来的名称
 */
-(NSString *)getImageByImageName:(NSString *)imageStr
{
    
    if (iphone5) {
        
        NSArray *ArrayImageName = [imageStr componentsSeparatedByString:@"."];
        
        if (ArrayImageName.count == 2) {//正确
            
            return [NSString stringWithFormat:@"%@_iphone5.png",[ArrayImageName objectAtIndex:0]];
        }
    }
    
    return imageStr;
}


/**
 *  判断文件是否存在
 *
 *  @param checkFilePath 检查的文件名称
 *
 *  @return 存在返回TRUE
 */
-(BOOL)checkLocalFileExist:(NSString *)checkFilePath{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    return  [fileManager fileExistsAtPath:checkFilePath];
}

/**
 *  获取应用的app的Documents目录
 *
 *  @return 应用的app的Documents目录
 */
- (NSString *)getAppDocumentsPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [pathArray objectAtIndex:0];
}

/**
 *  获取应用的app的Caches目录
 *
 *  @return 应用的app的Caches目录
 */
- (NSString *)getAppCachesPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [pathArray objectAtIndex:0];
}

/**
 *  获取app的Temp路径
 *
 *  @return app的temp路径
 */
- (NSString *)getAppTempPath
{
    return NSTemporaryDirectory();
}

/**
 *  创建appDocuments下面的目录
 *
 *  @param fileName 文件名称
 *
 *  @return 创建好的应用目录
 */
- (NSString *)getAppDocumentsPathWithName:(NSString *)fileName
{
    NSString *DocumentsPath = [self getAppDocumentsPath];
    
    return [DocumentsPath stringByAppendingPathComponent:fileName];
}

/**
 *  判断字典是不是为空
 *
 *  @param infoId 字典类型的数据
 *
 *  @return yes:空  no：非空
 */
- (BOOL)judgeDictionIsNil:(NSDictionary *)infoId
{
    if (infoId != nil) {
        return NO;
    }
    return YES ;
}

/**
 *  判断收到的字典是否合法，只有再rt字段等于0的时候才是合法
 *
 *  @param dicInfo 传入的字典字段
 *
 *  @return yes：合法  no：不合法
 */
- (BOOL)JudgeGetDictionIsLegal:(NSDictionary *)dicInfo
{
    if (DEVICESERVICERESPONSE_SUCCESS ==  [[dicInfo objectForKey:DEVICE_JSON_RT] intValue]) {
        
        return YES;
    }
    return NO;
}

/**
 *  判断系统的语言
 *
 *  @return yes  中文  no英文
 */
- (BOOL)judgeAPPSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    
    NSString *currentLanguage = [languages objectAtIndex:0];

    if([currentLanguage isEqualToString:(NSString *)APPLANGUAGE])
    {
        return YES;
    }
    return NO;
}

/**
 *  初始化返回按钮
 *
 *  @param event  按下的事件
 *  @param sender 发送对象
 *
 *  @return 返回UIBarButtonItem
 */
- (UIBarButtonItem *)navicationBarWithTouchEvent:(SEL)event  Target:(id)sender
{
    NSString *path= nil;
    
    path = [[NSBundle mainBundle] pathForResource:@"nav_back" ofType:@"png"];
    
    if (path == nil) {
        
        path = [[NSBundle mainBundle] pathForResource:@"nav_back@2x" ofType:@"png"];

    }
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:sender action:event forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    [image release];
    
    return [barButtonItem autorelease];
    
}

@end
