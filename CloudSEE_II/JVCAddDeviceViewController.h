//
//  JVCAddDeviceViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

enum DEVICE_INFO {
    
    DEVICE_E      = -1,
    DEVICE_R      = 0,
    DEVICE_RESET  = 1,
};


enum BINDING
{
    DEVICE_BINGING_NO  = 0,//没有绑定
};

enum DEVICEBIND
{
    DEVICEBIND_SUCCESS = 0,//成功
    
};

@interface JVCAddDeviceViewController : UIViewController

@end