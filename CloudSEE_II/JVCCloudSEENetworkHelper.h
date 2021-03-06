//
//  JVCCloudSEENetworkHelper.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-30.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCCloudSEEManagerHelper.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVNetConst.h"

@protocol ystNetWorkHelpDelegate <NSObject>

@optional

/**
 *  连接的回调代理
 *
 *  @param connectCallBackInfo 返回的连接信息
 *  @param nlocalChannel       本地通道连接从1开始
 *  @param connectType         连接返回的类型
 */
-(void)ConnectMessageCallBackMath:(NSString *)connectCallBackInfo nLocalChannel:(int)nlocalChannel connectResultType:(int)connectResultType;

/**
 *  OpenGL显示的视频回调函数
 *
 *  @param nLocalChannel             本地显示窗口的编号
 *  @param imageBufferY              YUV数据中的Y数据
 *  @param imageBufferU              YUV数据中的U数据
 *  @param imageBufferV              YUV数据中的V数据
 *  @param decoderFrameWidth         视频的宽
 *  @param decoderFrameHeight        视频的高
 *  @param isVideoType               视频数据类型 YES:05 NO:04
 */
-(void)H264VideoDataCallBackMath:(int)nLocalChannel imageBufferY:(char *)imageBufferY imageBufferU:(char *)imageBufferU imageBufferV:(char *)imageBufferV decoderFrameWidth:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber withVideoType:(BOOL)isVideoType;

/**
 *  开始请求文本聊天的回调
 *
 *  @param nLocalChannel 本地显示窗口的编号
 *  @param nDeviceType   设备的类型
 *  @param isNvrDevice   是否是NVR设备
 */
-(void)RequestTextChatCallback:(int)nLocalChannel withDeviceType:(int)nDeviceType withIsNvrDevice:(BOOL)isNvrDevice;

/**
 *  开始请求文本聊天的回调
 *
 *  @param nLocalChannel 本地显示窗口的编号
 *  @param nDeviceModel  设备的类型 （YES：05）
 */
-(void)RequestTextChatIs05DeviceCallback:(int)nLocalChannel withDeviceModel:(BOOL)nDeviceModel;

/**
 *  文本聊天请求的结果回调
 *
 *  @param nLocalChannel 本地本地显示窗口的编号
 *  @param nStatus       文本聊天的状态
 */
-(void)RequestTextChatStatusCallBack:(int)nLocalChannel withStatus:(int)nStatus;


@end

@protocol ystNetWorkAudioDelegate <NSObject>

@optional

/**
 *  音频播放的回调
 *
 *  @param soundBuffer     音频数据
 *  @param soundBufferSize 音频数据的大小
 *  @param soundBufferType 音频数据的类别
 */
-(void)playVideoSoundCallBackMath:(char *)soundBuffer soundBufferSize:(int)soundBufferSize soundBufferType:(BOOL)soundBufferType;

/**
 *  语音对讲的回调
 *
 *  @param VoiceInterState 对讲的状态
 */
-(void)VoiceInterComCallBack:(int)VoiceInterState;
/**
 *  打开音频处理
 *
 *  @param nAudioBit                音频采集的数据位数
 *  @param nAudioCollectionDataSize 音频采集的数据大小
 */
-(void)OpenAudioCollectionCallBack:(int)nAudioBit nAudioCollectionDataSize:(int)nAudioCollectionDataSize;

@end

@protocol ystNetWorkHelpRemoteOperationDelegate <NSObject>

@optional

/**
 *  获取当前连接通道的码流参数以及是否是家用IPC
 *
 *  @param nLocalChannel 本地连接通道编号
 *  @param nStreamType   码流类型  1:高清 2：标清 3：流畅 0:默认不支持切换码流
 *  @param isHomeIPC     YES是家用IPC
 *  @param effectType    图像翻转标志
 *  @param storageType   小于0不支持
 *  @param isNewHomeIPC  YES：新的家用IPC(MobileQuality这个字段做区分)
 */
