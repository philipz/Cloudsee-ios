//
//  JVCCloudSEESendGeneralHelper.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-30.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCCloudSEESendGeneralHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCCloudSEESendGeneralHelper 单例
 */
+ (JVCCloudSEESendGeneralHelper *)shareJVCCloudSEESendGeneralHelper;

/**
 *  远程发送的命令（仅仅发送 没有返回结果）
 *
 *  @param nJvChannelID           控制本地连接的通道号
 *  @param remoteOperationType    控制的类型
 *  @param remoteOperationCommand 控制的命令
 */
-(void)onlySendRemoteOperation:(int)nJvChannelID remoteOperationType:(int)remoteOperationType remoteOperationCommand:(int)remoteOperationCommand;

/**
 *  远程发送音频数据
 *
 *  @param nJvChannelID  本地连接的通道号
 *  @param Audiodata     音频数据
 *  @param AudiodataSize 音频数据的大小
 */
-(void)SendAudioDataToDevice:(int)nJvChannelID Audiodata:(char *)Audiodata AudiodataSize:(int)AudiodataSize;

/**
 *  远程控制指令
 *
 *  @param nJvChannelID           本地连接的通道号
 *  @param remoteOperationCommand 控制的命令
 */
-(void)RemoteOperationSendDataToDevice:(int)nJvChannelID remoteOperationCommand:(int)remoteOperationCommand;

/**
 *  远程发送的命令
 *
 *  @param nJvChannelID               控制本地连接的通道号
 *  @param remoteOperationType        控制的类型
 *  @param remoteOperationCommandData 控制的内容
 */
-(void)remoteSendDataToDevice:(int)nJvChannelID remoteOperationType:(int)remoteOperationType remoteOperationCommandData:(char *)remoteOperationCommandData;

/**
 *  设置有线网络
 *
 *  @param nJvChannelID      本地连接的通道号
 *  @param nIsEnableDHCP     是否启用自动获取 1:启用 0:手动输入
 *  ************以下参数手动输入时才生效*********************
 *  @param strIpAddress      ip地址
 *  @param strSubnetMaskIp   子网掩码
 *  @param strDefaultGateway 默认网关
 *  @param strDns            DNS服务器地址
 */
-(void)RemoteSetWiredNetwork:(int)nJvChannelID nIsEnableDHCP:(int)nIsEnableDHCP strIpAddress:(NSString *)strIpAddress strSubnetMask:(NSString *)strSubnetMask strDefaultGateway:(NSString *)strDefaultGateway strDns:(NSString *)strDns;

/**
 *  配置设备的无线网络(老的配置方式)
 *
 *  @param nJvChannelID    本地连接的通道号
 *  @param strSSIDName     配置的热点名称
 *  @param strSSIDPassWord 配置的热点密码
 *  @param strWifiAuth     热点的认证方式
 *  @param strWifiEncryp   热点的加密方式
 */
-(void)RemoteOldSetWiFINetwork:(int)nJvChannelID strSSIDName:(NSString *)strSSIDName strSSIDPassWord:(NSString *)strSSIDPassWord strWifiAuth:(NSString *)strWifiAuth strWifiEncrypt:(NSString *)strWifiEncrypt;

/**
 *  配置设备的无线网络(新的配置方式)
 *
 *  @param nJvChannelID    本地连接的通道号
 *  @param strSSIDName     配置的热点名称
 *  @param strSSIDPassWord 配置的热点密码
 *  @param nWifiAuth       热点的认证方式
 *  @param nWifiEncryp     热点的加密方式
 */
-(void)RemoteNewSetWiFINetwork:(int)nJvChannelID strSSIDName:(NSString *)strSSIDName strSSIDPassWord:(NSString *)strSSIDPassWord nWifiAuth:(int)nWifiAuth nWifiEncrypt:(int)nWifiEncrypt;

@end