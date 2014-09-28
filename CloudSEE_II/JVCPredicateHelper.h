//
//  JVCPredicateHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  添加设备的时候的返回值
 */
enum ADDDEVICERESULT
{
    ADDDEVICE_SUCCESS=0,//成功
    
    ADDDEVICE_YST_NIL,//云视通号为空
    ADDDEVICE_YST_ERROR,//云视通号不合法
    
    ADDDEVICE_USER_NIL,//用户名为空
    ADDDEVICE_USER_ERROR,//用户名不合法
    
    ADDDEVICE_PASSWORD_NIL,//密码为空
    ADDDEVICE_PASSWORD_ERROR,//密码不合法
    
};




@interface JVCPredicateHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCPredicateHelper的单例
 */
+ (JVCPredicateHelper *)shareInstance;

/**
 *  判断字符串是否为空
 *
 *  @param string 传入的字符串
 *
 *  @return yes 为空  no：不为空
 */
- (BOOL)predicateBlankString:(NSString *)string;

/**
 *  判断云视通是否合法
 *
 *  @param ystNum 云视通号码
 *
 *  @return yes：合法  no：非法
 */
-(BOOL)predicateYSTIsLegal:(NSString *)ystNum;

/**
 *  判断添加设备的云视通号、用户名、密码是否合法
 *
 *  @param YSTNum   云视通号
 *  @param userName 用户名
 *  @param passWord 密码
 *
 *备注：添加设备的设备的密码可以为空，为了与修改设备逻辑不一样，这里密码可以为空
 *  @return 判断结果  0：成功 1：云视通号为空 2：云视通号不合法  3：用户名不为空 4：用户名不合法 5：密码为空 6：密码不合法
 */
- (int)addDevicePredicateYSTNUM:(NSString *)YSTNum  andUserName:(NSString *)userName  andPassWord:(NSString *)passWord;

/**
 *  判断添加设备的云视通号、用户名、密码是否合法
 *
 *  @param YSTNum   云视通号
 *  @param userName 用户名
 *  @param passWord 密码
 *
 *备注：添加设备的设备的密码可以为空，为了与修改设备逻辑不一样，这里密码可以为空
 *  @return 判断结果  0：成功 1：云视通号为空 2：云视通号不合法  3：用户名不为空 4：用户名不合法 5：密码为空 6：密码不合法
 */
- (int)addDeviceToAccountPredicateYSTNUM:(NSString *)YSTNum;

/**
 *	判断用户名是否合法
 *
 *	@param	accountName	校验的用户名
 *  思路：新判断是否是手机号 ，然后判断是否是邮箱（先判断字符串中是否有@） 然后再判断是否是用户名
 *
 *	@return	VALIDATIONUSERNAMETYPE_S=0,          //校验通过
 VALIDATIONUSERNAMETYPE_LENGTH_E=-1,  //用户名长度只能在4-28位字符之间；
 VALIDATIONUSERNAMETYPE_NUMBER_E=-2,//用户名不能全为数字
 VALIDATIONUSERNAMETYPE_OTHER_E=-3, //用户名只能由中文、英文、数字及“_”、“-”组成
 VALIDATIONUSERNAMETYPE_EMAIL_E = -5,//邮箱格式不正确
 */
-(int)predicateUserNameIslegal:(NSString *)accountName;

/**
 *	判断注册界面密码是否合法
 *
 *	@param	passwordStr	验证的密码 密码可以6到20位字符数字或符号的组合
 *
 *	@return	YES 符合 NO 非法
 */
-(BOOL)PredicateResignPasswordIslegal:(NSString *)passwordStr;

/**
 *  检测注册用户名、密码、确认密码、邮箱是否合法
 *
 *  @param userName       用户名
 *  @param passWord       密码
 *  @param enSurePassWord 确认密码
 *  @param email          邮箱
 *
 *  @return 返回相应的枚举字段
 */
- (int)predicatUserResignWithUser:(NSString *)userName
                      andPassWord:(NSString *)passWord
                andEnsurePassWord:(NSString *)enSurePassWord;

@end