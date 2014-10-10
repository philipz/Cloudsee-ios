//
//  JVCChannelScourseHelper.m
//  CloudSEE_II
//  通道数据的助手类，主要用于缓存设备通道数据、删除、增加、网络数据转换
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCChannelScourseHelper.h"
#import "JVCSystemUtility.h"
#import "JVCDeviceMacro.h"

@interface JVCChannelScourseHelper ()
{
    NSMutableArray *channelArray;
}
@end
@implementation JVCChannelScourseHelper

static JVCChannelScourseHelper *shareChannelScourseHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCChannelScourseHelper *)shareChannelScourseHelper
{
    @synchronized(self)
    {
        if (shareChannelScourseHelper == nil) {
            
            shareChannelScourseHelper = [[self alloc] init];
            
            [shareChannelScourseHelper initChannelSourceArray];
        }
        
        return shareChannelScourseHelper;
    }
    
    return shareChannelScourseHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareChannelScourseHelper == nil) {
            
            shareChannelScourseHelper = [super allocWithZone:zone];
            
            return shareChannelScourseHelper;
        }
    }
    
    return nil;
}

- (void)dealloc
{
    [channelArray release];
    channelArray = nil;
    
    [super dealloc];
}

/**
 *  初始化数组
 */
- (void)initChannelSourceArray
{
    channelArray = [[NSMutableArray alloc] init];
    
}

/**
 *  获取通道数组
 */
- (NSMutableArray *)ChannelListArray
{
    return channelArray;
}

/**
 *  清楚通道列表的所有数据
 */
- (void)removeAllchannelsObject
{
    [channelArray removeAllObjects];
}

/**
 *  根据云视通号返回一个设备的所有通道号集合
 *
 *  @return 一个设备的所有通道号集合
 */
-(NSMutableArray *)channelValuesWithDeviceYstNumber:(NSString *)ystNumber{
    
    NSMutableArray *channnleValues = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < channelArray.count; i++) {

        JVCChannelModel *channelModel = (JVCChannelModel *)[channelArray objectAtIndex:i];
        
        if ([channelModel.strDeviceYstNumber.uppercaseString isEqualToString:ystNumber.uppercaseString]) {
            
            [channnleValues addObject:[NSNumber numberWithInt:channelModel.nChannelValue]];
        }
    }

    return channnleValues;
}

/**
 *  把获取的单个设备的通道信息转换成model的数组并添加到arrayPoint集合里面
 *
 *  @param channelMdicInfo 设备通道信息的JSON数据
 */
-(void)channelInfoMDicConvertChannelModelToMArrayPoint:(NSDictionary *)channelMdicInfo deviceYstNumber:(NSString *)deviceYstNumber
{
    /**
     *  判断返回字典的rt字段是否为0
     */
    if ( [[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:channelMdicInfo]) {
        
        [deviceYstNumber retain];
        [channelMdicInfo retain];
        
        DDLogVerbose(@"deviceModel=%@",deviceYstNumber);
        
        [self convertChannelDictionToModelList:channelMdicInfo deviceYstNumber:deviceYstNumber];
        
        [deviceYstNumber release];
        [channelMdicInfo release];

    }
}

/**
 *  根据设备的云视通号和单个设备通道数组的索引号返回一个通道实体
 *
 *  @param index     通道索引号
 *  @param ystNumber 云视通号
 *
 *  @return 通道实体
 */
-(JVCChannelModel *)channelModelAtIndex:(int)index withDeviceYstNumber:(NSString *)ystNumber {
    
    JVCChannelModel *channelModel =  [[JVCChannelModel alloc] init];

    NSMutableArray *channels = [self channelModelWithDeviceYstNumber:ystNumber];
    
    [channels retain];
    
    if (index < channels.count  && index >= 0) {
        
        JVCChannelModel *findModel = [channelArray objectAtIndex:index];
        
        channelModel.strDeviceYstNumber = findModel.strDeviceYstNumber;
        channelModel.strNickName        = findModel.strNickName;
        channelModel.nChannelValue      = findModel.nChannelValue;
    }
    
    [channels release];

    return [channelModel autorelease];
}

/**
 *  将获取的通道信息转换成通道数组
 *
 *  @param channelInfoMDic   获取的通道信息数据
 *  @param deviceYstNumber   云视通号
 *
 */
-( void)convertChannelDictionToModelList:(NSDictionary *)channelInfoMDic deviceYstNumber:(NSString *)deviceYstNumber
{
    [channelInfoMDic retain];
    
    id channelInfoId=[channelInfoMDic objectForKey:DEVICE_CHANNEL_JSON_LIST];
    
    if ([channelInfoId isKindOfClass:[NSArray class]]) {
        
        NSArray *channelInfoArray=(NSArray *)channelInfoId;
        
        for (int i=0; i<channelInfoArray.count; i++) {
            
            NSDictionary *channelMdic=(NSDictionary *)[channelInfoArray objectAtIndex:i];
    
            JVCChannelModel *channelModel=[[JVCChannelModel alloc] initWithChannelDic:channelMdic ystNumber:deviceYstNumber];
            
            [channelArray addObject:channelModel];
            
            [channelModel release];
        }
    }
    [channelInfoMDic release];

}

/**
 *  删除一个设备下面的所有的通道
 *
 *  @param ystNumber 云视通号
 */
-(void)deleteChannelsWithDeviceYstNumber:(NSString *)ystNumber{
    
    NSMutableArray *channnleValues = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < channelArray.count; i++) {
        
        JVCChannelModel *channelModel = (JVCChannelModel *)[channelArray objectAtIndex:i];
                
        if ([channelModel.strDeviceYstNumber.uppercaseString isEqualToString:ystNumber.uppercaseString]) {
            
            [channnleValues addObject:channelModel];
        }
    }
    
    [channelArray removeObjectsInArray:channnleValues];
    
}

/**
 * 删除设备下面一个的通道
 *
 */
-(void)deleteSingleChannelWithDeviceYstNumber:(JVCChannelModel *)channelModelDelete{
    
    [channelArray removeObject:channelModelDelete];
}

/**
 *  根据云视通号返回一个设备的所有通道Model集合
 *
 *  @return 一个设备的所有通道集合
 */
-(NSMutableArray *)channelModelWithDeviceYstNumber:(NSString *)ystNumber{
    
    NSMutableArray *channnleValues = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < channelArray.count; i++) {
        
        JVCChannelModel *channelModel = (JVCChannelModel *)[channelArray objectAtIndex:i];
        
        if ([channelModel.strDeviceYstNumber.uppercaseString isEqualToString:ystNumber.uppercaseString]) {
            
            [channnleValues addObject:channelModel];
        }
    }
    
    return channnleValues;
}


@end
