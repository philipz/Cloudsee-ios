//
//  JVCAddLockDeviceViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAddLockDeviceViewController.h"
#import "JVCControlHelper.h"
#import "JVCEditLockDeviceNickNameViewController.h"
#import "JVCAlarmMacro.h"
#import "JVCSystemSoundHelper.h"
#import "JVCAddDevieAlarmViewController.h"
#import "JVCRGBHelper.h"
#import "JVCSystemSoundHelper.h"
@interface JVCAddLockDeviceViewController ()
{
    UIView *helpIView ;
    
    NSTimer *addDeviceTimer;
    
    int     countNum;//计时的
}

@end

@implementation JVCAddLockDeviceViewController
@synthesize addLockDeviceDelegate;
static const  int KAlarmSuccess         = 1;

static const  int  KBtnTagDoor = 100;//门磁的的tag
static const  int  KBtnTagBra  = 101;//手环的tag
static const  int  KBtnTagHand  = 102;//遥控

static const  int  kEdgeOff         = 50;//向下距离
static const int KOriginX           = 40;
static const int KOriginAddHeight   = 30;
static const int KbtnLabel          = 14;
static const int KSizeDefaultWith   = 120;
static const int KSizeDefaultHeight = 100;
static const int KLabelOriginX      = 30;
static const int KLabelOriginY      = 140;
static const int KLabelSize         = 16;
static const NSTimeInterval   KAddDeviceTimerOut         = 15;

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
    
    [self  initContentView];
    
    self.title = LOCALANGER(@"jvc_alarmDevice_title");
}

