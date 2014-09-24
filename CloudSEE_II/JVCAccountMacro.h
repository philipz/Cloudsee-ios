//
//  JVCAccountMacro.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#ifndef CloudSEE_II_JVCAccountMacro_h
#define CloudSEE_II_JVCAccountMacro_h

/**
 * @brief   用户基本信息
 */

typedef struct c_userInfo_
{
    char username[20];
    char security_mail[30];
    //...
}C_USER_INFO;


enum languageType
{
	CHINESE = 0,
	ENGLISH = 1,
};

enum CommonStatus
{
	UNKNOWN = -1,
};

typedef struct c_clientLoginInfo_
{
    int terminal_type;		//登录平台类型
    int	language_type;		//语言类型
    char moblie_id[80];	//手机唯一识别符
    
}C_CLIENT_INFO;


typedef struct c_ServerPushInfo
{
    char username[20];			//加强验证，防止串话
    char send_timestamp[20];
    char message[500];
    
}c_SERVER_PUSH_INFO;

enum platformType
{
	ANDROID_CLIENT = 1,
	IPHONE_CLIENT  = 2,
	IPAD_CLIENT	   = 3,
};

#define STR_PTCP_HAS_CLOSED "TCP_CLOSED"
#define STR_PTCP_HAS_ERROR	"TCP_ERROR"



enum OnlineStatus
{
    OFFLINE = 0,
    ONLINE,
    LEAVING,
    HIDING,
};

enum IReturnCode
{
    SUCCESS = 0,
    
	USER_HAS_EXIST			= 2,						//用户已经存在
	USER_NOT_EXIST			= 3,						//用户不存在
	PASSWORD_ERROR			= 4,						//密码错误
	SESSION_NOT_EXSIT		= 5,						//登录session不存在（登录已过期）
	SQL_NOT_FIND			= 6,
	PTCP_HAS_CLOSED			= 7,						//断开与服务器的连接
    
	LOW_STRENGTH_PASSWORD	= 118,						//低强度密码用户
	HIGH_STRENGTH_PASSWORD	= 119,						//高强度密码用户
    
	GENERATE_PASS_ERROR 	= -2,
	REDIS_OPT_ERROR			= -3,						//内部服务器错误
	MY_SQL_ERROR			= -4,						//内部服务器错误
	REQ_RES_TIMEOUT			= -5,						//请求超时
	CONN_OTHER_ERROR		= -6,						//连接服务器错误
	CANT_CONNECT_SERVER 	= -7,						//无法连接无服务器
	JSON_INVALID			= -8,						//数据不合法
	REQ_RES_OTHER_ERROR 	= -9,						//请求错误
	JSON_PARSE_ERROR		= -10,						//数据不合法
	SEND_MAIL_FAILED		= -11,
	ACCOUNTNAME_OTHER 		= -16,						//已注册不符合规则注册的用户（老用户）
	PASSWORD_DANGER 		= -17,						//用户密码级别太低
	OTHER_ERROR				= -1000,
};

enum alarmflag
{
    ALARM_ON  = 0,
    ALARM_OFF = 1,
};

#endif