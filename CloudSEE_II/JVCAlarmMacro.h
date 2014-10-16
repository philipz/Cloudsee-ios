//
//  JVCAlarmMacro.h
//  CloudSEE_II
//  报警的宏定义
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#define JK_ALARM_MID				@"mid"
#define JK_ALARM_ACCOUNT			@"accountname"
#define JK_ALARM_GUID				@"alarmguid"
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

static const int  JK_ALARM_LISTCOUNT =  4;//每次请求报警数据的个数


/* 报警类型 */
typedef enum alarmtype
{
	ALARM_DISKERROR,
    ALARM_DISKFULL,
    ALARM_DISCONN,
    ALARM_UPGRADE,
    ALARM_GPIN,
    ALARM_VIDEOLOSE,
    ALARM_HIDEDETECT,
    ALARM_MOTIONDETECT,			/* 移动侦测 */
    ALARM_POWER_OFF,
    ALARM_MANUALALARM,
    ALARM_GPS,
    ALARM_PIR,                    /*pir红外人体检测*/
    ALARM_NONE,
    ALARM_NOTIFY,
    ALARM_TEMP_HIGH,
    ALARM_TEMP_LOW,
    ALARM_HUM_HIGH,
    ALARM_HUM_LOW,
    ALARM_TEMP_HIGH_HUM_HIGH,
    ALARM_TEMP_HIGH_HUM_LOW,
    ALARM_TEMP_LOW_HUM_HIGH,
    ALARM_TEMP_LOW_HUM_LOW,
    //    ALARM_TEMP_HIGH=16,
    //    ALARM_TEMP_LOW=32,
    //    ALARM_HUM_HIGH=64,
    //    ALARM_HUM_LOW=128,
    //
    //    ALARM_tH__hH=80,  //温度过高、湿度过高
    //    ALARM_tl_hH=96,   //温度过低、湿度过高
    //    ALARM_tH__hl=144, //温度过高、湿度过低
    //    ALARM_tl_hl=160,  //温度过低、湿度过低
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
