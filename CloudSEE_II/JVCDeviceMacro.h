//
//  JVCDeviceMacro.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

enum DEVICESERVICERESPONSE{
    
    DEVICESERVICERESPONSE_REQ_TIMEOUT=-5,  //请求业务超时
    DEVICESERVICERESPONSE_ERROR=-1,        //请求失败
    DEVICESERVICERESPONSE_SUCCESS=0,       //请求成功
    DEVICESERVICERESPONSE_RESETFLAG=1,     //设备重置标志
    DEVICE_HAS_EXIST = 8,                  //设备存在
    DEVICE_NOT_EXIST = 9,                  //设备非法
    DEVICE_NOT_BIND = 10,
    DEVICE_HIS_NOT_EXIST = 11,
    DEVICE_HUMITURE_NOT_EXIST = 12,
    DEVICE_CONF_NOT_SET = 13,
    DEVICE_HAS_NO_UPDATE = 14,            //设备正在升级状态
    DEVICE_VERIFY_ERROR = -13,            //设备校验失败
    DEVICE_NOT_ONLINE = -14,              //设备不在线
    DEVICE_UPDATE_ERROR=-12,              //设备升级出错
    
};



#define TOKEN_LENGTH			5
#define TOKEN_STR				"@#1$6"

/* JK(JSON KEY) */
#define PROTO_VERSION			"1.0"
#define JK_MESSAGE_ID			"mid"
#define JK_MESSAGE_TYPE 		"mt"
#define JK_PROTO_VERSION		"pv"
#define JK_LOGIC_PROCESS_TYPE   "lpt"
#define JK_RESULT    			"rt"
#define JK_CLINET_SFD			"cfd"
#define JK_CLINET_SFD_ID		"cfdid"

#define JK_SESSION_ID			"sid"、

#define JK_ALARM_INDEX_START		"aistart"

#define JK_ALARM_INDEX_STOP			"aistop"

#define JK_USERNAME				"username"
#define JK_PASSWORD				"password"
#define JK_NEW_PASSWORD			"newpass"
#define JK_PEER_USERNAME		"pusername"
#define JK_USER_OTHER_INFO      "uoi"
#define JK_SECURITY_MAIL		"sm"
#define JK_CLIENT_PLATFORM		"cp"

#define JK_USER_ONLINE_STATUS   "uls"

#define JK_IM_SERVER_NO         "isn"
#define JK_RELAY_MESSAGE        "rm"
#define JK_RELAY_MESSAGE_GUID   "rmg"
#define JK_RELAY_MESSAGE_TIMESTAMP "rmt"


#define JK_IM_RELAY_TYPE        "rlt"

#define JK_ONLINE_SERVER_NO		"osn"
#define JK_ONLINE_SERVER_FD		"osf"
#define JK_ONLINE_SERVER_FD_ID	"osfi"

#define JK_CREATE_TIME			"ct"


#define JK_PUSH_MESSAGE_TYPE	"pmt"


/* 设备服务相关 */
#define JK_DEVICES_CHANGE       "dc"
#define JK_DEVICE_LIST			"dlist"
#define JK_DEVICE_INFO			"dinfo"
#define JK_DEVICE_GUID			"dguid"
#define JK_DEVICE_TYPE			"dtype"
#define JK_DEVICE_USERNAME		"dusername"
#define JK_DEVICE_PASSWORD		"dpassword"
#define JK_DEVICE_NAME			"dname"
#define JK_DEVICE_IP			"dip"
#define JK_DEVICE_PORT			"dport"
#define JK_DEVICE_NET_STATE		"dnst"
#define JK_NET_STORAGE_SWITCH	"netss"
#define JK_TF_STORAGE_SWITCH	"tfss"
#define JK_ALARM_SWITCH			"aswitch"
#define JK_ALARM_VIDEO_FTP		"avftp"
#define JK_ALARM_SNAP_FTP		"asnapftp"
#define JK_ALARM_FTP_ACC		"aftpacc"
#define JK_ALARM_FTP_PWD		"aftppwd"
#define JK_ALARM_TIME			"atime"
#define JK_PIC_FTP_BIG			"dpicb"
#define JK_PIC_FTP_SMALL		"dpics"
#define JK_PIC_FTP_ACC			"dpicacc"
#define JK_PIC_FTP_PWD			"dpicpwd"
#define JK_PIC_UPLOAD_TIMEING	"dpicut"
#define JK_VIDEO_FLUENCY		"dvfluency"
#define JK_VIDEO_LINK_TYPE		"dvlt"  // 0 云通 1:IP
#define JK_DEVICE_VIDEO_USERNAME	"dvusername"
#define JK_DEVICE_VIDEO_PASSWORD	"dvpassword"
#define JK_DEVICE_VIDEO_IP		"dvip"
#define JK_DEVICE_VIDEO_PORT	"dvport"

