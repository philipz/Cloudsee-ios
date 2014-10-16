//
//  JVCLocalDeviceDateBaseHelp.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCLocalDeviceDateBaseHelp : NSObject

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCLocalDeviceDateBaseHelp *)shareDataBaseHelper;

/**
 *  把数据插入到本地
 */
-(BOOL)addLocalDeviceToDataBase:(NSString *)ystNUm  deviceName:(NSString *)name  passWord:(NSString *)passWord;

/**
 *  删除设备
 */
-(BOOL)deleteLocalDeviceFromDataBase:(NSString *)ystNUm;

/**
 *  删除设备
 */
-(BOOL)updateLocalDeviceInfo:(NSString *)ystNUm
                    NickName:(NSString *)nickName
                  deviceName:(NSString *)deviceName
                    passWord:(NSString *)passWord
                    linkType:(int )linkType
           iscustomLinkModel:(BOOL)linkModel
                        port:(NSString*)port
                          ip:(NSString *)ip;

/**
 *  获取所有的本地设备列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getAllLocalDeviceList;

/**
 *  修改昵称、用户名、密码
 */
-(BOOL)updateLocalDeviceNickName :(NSString *)ystNUm
                         NickName:(NSString *)nickName
                       deviceName:(NSString *)deviceName
                         passWord:(NSString *)passWord
                iscustomLinkModel:(BOOL)linkModel;

/**
 *  修改设备ip 端口号 用户名 密码
 *
 *  @param ystNUm                云视通号
 *  @param deviceName            用户名
 *  @param passWord              密码
 *  @param linkModel             是否被用户修改
 *  @param port                  端口号
 *  @ip                          ip
 *  @return 是否正确
 */
-(BOOL)updateLocalDeviceLickInfoWithYst:(NSString *)ystNUm
                             deviceName:(NSString *)deviceName
                               passWord:(NSString *)passWord
                      iscustomLinkModel:(BOOL)linkModel
                                   port:(NSString*)port
                                     ip:(NSString *)ip;

@end