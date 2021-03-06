//
//  JVCLocalAddDeviceViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLocalAddDeviceViewController.h"
#import "JVCLocalDeviceDateBaseHelp.h"
#import "JVCChannelScourseHelper.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCConfigModel.h"
#import "JVCLogHelper.h"
#import "JVCLANScanWithSetHelpYSTNOHelper.h"
@interface JVCLocalAddDeviceViewController ()

@end

@implementation JVCLocalAddDeviceViewController
static const int    kAddLocalDeviceWithWlanTimeOut       = 5;   //添加设备从服务器获取通道数的超时时间

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  添加设备，即先把设备绑定到自己的账号中，然后获取设备的详细信息
 *
 */
- (void)addDeviceToAccount:(NSString *)ystNum  deviceUserName:(NSString *) name  passWord:(NSString *)passWord
{
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int  channelCount = [self getSingleDeviceChannelNums:ystNum.uppercaseString];

        channelCount = channelCount <= 0 ? DEFAULTCHANNELCOUNT : channelCount;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            /**
             *  添加设备
             */
            [[JVCLocalDeviceDateBaseHelp shareDataBaseHelper] addLocalDeviceToDataBase:ystNum deviceName:name passWord:passWord];
            //设备添加到设备数组中
            [[JVCDeviceSourceHelper shareDeviceSourceHelper] addLocalDeviceInfo:ystNum
                                                                 deviceUserName:name
                                                                 devicePassWord:passWord];

            //添加通道
            [[JVCChannelScourseHelper shareChannelScourseHelper] addLocalChannelsWithDeviceModel:ystNum channelNums:channelCount];
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_success")];
            
            if (addDeviceDelegate !=nil &&[addDeviceDelegate respondsToSelector:@selector(addDeviceSuccessCallBack)]) {
                
                [addDeviceDelegate addDeviceSuccessCallBack];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    DDLogVerbose(@"%@========%s=",[self class],__FUNCTION__);
    
    [super dealloc];
}

@end