-(void)deviceWithFrameStatus:(int)nLocalChannel withStreamType:(int)nStreamType withIsHomeIPC:(BOOL)isHomeIPC withEffectType:(int)effectType withStorageType:(int)storageType withIsNewHomeIPC:(BOOL)isNewHomeIPC withIsOldStreeamType:(int)nOldStreamType;

@end

@protocol ystNetWorkHelpRemotePlaybackVideoDelegate <NSObject>

@optional

/**
 *  远程回放状态回调
 *
 *  @param remoteplaybackState
 
     enum RemotePlayBackVideoStateType {
     
     RemotePlayBackVideoStateType_Succeed = 100, //远程回放成功
     RemotePlayBackVideoStateType_Stop    = 101, //远程回放停止
     RemotePlayBackVideoStateType_End     = 102, //远程回放结束
     RemotePlayBackVideoStateType_Failed  = 103, //远程回放失败
     RemotePlayBackVideoStateType_TimeOut = 104, //远程回放超时
     };
 */
-(void)remoteplaybackState:(int)remoteplaybackState;

/**
 *  获取远程回放检索文件列表的回调
 *
 *  @param playbackSearchFileListMArray 远程回放检索文件列表
 */
-(void)remoteplaybackSearchFileListInfoCallBack:(NSMutableArray *)playbackSearchFileListMArray;


/**
 *  远程下载文件的回调
 *
 *  @param downLoadStatus 下载的状态 
 
      JVN_RSP_DOWNLOADOVER  //文件下载完毕
      JVN_CMD_DOWNLOADSTOP  //停止文件下载
      JVN_RSP_DOWNLOADE     //文件下载失败
      JVN_RSP_DLTIMEOUT     //文件下载超时
 
 *  @param path           下载保存的路径
 */
-(void)remoteDownLoadCallBack:(int)downLoadStatus withDownloadSavePath:(NSString *)savepath;

@end

@protocol ystNetWorkHelpTextDataDelegate <NSObject>

@optional

/**
 *  文本聊天返回的回调
 *
 *  @param nYstNetWorkHelpTextDataType 文本聊天的状态类型
 *  @param objYstNetWorkHelpSendData   文本聊天返回的内容
 */
-(void)ystNetWorkHelpTextChatCallBack:(int)nLocalChannel withTextDataType:(int)nYstNetWorkHelpTextDataType objYstNetWorkHelpSendData:(id)objYstNetWorkHelpSendData;


@end

@protocol  ystNetWorkHelpVideoDelegate <NSObject>

@optional

/**
 *   录像结束的回调函数
 *
 *  @param isContinue 是否结束后继续录像 YES：继续
 */
-(void)videoEndCallBack:(BOOL)isContinueVideo;

@end

@protocol JVCCloudSEENetworkHelperCaptureDelegate <NSObject>

/**
 *  抓拍图片的委托代理
 *
 *  @param imageData 图片的二进制数据
 */
-(void)captureImageCallBack:(NSData *)imageData;

@end

@interface JVCCloudSEENetworkHelper : NSObject <JVCCloudSEEManagerHelperDelegate>{

    id <ystNetWorkHelpDelegate>                      ystNWHDelegate;     //视频
    id <ystNetWorkHelpRemoteOperationDelegate>       ystNWRODelegate;    //远程请求操作
    id <ystNetWorkAudioDelegate>                     ystNWADelegate;     //音频
    id <ystNetWorkHelpRemotePlaybackVideoDelegate>   ystNWRPVDelegate;   //远程回放
    id <ystNetWorkHelpTextDataDelegate>              ystNWTDDelegate;    //文本聊天
    id <ystNetWorkHelpVideoDelegate>                 videoDelegate;      //录像
    id <JVCCloudSEENetworkHelperCaptureDelegate>     jvcCloudSEENetworkHelperCaptureDelegate; //抓拍
}