- (void)BackClick
{
    [self stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWRODelegate  = nil;
    ystNetWorkHelperObj.ystNWTDDelegate  = nil;

    [super dealloc];
}

- (void)initContentView
{
    JVCControlHelper *controlHelper = [JVCControlHelper shareJVCControlHelper];
    UIButton *btn  = [controlHelper buttonWithTitile:LOCALANGER(@"jvc_alarmDevice_door") normalImage:@"arm_dev_dor.png" horverimage:nil];
    btn.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    
    int seperateSize = (self.view.width - 2*btn.width)/3.0;
    btn.frame = CGRectMake(seperateSize, KOriginX, btn.width, btn.height);
    btn.tag = KBtnTagDoor;
    btn.titleLabel.font = [UIFont systemFontOfSize:KbtnLabel];
    [btn addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnBra  = [controlHelper buttonWithTitile:LOCALANGER(@"jvc_alarmDevice_hand") normalImage:@"arm_dev_Bra.png" horverimage:nil];
    btnBra.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    btnBra.frame = CGRectMake(btn.right+seperateSize, btn.top, btn.width, btn.height);
    btnBra.tag = KBtnTagBra;
    btnBra.titleLabel.font = [UIFont systemFontOfSize:KbtnLabel];

    [btnBra addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBra];
    
    UIButton *btnhand  = [controlHelper buttonWithTitile:LOCALANGER(@"jvc_alarmDevice_control")  normalImage:@"arm_dev_hand.png" horverimage:nil];
    btnhand.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    btnhand.frame = CGRectMake(btn.left , btn.bottom+KOriginAddHeight, btn.width, btn.height);
    btnhand.tag = KBtnTagHand;
    btnhand.titleLabel.font = [UIFont systemFontOfSize:KbtnLabel];
    [btnhand addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnhand];

}

- (void)addLockDevice:(UIButton *)btn
{
    int addDeviceType = 1;
    NSString *imageName = nil;
    NSString *voiceString = nil;
    NSString *stringTitile = nil;

    switch (btn.tag) {
        case KBtnTagDoor:
        {
            imageName = @"add_lock_door.png" ;
            voiceString =  LOCALANGER(@"learn_1");
            stringTitile = LOCALANGER(@"jvc_alarmDevice_1");
        }
            break;
        case KBtnTagBra:
        {
            imageName = @"add_lock_Bra.png" ;
            voiceString =  LOCALANGER(@"learn_2");
            stringTitile = LOCALANGER(@"jvc_alarmDevice_2");
            addDeviceType=2;
        }
            break;
            case KBtnTagHand:
        {
            imageName = @"add_lock_Hand.png" ;
            voiceString = LOCALANGER(@"learn_3");
            stringTitile = LOCALANGER(@"jvc_alarmDevice_3");
            addDeviceType=3;
        }
            break;
    }
    
    /**
     *  开启心跳
     */
    [self startTimer];
    
    helpIView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIColor *viewDefaultColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroViewControllerBackGround];
    if (viewDefaultColor) {
        
        helpIView.backgroundColor = viewDefaultColor;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *path = [UIImage imageBundlePath:imageName];
    UIImage *imageHelp = [[UIImage alloc] initWithContentsOfFile:path];
    imageView.image = imageHelp;
    [helpIView addSubview:imageView];
    [self.view.window addSubview:helpIView];
    [helpIView release];
    [imageHelp release];
    [imageView release];
    [self playLearnSound:voiceString];
    
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.lineBreakMode = UILineBreakModeWordWrap;
    labelTitle.font = [UIFont systemFontOfSize:KLabelSize];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.text =  stringTitile;
    labelTitle.numberOfLines = 0;
    UIColor *labelColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroLoginGray];
    if (labelColor) {
        
        labelTitle.textColor = labelColor;
    }

    CGSize sizeContentDefault =  CGSizeMake(KSizeDefaultWith, KSizeDefaultHeight);
    CGSize sizeContent = LABEL_MULTILINE_TEXTSIZE(labelTitle.text, labelTitle.font,sizeContentDefault, labelTitle.lineBreakMode);
    int height= [[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage] == YES?KLabelOriginY:KLabelOriginY -40;
    labelTitle.frame = CGRectMake(KLabelOriginX, height, sizeContent.width, sizeContent.height);
    [helpIView  addSubview:labelTitle];
    [labelTitle release];
    
    UIImageView *imageViewNext = [[JVCControlHelper shareJVCControlHelper] imageViewWithIamge:@"arm_Nex.png"];
    imageViewNext.frame = CGRectMake(labelTitle.right, labelTitle.top, imageViewNext.width, imageViewNext.height);
    [helpIView addSubview:imageViewNext];
    
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWRODelegate                      = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper *netWorkHelper = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        netWorkHelper.ystNWTDDelegate = self;
        
      //  [ystNetWorkHelperObj RemoteDeleteDeviceAlarm:AlarmLockChannelNum withAlarmType:1 withAlarmGuid:8];
        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:AlarmLockChannelNum remoteOperationType:TextChatType_setAlarmType remoteOperationCommand:addDeviceType];
        
        //[ystNetWorkHelperObj RemoteOperationSendDataToDevice:kLocalDeviceChannelNum remoteOperationType:TextChatType_getAlarmType remoteOperationCommand:-1];
        
    });
}

/**
 *  开始心跳
 */
- (void)startTimer
{
    addDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLearnView) userInfo:nil repeats:YES];
}

- (void)removeLearnView
{
    countNum ++;
    if(countNum >=KAddDeviceTimerOut)//超时
    {
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

        [self stopTimer];
        
        [helpIView removeFromSuperview];
        [self stopPlaySound];
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_AddThirdDevie")];
    }
}

/**
 *  停止心跳
 */
- (void)stopTimer
{
  
    countNum = 0;
    
    if(addDeviceTimer !=nil ||[addDeviceTimer isValid])
    {
        [addDeviceTimer invalidate];
        addDeviceTimer = nil;
    }
}

/**
 *  播放扫描背景音乐
 */
