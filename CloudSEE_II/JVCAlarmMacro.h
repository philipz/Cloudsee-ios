//
//  JVCAlarmMacro.h
//  CloudSEE_II
//  报警的宏定义
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#define JK_ALARM_MID				@"mid"
#define JK_ALARM_ACCOUNT			@"accountname"
#define JK_ALARM_CLOUDNUM			@"cloudnum"
#define JK_ALARM_CLOUDCHN			@"cloudchn"
#define JK_ALARM_ALARMTYPE			@"alarmtype"
#define JK_ALARM_ALARMLEVEL		    @"alarmlevel"
#define JK_ALARM_ALARMTIME			@"alarmtime"
#define JK_ALARM_PICURL				@"picurl"
#define JK_ALARM_VIDEOURL			@"videourl"
#define JK_ALARM_SEARCHINDEX		@"index"
#define JK_ALARM_SEARCHCOUNT		@"count"
#define JK_ALARM_OPTFLAG			@"flag"
#define JK_ALARM_LIST				@"list"
#define JK_ALARM_CLOUDNAME			@"cloudname"

// 设备报警
#define JK_ALARM_GUID			@"aguid"
#define JK_ALARM_SOLUTION		@"asln"
#define JK_ALARM_MESSAGE_TYPE	@"amt"
#define JK_ALARM_STATUS			@"astatus"
#define JK_ALARM_TYPE			@"atype"
#define JK_ALARM_PIC			@"apic"
#define JK_ALARM_PIC_SIZE		@"apicsz"
#define JK_ALARM_VIDEO			@"avd"
#define JK_ALARM_VIDEO_SZIE		@"avdsz"
#define JK_ALARM_MESSAGE		@"amsg"
#define JK_ALARM_TIMESTAMP		@"ats"

// 设备报警
#define JK_ALARM_GUID			@"aguid"
#define JK_ALARM_SOLUTION		@"asln"
#define JK_ALARM_MESSAGE_TYPE	@"amt"
#define JK_ALARM_STATUS			@"astatus"
#define JK_ALARM_TYPE			@"atype"
#define JK_ALARM_PIC			@"apic"
#define JK_ALARM_PIC_SIZE		@"apicsz"
#define JK_ALARM_VIDEO			@"avd"
#define JK_ALARM_VIDEO_SZIE		@"avdsz"
#define JK_ALARM_MESSAGE		@"amsg"
#define JK_ALARM_TIMESTAMP		@"ats"
#define JK_ALARM_NEWTIMESTAMP   @"atss"
#define JK_ALARM_INFO			@"ainfo"
#define JK_ALARM_FTP_CHANNEL_NO	 @"dcn"
#define JK_ALARM_FTP_DEVICE_GUID @"dguid"
#define JK_ALARM_DEVICE_NAME     @"dname"

static const NSString *Alarm_Lock_Guid  = @"guid";//报警的guid
static const NSString *Alarm_Lock_Enable  = @"enable";//报警的enable
static const NSString *Alarm_Lock_Name  = @"name";//报警的name
static const NSString *Alarm_Lock_Type  = @"type";//报警的type
static const NSString *Alarm_Lock_RES  = @"res";//报警的res

typedef NS_ENUM(NSUInteger, AlarmLockTypeRes) {
    AlarmLockTypeRes_OK         = 1,
    AlarmLockTypeRes_Fail       = 0,
    AlarmLockTypeRes_MaxCount   = 2,
    AlarmLockTypeRes_HasAdd     = 3,//添加

};


static const int  JK_ALARM_LISTCOUNT =  4;//每次请求报警数据的个数
static const int  ALARM_INFO_PROCESS =  11;//新版报警字段
enum {
    JK_ALARM_MESSAGE_TYPE_Get   = 6000,//获取报警的

    JK_ALARM_MESSAGE_TYPE_Delete = 6002,//删除报警的
    
    JK_ALARM_MESSAGE_TYPE_Clear = 6004,//清空报警的

};
/* 报警类型 */
typedef enum alarmtype
{
    ALARM_DISKERROR,
	ALARM_DISKFULL,
	ALARM_DISCONN,
	ALARM_UPGRADE,
	ALARM_GPIN,
	ALARM_VIDEOLOSE,     // 视频丢失
	ALARM_HIDEDETECT,    // 视频遮挡
	ALARM_MOTIONDETECT,  // 移动侦测
	ALARM_POWER_OFF,
	ALARM_MANUALALARM,
	ALARM_GPS,
	ALARM_DOOR,
	ALARM_TOTAL
    
} alarmtype_t;

/* 报警服务器的消息类型 */
typedef enum alarm_client_messageid
{
	MID_RESPONSE_PUSHALARM			= 1000,			/* 告警服务器向客户端推送报警信息 */
	MID_REQUEST_ALARMPICURL			= 1001,		/* 客户端获取报警图片的url地址 */
	MID_RESPONSE_ALARMPICURL		= 1002,		/* 服务器向客户端发送报警图片的url地址 */
	MID_REQUEST_ALARMVIDEOURL		= 1003,		/* 客户端获取报警视频的url地址 */
	MID_RESPONSE_ALARMVIDEOURL		= 1004,		/* 服务器向客户端发送报警视频的url地址 */
	MID_REQUEST_ALARMHISTORY		= 1005,		/* 客户端获取报警的历史记录 */
	MID_RESPONSE_ALARMHISTORY		= 1006,		/* 服务器向客户端发送报警的历史记录 */
	MID_REQUEST_REMOVEALARM			= 1007,		/* 客户端发送删除报警信息 */
	MID_RESPONSE_REMOVEALARM		= 1008		/* 服务器向客户端发发送删除报警信息的结果 */
} alarm_client_messageid_t;


typedef NS_ENUM(NSUInteger, AlarmLockChannel) {
    AlarmLockChannelNum = 1,
  
};