enum DEVICETYPE {
    
    DEVICETYPE_HOME  = 2,
    
};

enum DEVICETALKMODEL {
    
    DEVICETALKMODEL_Talk   = 1, // 1:设备播放声音，不采集声音
    DEVICETALKMODEL_Notalk = 0, // 0:设备采集 不播放声音
};

@property(nonatomic,assign)id <ystNetWorkHelpDelegate>                      ystNWHDelegate;
@property(nonatomic,assign)id <ystNetWorkHelpRemoteOperationDelegate>       ystNWRODelegate;
@property(nonatomic,assign)id <ystNetWorkAudioDelegate>                     ystNWADelegate;
@property(nonatomic,assign)id <ystNetWorkHelpRemotePlaybackVideoDelegate>   ystNWRPVDelegate;
@property(nonatomic,assign)id <ystNetWorkHelpTextDataDelegate>              ystNWTDDelegate;
@property(nonatomic,assign)id <ystNetWorkHelpVideoDelegate>                 videoDelegate;
@property(nonatomic,assign)id <JVCCloudSEENetworkHelperCaptureDelegate>     jvcCloudSEENetworkHelperCaptureDelegate; //抓拍

/**
 *  单例
 *
 *  @return 返回JVCCloudSEENetworkHelper 单例
 */
+ (JVCCloudSEENetworkHelper *)shareJVCCloudSEENetworkHelper;

/**
 *  网络获取设备的通道数
 *
 *  @param ystNumber 云视通号
 *  @param nTimeOut  请求超时时间
 *
 *  @return 设备的通道数
 */
-(int)WanGetWithChannelCount:(NSString *)ystNumber nTimeOut:(int)nTimeOut;

/**
 *  检测当前窗口连接是否已存在
 *
 *  @param nLocalChannel nLocalChannel description
 *
 *  @return YES:存在 NO:不存在
 */
-(BOOL)checknLocalChannelExistConnect:(int)nLocalChannel;

/**
 *  检测当前窗口视频是否已经显示
 *
 *  @param nLocalChannel nLocalChannel description
 *
 *  @return YES:存在 NO:不存在
 */
-(BOOL)checknLocalChannelIsDisplayVideo:(int)nLocalChannel;

/**
 *   云视通连接视频的函数 (子线程调用)
 *
 *  @param nLocalChannel  本地连接的通道号 >=1
 *  @param nRemoteChannel 连接设备的通道号
 *  @param strYstNumber   设备的云视通号
 *  @param strUserName    连接设备通道的用户名
 *  @param strPassWord    连接设备通道的密码
 *  @param nSystemVersion 当前手机的操作系统版本
 *  @param isConnectShowVideo 是否显示图像
 *
 *  @return 成功返回YES  重复连接返回NO
 */
-(BOOL)ystConnectVideobyDeviceInfo:(int)nLocalChannel nRemoteChannel:(int)nRemoteChannel strYstNumber:(NSString *)strYstNumber strUserName:(NSString *)strUserName strPassWord:(NSString *)strPassWord nSystemVersion:(int)nSystemVersion isConnectShowVideo:(BOOL)isConnectShowVideo withConnectType:(int)nConnectType;

/**
 *  IP连接视频的函数 (子线程调用)
 *
 *  @param nLocalChannel  本地连接的通道号 >=1
 *  @param strUserName    连接设备通道的用户名
 *  @param strPassWord    连接设备通道的密码
 *  @param strRemoteIP    IP直连的IP地址
 *  @param nRemotePort    IP直连的端口号
 *  @param nSystemVersion 当前手机的操作系统版本
 *  @param isConnectShowVideo 是否显示图像
 *
 *  @return  @return 成功返回YES  重复连接返回NO
 */
