//
//  JVCDeviceSourceHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceSourceHelper.h"
#import "JVCHandleDeviceMaths.h"
#import "JVCDeviceMacro.h"
#import "JVCDeviceSourceHelper.h"

static const int MAX_DEVICE_NUM = 100;//账号下面最大的值

@interface JVCDeviceSourceHelper ()
{
    NSMutableArray *deviceArray;////存放设备数组
}

@end

@implementation JVCDeviceSourceHelper

static JVCDeviceSourceHelper *shareDeviceSourceHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCDeviceSourceHelper *)shareDeviceSourceHelper
{
    @synchronized(self)
    {
        if (shareDeviceSourceHelper == nil) {
            
            shareDeviceSourceHelper = [[self alloc] init];
            
            [shareDeviceSourceHelper initDeviceSourceArray];
        }
        
        return shareDeviceSourceHelper;
    }
    
    return shareDeviceSourceHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareDeviceSourceHelper == nil) {
            
            shareDeviceSourceHelper = [super allocWithZone:zone];
            
            return shareDeviceSourceHelper;
        }
    }
    
    return nil;
}

/**
 *  初始化数组
 */
- (void)initDeviceSourceArray
{
    deviceArray = [[NSMutableArray alloc] init];
    
}

/**
 *  获取设备列表
 *
 *  @return 设备列表
 */
- (NSMutableArray *)deviceListArray
{
    return deviceArray;
}

/**
 *  清楚设备列表的所有数据
 */
- (void)removeAllDeviceObject
{
    [deviceArray removeAllObjects];
}

/**
 *  往数据列表中插入数据
 */
- (void)addDeviceObjectFromArray:(NSArray *)array
{
    [array retain];
    
    [deviceArray addObjectsFromArray:array];
    
    [array release];
}

/**
 *  把从服务器收到的数据转化成model
 *
 *  @param tdicDevice 服务器收到的数据
 */
- (void)addServerDateToDeviceList:(NSDictionary *)tdicDevice
{

    [self removeAllDeviceObject];

    NSArray *array = [tdicDevice objectForKey:DEVICE_JSON_DLIST];
    
    for (int i=0; i<array.count; i++) {
        
        NSDictionary *_dicInfo = [array objectAtIndex:i];
        
        JVCDeviceModel *_model = [[JVCDeviceModel alloc] initWithDictionary:_dicInfo];
        
        [deviceArray addObject:_model];
        
        [_model release];
    }

}

/**
 *  根据云视通号查看云视通号在设备中是否存在
 *
 *  @param YSTNum      云视通号
 *  @param deviceArray 传进来的用户的数组
 *
 *  @return ADDDEVICE_HAS_EXIST:存在  ADDDEVICE_NOT_EXIST:不存在  ADDDEVICE_MAX_MUX:超过最大值
 */
- (int)addDevicePredicateHaveYSTNUM:(NSString *)YSTNum
{
    
    if (deviceArray.count>MAX_DEVICE_NUM) {
        
        return ADDDEVICE_MAX_MUX;
        
    }
    
    for (int i=0; i<deviceArray.count; i++) {
        
        JVCDeviceModel *tSouceModel = [deviceArray objectAtIndex:i];
        
        if([tSouceModel.yunShiTongNum.uppercaseString isEqualToString:YSTNum.uppercaseString])
        {
            return ADDDEVICE_HAS_EXIST;
        }
    }
    
    
    return ADDDEVICE_NOT_EXIST;
    
}

#pragma mark  添加设备后，把获取到得数据（字典类型）转化为model类型
/**
 *  添加设备后，把获取到得数据（字典类型）转化为model类型
 *
 *  @param deviceInfoDic 设备的类型
 *
 *  @param YSTNum 云视通号
 *
 *  @return 转化完成后的model类型
 */
- (JVCDeviceModel *)convertDeviceDictionToModel:(NSDictionary *)deviceInfoDic withYSTNUM:(NSString *)YSTNum
{
    NSDictionary *dInfo = [deviceInfoDic objectForKey:DEVICE_JSON_DINFO];
    JVCDeviceModel *_model = [[JVCDeviceModel alloc] init];
    _model.yunShiTongNum = YSTNum.uppercaseString;
    _model.nickName = YSTNum.uppercaseString;
    _model.userName = [dInfo objectForKey:DEVICE_JSON_DVUSERNAME];
    _model.passWord = [dInfo objectForKey:DEVICE_JSON_DVPASSWORD];
    _model.onLineState = [[dInfo objectForKey:DEVICE_JSON_ONLINESTATE] intValue];
    _model.hasWifi = [[dInfo objectForKey:DEVICE_JSON_WIFI] intValue];
    _model.onLineState=DEVICESTATUS_ONLINE;
    _model.hasWifi    =DEVICESTATUS_OFFLINE;
    _model.linkType= CONNECTTYPE_YST;
    [deviceArray insertObject:_model atIndex:0];
    return [_model autorelease];
}

/**
 *  根据云通号获取sourceModel
 *
 *  @param ystNumber 云通号
 *
 *  @return 云通号的sourceModel
 */
-(JVCDeviceModel *)getDeviceModelByYstNumber:(NSString *)ystNumber
{
    
    for (int i=0; i<deviceArray.count; i++) {
        
        JVCDeviceModel *deviceModel= [deviceArray objectAtIndex:i];
        
        if ([[deviceModel.yunShiTongNum uppercaseString] isEqualToString:[ystNumber uppercaseString]]) {
            
            
            return deviceModel;
            
        }
    }
    
    return nil;
}


@end