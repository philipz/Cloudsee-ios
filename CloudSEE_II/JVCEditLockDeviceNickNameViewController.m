//
//  JVCEditLockDeviceNickNameViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCEditLockDeviceNickNameViewController.h"
#import "JVCControlHelper.h"
#import "JVCAlarmMacro.h"
#import "JVCDeviceMacro.h"
@interface JVCEditLockDeviceNickNameViewController ()
{
    UITextField *textField;
}

@end

@implementation JVCEditLockDeviceNickNameViewController

@synthesize alertmodel;

static const  int  KTextFieldOriginY  = 30; //textfield距离左侧的距离
static const  int  KSpan              = 30; //间距
static const  int  KAlarmState        = 1;  //绑定alarm的状态

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
    // Do any additional setup after loading the view.
    
    self.title = LOCALANGER(@"JVCEditLockDeviceNickNameViewController_title");
    [self initContentView];
}

- (void)deallocWithViewDidDisappear
{
    [textField resignFirstResponder];
}

- (void)initContentView
{
    JVCControlHelper *controlHelper = [JVCControlHelper shareJVCControlHelper];
    textField = [controlHelper textFieldWithPlaceHold:LOCALANGER(@"JVCEditLockDeviceNickNameViewController_Nickname") backGroundImage:@"arm_dev_tex.png"];
    textField.frame = CGRectMake((self.view.width -textField.width)/2.0, KTextFieldOriginY, textField.width, textField.height);
    textField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:textField];
    [textField becomeFirstResponder];
    
    UIButton *btn = [controlHelper buttonWithTitile:LOCALANGER(@"JVCEditLockDeviceNickNameViewController_Save") normalImage:@"arm_dev_btn.png" horverimage:nil];
    btn.frame = CGRectMake((self.view.width -btn.width)/2.0 , textField.bottom+KSpan, btn.width, btn.height);
    [btn addTarget:self  action:@selector(finishEditDeviceNick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)finishEditDeviceNick
{
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWRODelegate                      = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper *netWorkHelper = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        netWorkHelper.ystNWTDDelegate = self;
        
        [ystNetWorkHelperObj RemoteEditDeviceAlarm:AlarmLockChannelNum withAlarmType:self.alertmodel.alarmType withAlarmGuid:self.alertmodel.alarmGuid withAlarmEnable:KAlarmState withAlarmName:textField.text];
        
        
    });
    
}

/**
 *  文本聊天返回的回调
 *
 *  @param nYstNetWorkHelpTextDataType 文本聊天的状态类型
 *  @param objYstNetWorkHelpSendData   文本聊天返回的内容
 */
-(void)ystNetWorkHelpTextChatCallBack:(int)nLocalChannel withTextDataType:(int)nYstNetWorkHelpTextDataType objYstNetWorkHelpSendData:(id)objYstNetWorkHelpSendData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
        
        switch (nYstNetWorkHelpTextDataType) {
         
                case TextChatType_editAlarm:
            {
                self.alertmodel.alarmName = textField.text;
                self.alertmodel.alarmState = KAlarmState;
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
        
    });
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>=KNickNameLength) {
        
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [alertmodel release];
    [super dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