#define JK_DEVICE_TEMPERATURE	"dtem"
#define JK_DEVICE_HUMIDNESS		"dhum"

#define JK_DEVICES_ONLINE_STATUS	"dsls"
#define JK_ONLINE_STATUS			"ols"

#define JK_DEVICES_PIC			    "dspic"


#define JK_DEVICE_TEMPERATURE		"dtem"
#define JK_DEVICE_HUMIDNESS			"dhum"
#define JK_DEVICE_TIMESTAMP			"dts"
#define JK_DEVICE_HUMITURE_LIST		"dhlist"
#define JK_DEVICE_HUMITURE_DATE		"dhdate"
#define JK_DEVICE_HUMITURE_HOUR		"dhour"
#define JK_DEVICE_HUMITURE_NUM		"dhnum"

#define JK_DEVICE_HUMITURE_SCORE    "dhscore"
#define JK_DEVICE_HUMITURE_TOP      "dhtop"
#define JK_DEVICE_HUMITURE_RATIO    "dhratio"

#define JK_DEVICE_ENV_SCORE         "descore"	// 综合环境健康指数评分
#define JK_DEVICE_HUMITURE_ASSESSMENT    "dhass"

#define JK_DEVICE_SOFT_VERSION    "dsv"
#define JK_DEVICE_BABY_MODE        "dbbm"   //baby模式
#define JK_DEVICE_FULL_ALARM_MODE    "dfam" //全监控模式

#define JK_DEVICE_SUB_TYPE        "dstype"

#define JK_NET_STORAGE_SWITCH_RESULT       "netssrs"
#define JK_TF_STORAGE_SWITCH_RESULT        "tfssrs"
#define JK_ALARM_SWITCH_RESULT             "aswitchrs"
#define JK_ALARM_VIDEO_FTP_RESULT          "avftprs"
#define JK_ALARM_SNAP_FTP_RESULT           "asnapftprs"
#define JK_ALARM_FTP_ACC_RESULT            "aftpaccrs"
#define JK_ALARM_FTP_PWD_RESULT            "aftppwdrs"
#define JK_ALARM_TIME_RESULT               "atimers"
#define JK_PIC_FTP_BIG_RESULT              "dpicbrs"
#define JK_PIC_FTP_SMALL_RESULT            "dpicsrs"
#define JK_PIC_FTP_ACC_RESULT              "dpicaccrs"
#define JK_PIC_FTP_PWD_RESULT              "dpicpwdrs"
#define JK_PIC_UPLOAD_TIMEING_RESULT       "dpicutrs"
#define JK_VIDEO_FLUENCY_RESULT            "dvfluencyrs"


//设备升级
#define JK_UPGRADE_FILE_VERSION     "ufver"
#define JK_UPGRADE_FILE_URL         "ufurl"
#define JK_UPGRADE_FILE_DESCRIPTION "ufdes"
#define JK_UPGRADE_FILE_SIZE        "ufsize"
#define JK_UPGRADE_FILE_CHECKSUM	"ufc"
#define JK_UPGRADE_DOWNLOAD_STEP    "udstep"
#define JK_UPGRADE_WRITE_STEP       "uwstep"
#define JK_DEVICE_SUB_TYPE_INT	    "dstypeint"
#define JK_UPDATE_FILE_INFO		"ufi"


#define JK_DEVICE_RESET_FLAG "drf"
#define JK_DEVICE_VERIFY     "dverify"

//通道字段的定义
#define JK_DEVICE_CHANNEL_SUM	    "dcs"
#define JK_DEVICE_CHANNEL_NO	    "dcn"
#define JK_CHANNEL_LIST			    "clist"
#define JK_DEVICE_CHANNEL_NAME		"dcname"
#define JK_DEVICE_Demo_CHANNEL_SUM	    @"dcs"

//设备新增属性字段

#define JK_DEVICE_WIFI_FLAG  "dwifi"


#define DEVICE_JSON_RT              @"rt"
#define DEVICE_JSON_DINFO           @"dinfo"