-(BOOL)ipConnectVideobyDeviceInfo:(int)nLocalChannel nRemoteChannel:(int)nRemoteChannel  strUserName:(NSString *)strUserName strPassWord:(NSString *)strPassWord strRemoteIP:(NSString *)strRemoteIP nRemotePort:(int)nRemotePort
                   nSystemVersion:(int)nSystemVersion isConnectShowVideo:(BOOL)isConnectShowVideo withConnectType:(int)nConnectType;

/**
 *  断开连接（子线程调用）
 *
 *  @param nLocalChannel 本地视频窗口编号
 *
 *  @return YSE:断开成功 NO:断开失败
 */
-(BOOL)disconnect:(int)nLocalChannel;

/**
 *  远程控制指令(请求)
 *
 *  @param nLocalChannel          视频显示的窗口编号
 *  @param remoteOperationType    控制的类型
 *  @param remoteOperationCommand 控制的命令
 */
-(void)RemoteOperationSendDataToDevice:(int)nLocalChannel remoteOperationType:(int)remoteOperationType remoteOperationCommand:(int)remoteOperationCommand;

/**
 *  远程控制指令
 *
 *  @param nLocalChannel          视频显示的窗口编号
 *  @param remoteOperationCommand 控制的命令
 */
-(void)RemoteOperationSendDataToDevice:(int)nLocalChannel remoteOperationCommand:(int)remoteOperationCommand;

/**
 *  远程控制指令
 *
 *  @param nLocalChannel              视频显示的窗口编号
 *  @param remoteOperationType        控制的类型
 *  @param remoteOperationCommandData 控制的指令内容
 *  @param nRequestCount              请求的次数
 */
-(void)RemoteOperationSendDataToDevice:(int)nLocalChannel remoteOperationType:(int)remoteOperationType remoteOperationCommandData:(char *)remoteOperationCommandData nRequestCount:(int)nRequestCount;

/**
 *  开启录像
 *
 *  @param nLocalChannel      连接的本地通道号
 *  @param saveLocalVideoPath 录像文件存放的地址
 */
-(void)openRecordVideo:(int)nLocalChannel saveLocalVideoPath:(NSString *)saveLocalVideoPath;

/**
 *  关闭本地录像
 *
 *  @param nLocalChannel 本地连接的通道地址
 *  @param isContinue    是否停止后继续录像
 */
-(void)stopRecordVideo:(int)nLocalChannel withIsContinueVideo:(BOOL)isContinue;

/**
 *  远程发送音频数据（对讲）
 *
 *  @param nLocalChannel 视频显示的窗口编号
 *  @param Audiodata     音频数据
 */
-(void)RemoteSendAudioDataToDevice:(int)nLocalChannel Audiodata:(char *)Audiodata nAudiodataSize:(int)nAudiodataSize;

/**
 *  远程回放请求文件视频
 *
 *  @param nLocalChannel            视频显示窗口编号
 *  @param requestPlayBackFileInfo  远程文件的信息
 *  @param requestPlayBackFileDate  远程文件的日期
 *  @param requestPlayBackFileIndex 请求文件的索引
 */
-(void)RemoteRequestSendPlaybackVideo:(int)nLocalChannel requestPlayBackFileInfo:(NSMutableDictionary *)requestPlayBackFileInfo  requestPlayBackFileDate:(NSDate *)requestPlayBackFileDate requestPlayBackFileIndex:(int)requestPlayBackFileIndex;

/**
 *  远程回放请求文件视频
 *
 *  @param nLocalChannel           视频显示窗口编号
 *  @param withPlayBackPath        远程文件的路径
 */
-(void)RemoteRequestSendPlaybackVideo:(int)nLocalChannel withPlayBackPath:(NSString *)playBackVideoPath;

/**
 *  设置有线网络
 *
 *  @param nLocalChannel     本地连接的编号
 *  @param nIsEnableDHCP     是否启用自动获取 1:启用 0:手动输入
 *  ************以下参数手动输入时才生效*********************
 *  @param strIpAddress      ip地址
 *  @param strSubnetMaskIp   子网掩码
 *  @param strDefaultGateway 默认网关
 *  @param strDns            DNS服务器地址
 */