-(void)playLearnSound:(NSString *)voiceString{
    
    NSString *soundPath = [[NSBundle mainBundle ] pathForResource:voiceString ofType:@"mp3"];
    
    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] playSound:soundPath withIsRunloop:NO ];
    
}

- (void)stopPlaySound
{
    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] stopSound];

}


/**
 *  文本聊天返回的回调
 *
 *  @param nYstNetWorkHelpTextDataType 文本聊天的状态类型
 *  @param objYstNetWorkHelpSendData   文本聊天返回的内容
 */
-(void)ystNetWorkHelpTextChatCallBack:(int)nLocalChannel withTextDataType:(int)nYstNetWorkHelpTextDataType objYstNetWorkHelpSendData:(id)objYstNetWorkHelpSendData{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [helpIView removeFromSuperview];
        [self stopPlaySound];
        
        [self stopTimer];
        
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

        switch (nYstNetWorkHelpTextDataType) {
            case TextChatType_getAlarmType://获取列表的
                break;
            case TextChatType_setAlarmType://添加报警设备
                
                [self handleTextChatCallback:objYstNetWorkHelpSendData];
                
                break;
            case TextChatType_deleteAlarm://删除报警的
                
                break;
            default:
                break;
        }
    
    });
 
}

- (void)handleTextChatCallback:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *tdic = (NSDictionary *)sender;
        
        int responResult = [[tdic objectForKey:Alarm_Lock_RES] integerValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
      
            switch (responResult) {
                case AlarmLockTypeRes_OK:
                    [self editLockDeviceNickName:tdic];
                    break;
                case AlarmLockTypeRes_Fail:
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmDevice_addError")];
                    break;
                case AlarmLockTypeRes_MaxCount:
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmDevice_addMaxNum")];
                    break;
                case AlarmLockTypeRes_HasAdd:{
                    //根据guid去检索设备
                    [self predicatAddDeviceExist:tdic];
                }
                    break;
                default:
                    break;
            }
                
        });
        
        
    }else{
    
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmDevice_addError")];

    }
}

- (void)predicatAddDeviceExist:(NSDictionary *)dic
{
    int dguid = [[dic objectForKey:Alarm_Lock_Guid] integerValue];

    NSString *nickName = [self getDevicehasExistNickName:dguid];
    if (nickName.length>0) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:[NSString stringWithFormat:@"%@%@",nickName,LOCALANGER(@"jvc_alarmDevice_addhasexist")]];

    }else{
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:[NSString stringWithFormat:@"%@",LOCALANGER(@"jvc_alarmDevice_addhasexist")]];

    }
}

/**
 *  判断设备是否存在
 *
 *  @param nGuid 收到的guid
 *
 *  @return 昵称，可能为空
 */
- (NSString *)getDevicehasExistNickName:(int )nGuid
{
    if ([addLockDeviceDelegate isKindOfClass:[JVCAddDevieAlarmViewController class]]) {
        
        JVCAddDevieAlarmViewController *deviceListVC = (JVCAddDevieAlarmViewController *)addLockDeviceDelegate;
        for (JVCLockAlarmModel *model in deviceListVC.arrayAlarmList) {
            
            if (model.alarmGuid == nGuid) {
                return model.alarmName;
            }
        }
    }
    return nil;
}

- (void)editLockDeviceNickName:(NSDictionary *)dic
{
    int result = [[dic objectForKey:Alarm_Lock_RES] integerValue];
    if (result == KAlarmSuccess) {
        
        if ( addLockDeviceDelegate !=nil && [addLockDeviceDelegate respondsToSelector:@selector(AddLockDeviceSuccessCallBack:)]) {
            [addLockDeviceDelegate AddLockDeviceSuccessCallBack:dic];
        }
//        
//        JVCEditLockDeviceNickNameViewController *editVC = [[JVCEditLockDeviceNickNameViewController alloc] init];
//        [self.navigationController pushViewController:editVC animated:YES];
//        [editVC release];
        
     
    }
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