#define DEVICE_JSON_DVPASSWORD      @"dvpassword"
#define DEVICE_JSON_DVUSERNAME      @"dvusername"
#define DEVICE_JSON_DGUID           @"dguid"
#define DEVICE_JSON_DLIST           @"dlist"
#define DEVICE_JSON_NICKNAME        @"dname"
#define DEVICE_JSON_PORT            @"dvport"
#define DEVICE_JSON_IP              @"dvip"
#define DEVICE_JSON_LINKTYPE        @"dvlt"
#define DEVICE_JSON_TYPE			@"dtype"
#define DEVICE_JSON_ALARMSWITCH     @"aswitch"


#define DEVICE_JSON_ONLINESTATE     @"dsls"//在线状态
#define DEVICE_JSON_WIFI            @"dwifi"//wifi标志

#define DEVICE_CHANNEL_JSON_NAME     @"dcname"//通道名称
#define DEVICE_CHANNEL_JSON_LIST     @"clist" //通道列表
#define DEVICE_CHANNEL_JSON_NUMBER   @"dcn" //通道编号

#define DEVICE_ONLINE_STATUS         @"dsls"
#define DEVICE_DEVICE_RELATION_NUM    @"drn"

#define JK_DEVICE_Demo_USERNAME		@"dusername"
#define JK_DEVICE_Demo_PASSWORD		@"dpassword"
#define DEVICE_DEVICE_ServiceState  @"dimols"
#define JK_DEVICES_CHANNELS         @"clist"

/**
 *  ap 的密码
 *
 */
#define AP_USER       @"jwifiApuser"
#define AP_PASSWORLD  @"^!^@#&1a**U"

/** Message Type */
enum MessageType
{
	IS_USER_EXIST = 997,
	IS_USER_EXIST_RESPONSE = 998,
    
	USER_REGISTER = 999,
	USER_REGISTER_RESPONSE = 1000,
    
	LOGIN = 1001,
	LOGIN_RESPONSE = 1002,
    
	LOGOUT = 1003,
	LOGOUT_RESPONSE = 1004,
    
	MODIFY_USERPASS = 1073,
	MODIFY_USERPASS_RESPONSE = 1074,
    
	RESET_PASSWORD = 1085,
	RESET_PASSWORD_RESPONSE = 1086,
    
	/** 上线服务 */
	USER_ONLINE = 1201,
	USER_ONLINE_RESPONSE = 1202,
    
	GET_LIVE_STATUS = 1301,
	GET_LIVE_STATUS_RESPONSE = 1302,
    
	SET_ONLINE_STATUS = 1221,
	SET_ONLINE_STATUS_RESPONSE = 1222,
    
	SEND_RESET_PASSWORD_MAIL = 1083,
	SEND_RESET_PASSWORD_MAIL_RESPONSE = 1084,
    
	RELAY_REQUEST = 3001,
    
	NOTIFY_OFFLINE = 3102,
	RELAY_NOTIFY_OFFLINE = 3103,
    
	REG_MAIL = 3301,
	REG_MAIL_RESPONSE = 3302,
    
    PUSH_DEVICE_MODIFY_INFO = 3006,
	PUSH_DEVICE_MODIFY_INFO_RESPONSE = 3007,
    
    PUSH_DEVICE_UPDATE_CMD = 3012,
	PUSH_DEVICE_UPDATE_CMD_RESPONSE = 3013,
    
	PUSH_DEVICE_CANCEL_CMD = 3014,
	PUSH_DEVICE_CANCEL_CMD_RESPONSE = 3015,
    
	GET_UPDATE_DOWNLOAD_STEP = 3016,
	GET_UPDATE_DOWNLOAD_STEP_RESPONSE = 3017,
    
	GET_UPDATE_WRITE_STEP = 3018,
	GET_UPDATE_WRITE_STEP_RESPONSE = 3019,
    
	PUSH_DEVICE_REBOOT_CMD = 3020,
	PUSH_DEVICE_REBOOT_CMD_RESPONSE = 3021,
    PUSH_DEVICE_MODIFY_PASSWORD=3022,
    PUSH_DEVICE_MODIFY_PASSWORD_RESPONSE=3023,
    
    
    
};


/** 设备基础信息服务 */
enum MessageType_DeviceInfo
{
	DEVICE_REGISTER = 2001,
	DEVICE_REGISTER_RESPONSE = 2002,
    
	GET_USER_DEVICES = 2003,
	GET_USER_DEVICES_RESPONSE = 2004,
    
	GET_DEVICE_INFO = 2005,
	GET_DEVICE_INFO_RESPONSE = 2006,
    
	MODIFY_DEVICE_INFO = 2007,
	MODIFY_DEVICE_INFO_RESPONSE = 2008,
    