-(void)RemoteSetWiredNetwork:(int)nLocalChannel nIsEnableDHCP:(int)nIsEnableDHCP strIpAddress:(NSString *)strIpAddress strSubnetMask:(NSString *)strSubnetMask strDefaultGateway:(NSString *)strDefaultGateway strDns:(NSString *)strDns;

/**
 *  配置设备的无线网络(老的配置方式)
 *
 *  @param nLocalChannel   本地连接的编号
 *  @param strSSIDName     配置的热点名称
 *  @param strSSIDPassWord 配置的热点密码
 *  @param strWifiAuth     热点的认证方式
 *  @param strWifiEncryp   热点的加密方式
 */
-(void)RemoteOldSetWiFINetwork:(int)nLocalChannel strSSIDName:(NSString *)strSSIDName strSSIDPassWord:(NSString *)strSSIDPassWord strWifiAuth:(NSString *)strWifiAuth strWifiEncrypt:(NSString *)strWifiEncrypt;


/**
 *  配置设备的无线网络(新的配置方式)
 *
 *  @param nLocalChannel   本地连接的编号
 *  @param strSSIDName     配置的热点名称
 *  @param strSSIDPassWord 配置的热点密码
 *  @param nWifiAuth       热点的认证方式
 *  @param nWifiEncryp     热点的加密方式
 */
-(void)RemoteNewSetWiFINetwork:(int)nLocalChannel strSSIDName:(NSString *)strSSIDName strSSIDPassWord:(NSString *)strSSIDPassWord nWifiAuth:(int)nWifiAuth nWifiEncrypt:(int)nWifiEncrypt;

#pragma mark ------ 满帧和全帧的切换 针对所有视频所有视频

/**
 *  远程控制指令 发送所有连接的 全帧和I的切换
 *
 *  @param isOnltIFrame YES:只发I帧
 */
-(void)RemoteOperationSendDataToDeviceWithfullOrOnlyIFrame:(BOOL)isOnltIFrame;

/**
 *  远程下载命令
 *
 *  @param nLocalChannel 视频显示的窗口编号
 *  @param downloadPath  视频下载的地址
 *  @param SavePath      保存的路径
 */
-(void)RemoteDownloadFile:(int)nLocalChannel withDownLoadPath:(char *)downloadPath  withSavePath:(NSString *)SavePath;

/**
 *  返回是否有当前通道的链接状态
 *
 *  @param nLocalChannel Channel号
 *
 *  @return yes 有  no 没有
 */
- (BOOL)returnCurrentLintState:(int)nLocalChannel;

/**
 *  删除门磁和手环报警
 *
 *  @param nLocalChannel 本地连接通道号
 *  @param alarmType     报警的类型
 *  @param alarmGuid     报警的唯一标示
 */
-(void)RemoteDeleteDeviceAlarm:(int)nLocalChannel withAlarmType:(int)alarmType  withAlarmGuid:(int)alarmGuid;

/**
 *  编辑门磁和手环报警
 *
 *  @param nLocalChannel 本地连接通道号
 *  @param alarmType     报警的类型
 *  @param alarmGuid     报警的唯一标示
 *  @param alarmEnable   报警是否开启
 *  @param alarmName     报警的别名
 */
-(void)RemoteEditDeviceAlarm:(int)nLocalChannel withAlarmType:(int)alarmType  withAlarmGuid:(int)alarmGuid withAlarmEnable:(int)alarmEnable withAlarmName:(NSString *)alarmName;

/**
 *  设置安全防护时间段
 *
 *  @param nLocalChannel  本地通道
 *  @param strBeginTime   开始时间
 *  @param strEndTime     结束时间
 */
-(void)RemoteSetAlarmTime:(int)nLocalChannel withstrBeginTime:(NSString *)strBeginTime withStrEndTime:(NSString *)strEndTime; 

@end