	GET_DEVICE_ONLINE_STATE = 2009,
	GET_DEVICE_ONLINE_STATE_RESPONSE = 2010,
    
	GET_DEVICE_PIC = 2011,
	GET_DEVICE_PIC_RESPONSE = 2012,
    
	MODIFY_DEVICE_INFO_VIDEO_LINK = 2013,
	MODIFY_DEVICE_INFO_VIDEO_LINK_RESPONSE = 2014,
    
	USER_BIND_DEVICE = 2015,
	USER_BIND_DEVICE_RESPONSE = 2016,
    
	USER_REMOVE_BIND_DEVICE = 2017,
	USER_REMOVE_BIND_DEVICE_RESPONSE = 2018,
    
    GET_USER_DEVICE_INFO = 2019,
	GET_USER_DEVICE_INFO_RESPONSE = 2020,
    
    GET_DEVICE_HUMITURE_STAT = 2021,
    GET_DEVICE_HUMITURE_STAT_RESPONSE = 2022,
    
    GET_DEVICE_HUMITURE_ONTIME = 2023,
	GET_DEVICE_HUMITURE_ONTIME_RESPONSE = 2024,
    
	GET_USER_DEVICES_STATUS_INFO = 2025,
	GET_USER_DEVICES_STATUS_INFO_RESPONSE = 2026,
    
	GET_DEVICE_HUMITURE_SCORE = 2027,
	GET_DEVICE_HUMITURE_SCORE_RESPONSE = 2028,
    
    MODIFY_DEVICE_INFO_ADVANCED = 2031,
    MODIFY_DEVICE_INFO_ADVANCED_RESPONSE = 2032,
    
    GET_DEVICE_UPDATE_INFO = 2033,
	GET_DEVICE_UPDATE_INFO_RESPONSE = 2034,
    
    MODIFY_DEVICE_PASSWORD = 2035,
    MODIFY_DEVICE_PASSWORD_RESPONSE = 2036,
    
    ADD_DEVICE_CHANNEL = 2039,
    ADD_DEVICE_CHANNEL_RESPONSE = 2040,
    
    DELETE_DEVICE_CHANNEL = 2041,
    DELETE_DEVICE_CHANNEL_RESPONSE = 2042,
    
    GET_DEVICE_CHANNEL = 2043,
    GET_DEVICE_CHANNEL_RESPONSE = 2044,
    
    MODIFY_DEVICE_CHANNEL_NAME          = 2045,
    MODIFY_DEVICE_CHANNEL_NAME_RESPONSE = 2046,
    
    MODIFY_DEVICE_WIFI_FLAG          = 2047,
    MODIFY_DEVICE_WIFI_FLAG_RESPONSE = 2048,
    
    GET_USER_CHANNELS                = 2049,
	GET_USER_CHANNELS_RESPONSE       = 2050,
    
    GET_DEVICE_Info_stateAndBing     = 2051,
    GET_DEMO_LIST                    = 2057,

    
    
};
/** 设备在线服务 */
enum MessageType_DeviceOnline
{
	DEVICE_ONLINE = 2201,
	DEVICE_ONLINE_RESPONSE = 2202,
    
	DEVICE_HEARTBEAT = 2203,
	DEVICE_HEARTBEAT_RESPONSE = 2204,
    
	DEVICE_OFFLINE = 2205,
	DEVICE_OFFLINE_RESPONSE = 2206,
    
    DEVICE_ONLINE_MID = 42,
    
};


enum CONNECTTYPE{
    
    CONNECTTYPE_YST=0,
    CONNECTTYPE_IP=1,
    
};

enum TcpConnectFlag
{
	SHORT_CONNECTION,
	PERSIST_CONNECTION,
};

enum LogicProcessNo
{
	ACCOUNT_BUSINESS_PROCESS = 0,
	DEV_INFO_PRO = 1,
    
	IM_SERVER_DIRECT = 6,
	IM_SERVER_RELAY = 7,
	IM_SERVER_RELAY_REQUEST = 8,
	IM_DEV_DIRECT = 9,
    
    IM_DEV_RESETSTATE = 99,

    
};

enum DEVICESTATUS{
    
    DEVICESTATUS_OFFLINE=0,
    DEVICESTATUS_ONLINE=1
    
};

/**
 *  获取demo的的类别
 */
static const  NSString *AppDemoType = @"CloudSEE";
#define JK_CUSTOM_TYPE              "custom_type"
static const int    KNickNameLength             = 20;
