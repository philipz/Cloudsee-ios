//
//  JVCLoginViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLoginViewController.h"
#import "JVCSystemUtility.h"
#import "JVCAccountHelper.h"
#import "JVCAccountPredicateMaths.h"
#import "JVCAccountMacro.h"
#import "JVCDeviceListViewController.h"
#import "AppDelegate.h"
#import "JVCResultTipsHelper.h"
#import "JVCDataBaseHelper.h"
#import "JVCRGBHelper.h"
#import "JVCUserInfoModel.h"
#import "JVCPredicateHelper.h"
#import "JVCConfigModel.h"
#import "JVCSystemConfigMacro.h"
#import "JVCDemoViewController.h"
#import "JVCAlarmCurrentView.h"
#import "JVCControlHelper.h"
#import "JVCAppHelper.h"

#import <AudioToolbox/AudioToolbox.h>
#import "JVCApConfigPlayVideoViewController.h"
#import "JVCAPConfigPlayVideoIphone4ViewController.h"

enum LOGINBTNTYPE
{
    LOGINBTNGTYPE_LOGININ   = 0,//登录
    LOGINBTNGTYPE_RESIGN    = 1,//注册
    LOGINBTNGTYPE_Demo      = 2,//演示点
    LOGINBTNGTYPE_Local     = 3,//访客登录
};

enum LOGINVIEWTAG
{
    LOGINVIEWTAG_Login      = 100,//登录按钮的tag
    LOGINVIEWTAG_Demo       = 101,//演示点的tag
    LOGINVIEWTAG_Resign     = 102,//注册的tag
    LOGINVIEWTAG_Local      = 103,//本地登录的tag
    LOGINVIEWTAG_Down       = 104,//多张号时的三角按钮的tag
    LOGINVIEWTAG_Line       = 106,//账号下面横杆的tag
};

@interface JVCLoginViewController ()
{
    /**
     *  用户名的textfield
     */
    UITextField     *textFieldUser ;
    /**
     *  密码的textfield
     */
    UITextField     *textFieldPW;
    JVCDropDownView *dropDownView;//下拉view
    SystemSoundID    shake_sound_finish;
    

}

@end

@implementation JVCLoginViewController

static const double         KAfterDalayTimer                     = 0.3;  //延迟0.3秒登录
static const NSTimeInterval KAmationTimer                        = 0.5;  //动画时间
static const int            KDropDownViewHeight                  = 3*44; //下拉view的高度
static const NSTimeInterval KPushApConfigControllerWithDuration  = 0.5;  //动画时间

static const int KSeperateSpan = 20;//控件之间的间隔

static const int KLineHeight = 1;//横线的高度

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"设备列表", nil) image:nil tag:1];
        
        NSString *pathSelectimage = [UIImage imageBundlePath:@"tab_device_unselect.png"];
        UIImage *imageSelect = [[UIImage alloc] initWithContentsOfFile:pathSelectimage];
        
        NSString *pathUnSelectimage = [UIImage imageBundlePath:@"tab_device_unselect.png"];
        UIImage *imageUbSelect = [[UIImage alloc] initWithContentsOfFile:pathUnSelectimage];
        
        [moreItem setFinishedSelectedImage: imageSelect withFinishedUnselectedImage: imageUbSelect];
        self.tabBarItem = moreItem;
        [moreItem release];
        [imageSelect release];
        [imageUbSelect release];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    NSArray *userArray = [[JVCDataBaseHelper shareDataBaseHelper]getAllUsers];
    
    if (userArray.count != 0) {//排序好了，第一个就是最后一次登录的用户
        
        JVCUserInfoModel *modeluse = [userArray objectAtIndex:0];
        
        textFieldUser.text  = modeluse.userName;
        if (modeluse.bAutoLoginState) {
            
            textFieldPW.text =  modeluse.passWord;
            
            //太快延迟0.3秒
          //  [self performSelector:@selector(clickTologin) withObject:nil afterDelay:KAfterDalayTimer];
        }
    }
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;

    [super viewDidLoad];
    
    /**
     *  注册所有的
     */
    UIControl *controlView = [[UIControl alloc] initWithFrame:self.view.frame];
    [controlView addTarget:self action:@selector(resiginTextFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:controlView];
    controlView.backgroundColor = [UIColor clearColor];
    [controlView release];
    
    /**
     *  背景
     */
    DDLogInfo(@"=self.view.frame==%@===",NSStringFromCGRect(self.view.frame));
    NSString *imagebgName = [UIImage correctImageName:@"log_bg.png"];
    UIImage *imageBg = [[UIImage alloc] initWithContentsOfFile:imagebgName];
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    imageViewBg.image = imageBg;
    [self.view addSubview:imageViewBg];
    [imageViewBg release];
    [imageBg release];
    
    /**
     *  图标的logo
     */
    NSString *imageLogoName = [UIImage imageBundlePath:@"log_logo.png"];
    UIImage *imageLogo = [[UIImage alloc] initWithContentsOfFile:imageLogoName];
    UIImageView *imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width- imageLogo.size.width)/2.0,KlogoOffSet_y , imageLogo.size.width, imageLogo.size.height)];
    imageViewLogo.image = imageLogo;
    [self.view addSubview:imageViewLogo];
    [imageViewLogo release];
    [imageLogo release];
    
    /**
     *  获取颜色值处理
     */
    JVCRGBHelper *rgbLabelHelper      = [JVCRGBHelper shareJVCRGBHelper];
    UIColor *labColor  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginGray];
   
    /**
     *  用户名模块
     */
    // 横杆
    UIImage *imageInPutLine = [UIImage imageNamed:@"log_line.png"];
    UIImageView *imageviewInPutLine = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-imageInPutLine.size.width)/2.0, KlogoOffSet_y+imageViewLogo.frame.origin.y+imageViewLogo.frame.size.height, imageInPutLine.size.width, imageInPutLine.size.height)];
    imageviewInPutLine.image = imageInPutLine;
    imageviewInPutLine.tag = LOGINVIEWTAG_Line;
    [self.view addSubview:imageviewInPutLine];
    [imageviewInPutLine release];
    //用户名小图标
    UIImage *imageUser = [UIImage imageNamed:@"log_user.png"];
    UIImageView *imageViewUser = [[UIImageView alloc] initWithFrame:CGRectMake(imageviewInPutLine.frame.origin.x, imageviewInPutLine.frame.origin.y - imageUser.size.height-5, imageUser.size.width, imageUser.size.height)];
    imageViewUser.image = imageUser;
    [self.view addSubview:imageViewUser];
    [imageViewUser release];
    //输入框
    textFieldUser = [[UITextField alloc] initWithFrame:CGRectMake(imageViewUser.frame.origin.x+10+imageViewUser.frame.size.width, imageViewUser.frame.origin.y, imageviewInPutLine.frame.size.width - imageViewUser.frame.size.width-50, imageViewUser.frame.size.height+5)];
    textFieldUser.keyboardType = UIKeyboardTypeASCIICapable;
    textFieldUser.autocorrectionType = UITextAutocorrectionTypeNo;
    textFieldUser.returnKeyType = UIReturnKeyDone;
    textFieldUser.delegate = self;
    textFieldUser.placeholder = @"用户名";
    if (labColor) {
        
        textFieldUser.textColor =labColor;
    }
    textFieldUser.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:textFieldUser];
    
    /**
     *  三角，当用户多时，显示出来
     */
    if ([JVCDataBaseHelper shareDataBaseHelper].usersHasLoginCount >0) {
        
        UIImage *imgBtnTriangel = [UIImage imageNamed:@"log_Down.png"];
        UIButton *btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDown.frame = CGRectMake(textFieldUser.frame.origin.x+textFieldUser.frame.size.width+5, textFieldUser.frame.origin.y, imgBtnTriangel.size.width*3, imgBtnTriangel.size.height*3);
        [btnDown setImage:imgBtnTriangel forState:UIControlStateNormal];
        btnDown.tag = LOGINVIEWTAG_Down;
        [btnDown addTarget:self action:@selector(clickDropDownView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDown];
    }
    
    /**
     *  密码
     */
    // 横杆
    UIImageView *imageviewInPutLinePW = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-imageInPutLine.size.width)/2.0, imageviewInPutLine.frame.origin.y+ 50, imageInPutLine.size.width, imageInPutLine.size.height)];
    imageviewInPutLinePW.image = imageInPutLine;
    [self.view addSubview:imageviewInPutLinePW];
    [imageviewInPutLinePW release];
    //用户名小图标
    UIImage *imagepw = [UIImage imageNamed:@"log_pw.png"];
    UIImageView *imageViewPW = [[UIImageView alloc] initWithFrame:CGRectMake(imageviewInPutLine.frame.origin.x, imageviewInPutLinePW.frame.origin.y - imagepw.size.height-5, imagepw.size.width, imagepw.size.height)];
    imageViewPW.image = imagepw;
    [self.view addSubview:imageViewPW];
    [imageViewPW release];
    //输入框
    textFieldPW = [[UITextField alloc] initWithFrame:CGRectMake(imageViewPW.frame.origin.x+10+imageViewPW.frame.size.width, imageViewPW.frame.origin.y, imageviewInPutLinePW.frame.size.width - imageViewPW.frame.size.width-30, imageViewPW.frame.size.height+5)];
    textFieldPW.placeholder = @"密码";
    textFieldPW.delegate = self;
    textFieldPW.returnKeyType = UIReturnKeyDone;
    textFieldPW.keyboardType = UIKeyboardTypeASCIICapable;
    textFieldPW.keyboardType = UIKeyboardTypeASCIICapable;
    if (labColor) {
        
        textFieldPW.textColor =labColor;
    }
    textFieldPW.secureTextEntry = YES;
    [self.view addSubview:textFieldPW];
    
    /**
     *  登录按钮
     */
    UIImage *imgLoginBg = [UIImage imageNamed:@"log_btn.png"];
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake((self.view.frame.size.width - imgLoginBg.size.width)/2.0, imageviewInPutLinePW.frame.origin.y+45, imgLoginBg.size.width, imgLoginBg.size.height);
    [btnLogin setBackgroundImage:imgLoginBg forState:UIControlStateNormal];
    [btnLogin.titleLabel setTextColor: [UIColor whiteColor]];
    [btnLogin addTarget:self action:@selector(clickTologin) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.tag = LOGINVIEWTAG_Login;
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:btnLogin];
    
    /**
     *  本地
     */
    UIButton *btnLocal = [[JVCControlHelper shareJVCControlHelper] buttonWithTitile:@"访客登录" normalImage:@"log_loc_btn.png" horverimage:nil];
    [btnLocal retain];
    btnLocal.frame = CGRectMake(btnLogin.left,btnLogin.bottom+KSeperateSpan, btnLocal.width, btnLocal.height);
    [btnLocal addTarget:self action:@selector(localLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLocal];
    [btnLocal release];
    
    //演示点
    UIButton *btnDemo = [[JVCControlHelper shareJVCControlHelper] buttonWithTitile:@"演示点" normalImage:@"log_demBg.png" horverimage:nil];
    [btnDemo retain];
    btnDemo.frame = CGRectMake((self.view.width-btnDemo.width)/2.0,self.view.height - btnDemo.height, btnDemo.width, btnDemo.height);
    [btnDemo addTarget:self action:@selector(demoPointClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDemo];
    [btnDemo release];
    
    /**
     *  注册
     */
    UIButton *btnResign = [[JVCControlHelper shareJVCControlHelper] buttonWithTitile:@"注册" normalImage:nil horverimage:nil];
    [btnResign retain];
    btnResign.frame = CGRectMake((self.view.width-2*btnResign.width)/3.0,btnLocal.bottom+KSeperateSpan, btnResign.width, btnResign.height);
    [btnResign addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnResign];
    [btnResign release];
    
//    UILabel *labelResign = [[UILabel alloc] initWithFrame:CGRectMake(btnResign.left, btnResign.bottom, btnResign.width, KLineHeight)];
//    labelResign.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:labelResign];
//    [labelResign release];
    
    /**
     *  忘记密码
     */
    UIButton *btnreSetPw = [[JVCControlHelper shareJVCControlHelper] buttonWithTitile:@"忘记密码" normalImage:nil horverimage:nil];
    [btnreSetPw retain];
    btnreSetPw.frame = CGRectMake(btnResign.right+(self.view.width-2*btnreSetPw.width)/3.0,btnLocal.bottom+KSeperateSpan, btnreSetPw.width, btnreSetPw.height);
    [self.view addSubview:btnreSetPw];
    
//    UILabel *labelPW = [[UILabel alloc] initWithFrame:CGRectMake(btnreSetPw.left, btnreSetPw.bottom, btnreSetPw.width, KLineHeight)];
//    labelPW.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:labelPW];
//    [labelPW release];
//    [btnreSetPw addTarget:self action:@selector(demoPointClick) forControlEvents:UIControlEventTouchUpInside];
    [btnreSetPw release];
    
    /**
     *  下拉view视图
     */
    dropDownView= [[JVCDropDownView alloc] initWithFrame:CGRectMake(imageviewInPutLine.frame.origin.x, imageviewInPutLine.frame.origin.y, imageviewInPutLine.frame.size.width, 0)];
    [self.view addSubview:dropDownView];
    dropDownView.dropDownDelegate = self;
    [self.view bringSubviewToFront:dropDownView];
    
    if ([[JVCSystemUtility shareSystemUtilityInstance] currentPhoneConnectWithWifiSSIDIsHomeIPC]) {
        
        JVCAPConfigViewController *popApViewcontroller = [[JVCAPConfigViewController alloc] init];
        
        popApViewcontroller.delegate                    = self;
        
        CATransition *transition  = [CATransition animation];
        transition.duration       = KPushApConfigControllerWithDuration;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type           = kCATransitionMoveIn;
        transition.subtype        = kCATransitionFromTop;
        transition.delegate       = self;
        [self.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:popApViewcontroller animated:NO];
    }
}

/**
 *  接收配置界面
 *
 *  @param buttonClickType 点击按钮的类别
 */
-(void)buttonClick:(int)buttonClickType{
    
    [self.navigationController popViewControllerAnimated:FALSE];
    
    if (buttonClickType == buttonClickType_Next) {
    
        [self playSound];
        [self gotoApConfigPlayVideo];
    }
}

/**
 *  前往视频检测界面
 */
-(void)gotoApConfigPlayVideo{
    
    self.navigationController.navigationBarHidden = NO;

     self.navigationController.navigationBarHidden = NO;
    JVCApConfigPlayVideoViewController *apConfigPlayVideo = [[JVCApConfigPlayVideoViewController alloc] init];
    [self.navigationController pushViewController:apConfigPlayVideo animated:YES];
    [apConfigPlayVideo release];
    if (iphone5) {
        
        JVCApConfigPlayVideoViewController *apConfigPlayVideo = [[JVCApConfigPlayVideoViewController alloc] init];
        [self.navigationController pushViewController:apConfigPlayVideo animated:YES];
        [apConfigPlayVideo release];
        
    }else{
        JVCAPConfigPlayVideoIphone4ViewController *apConfigPlayVideo = [[JVCAPConfigPlayVideoIphone4ViewController alloc] init];
        [self.navigationController pushViewController:apConfigPlayVideo animated:YES];
        [apConfigPlayVideo release];
    }
   
 
}

/**
 *  发现一个新设备，提示音
 */
-(void)playSound {
    
    NSString *path = [[NSBundle mainBundle ] pathForResource:@"shake_match_2" ofType:@"mp3"];
    
    if (path) {
        
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &shake_sound_finish);
    }
    
    AudioServicesPlayAlertSound(shake_sound_finish);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark 按下登录按钮
- (void)clickTologin
{
    if (![[JVCAlertHelper shareAlertHelper]predicateNetWorkState]) {
        
        return;
    };
    
    [JVCConfigModel shareInstance]._bISLocalLoginIn = TYPELOGINTYPE_ACCOUNT;

        //正则判断用户名、密码是否合法
    int result = [[JVCPredicateHelper shareInstance] loginPredicateUserName:textFieldUser.text andPassWord:textFieldPW.text];
    
    if (LOGINRESULT_SUCCESS == result) {//正则校验用户名密码合法，调用判断用户名强度的方法
        
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            //判断用户的强度，119是用户的新密码加密规则，调用UserLogin接口登陆118是用户的老密码加密规则调用OldUserLogin接口登陆
            int result = [[JVCAccountHelper sharedJVCAccountHelper] JudgeUserPasswordStrength:textFieldUser.text ];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                DDLogInfo(@"=%s=%d",__FUNCTION__,result);
                
                if (result == USERTYPE_OLD) {
                    
                    [self loginInWithOldUserType];
                    
                }else if(result == USERTYPE_NEW ){
                    
                    [self loginInWithNewUserType];
                    
                }else {//超时以及其他的一些提示
                    
                    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
                    
                    [[JVCResultTipsHelper shareResultTipsHelper] loginInWithJudegeUserNameStrengthResult:result];
                    
                }
                
            });
        });

        
    }else{//正则校验失败，提示相应的错误
        
        
        [[JVCResultTipsHelper shareResultTipsHelper] showLoginPredacateAlertWithResult:result];
    }
    
    
    [self resiginTextFields];

}

#pragma mark 老账号登录
/**
 *  老账号登录
 */
- (void)loginInWithOldUserType
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
       int resultOldType = [[JVCAccountHelper sharedJVCAccountHelper] OldUserLogin:textFieldUser.text passWord:textFieldPW.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            if (RESERT_USER_AND_PASSWORD == resultOldType) {//重置用户名和密码

                JVCDataBaseHelper *fmdbHelp =  [JVCDataBaseHelper shareDataBaseHelper] ;
                [fmdbHelp writeUserInfoToDataBaseWithUserName:textFieldUser.text passWord:textFieldPW.text];
                
                [self modifyUnLegalUserAndPw];
                
                
            }else if(RESERT_PASSWORD == resultOldType)//重置密码的，再后台自动重置
            {
                JVCDataBaseHelper *fmdbHelp =  [JVCDataBaseHelper shareDataBaseHelper] ;
                [fmdbHelp writeUserInfoToDataBaseWithUserName:textFieldUser.text passWord:textFieldPW.text];
                
                [self modifyPassWordInbackGround];
            
            }else if(LOGINRUSULT_SUCCESS == resultOldType)//登录成功，一般这个不会出现，因为既然是老用户了，就不会有这些问题
            {
            
                
            }else{
            
                [[JVCResultTipsHelper shareResultTipsHelper] loginInWithJudegeUserNameStrengthResult:resultOldType];
            }
        });
    });
}

/**
 *  后台修改密码
 */
- (void)modifyPassWordInbackGround
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        int result = [[JVCAccountHelper sharedJVCAccountHelper] ResetUserPassword:textFieldUser.text username:textFieldPW.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        if(LOGINRUSULT_SUCCESS == result)//成功
        {
            [self changeWindowRootViewController];

        }else{//修改失败之后，也要让用户切换试图
        
            [self changeWindowRootViewController];

        }
            
        });
        
    });
}

- (void)modifyUnLegalUserAndPw
{
    JVCModifyUnLegalViewController *modifyVC = [[JVCModifyUnLegalViewController alloc] init];
    modifyVC.delegate = self;
    [self.navigationController pushViewController:modifyVC animated:YES];
    [modifyVC release];
}

/**
 *  修改非法用户名密码的回调函数
 */
- (void)modifyUserAndPWSuccessCallBack
{
    textFieldUser.text = kkUserName;
    textFieldPW.text   = kkPassword;
    
    [self clickTologin];
}

#pragma mark 新账号登录
/**
 *  新账号登录
 */
- (void)loginInWithNewUserType
{
    
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int resultnewType = [[JVCAccountHelper sharedJVCAccountHelper] UserLogin:textFieldUser.text passWord:textFieldPW.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            if (LOGINRESULT_SUCCESS == resultnewType) {//成功
                
                [JVCConfigModel shareInstance]._bISLocalLoginIn = TYPELOGINTYPE_ACCOUNT;

                kkUserName = textFieldUser.text;
                kkPassword = textFieldPW.text;
                
                JVCDataBaseHelper *fmdbHelp =  [JVCDataBaseHelper shareDataBaseHelper] ;
                [fmdbHelp writeUserInfoToDataBaseWithUserName:textFieldUser.text passWord:textFieldPW.text];
                
                [self loginInSuccessToChangeRootController];
            
            }else{
            
                [[JVCResultTipsHelper shareResultTipsHelper] loginInWithJudegeUserNameStrengthResult:resultnewType];
            }
            
        });
    });
}

/**
 *  登录成功后切换rootcontroller
 */
- (void)loginInSuccessToChangeRootController
{
    //如果是present出来的，就让他dismiss掉，如果不是直接切换
    if (self.presentingViewController !=nil) {
        
        [self dismissModalViewControllerAnimated:YES];
        
        [self updaeeRootViewController];
        
    }else{
        
        [self changeWindowRootViewController];
    }
}

#pragma mark 注册成功之后的回调函数
/**
 *  用户注册成功的回调
 */
- (void)registerUserSuccessCallBack
{
    /**
     *  把注册成功的用户名密码为登录的用户名密码
     */
    textFieldUser.text  = kkUserName;
    textFieldPW.text    = kkPassword;

    DDLogInfo(@"=%@=%@==%@=USER=%@",kkUserName,kkPassword,textFieldUser.text,[[NSUserDefaults standardUserDefaults] objectForKey:@"USER"]);
    
    /**
     *  登录
     */
    [self clickTologin];
}

#pragma mark 切换主视图的root
- (void)changeWindowRootViewController
{

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate initWithTabarViewControllers];
}

/**
 *  点击演示点
 */
- (void)demoPointClick
{
    JVCDemoViewController *DemoVC = [[JVCDemoViewController alloc] init];
    [self.navigationController pushViewController:DemoVC animated:YES];
    [DemoVC release];
}

/**
 *  本地登录
 */
- (void)localLogin
{
    [JVCConfigModel shareInstance]._bISLocalLoginIn = TYPELOGINTYPE_LOCAL;
    //如果是present出来的，就让他dismiss掉，如果不是直接切换
    if (self.presentingViewController !=nil) {
        
        [self dismissModalViewControllerAnimated:YES];
        
        [self updaeeRootViewController];
        
    }else{
        
        [self changeWindowRootViewController];
    }

}

#pragma mark 用户注销登录后的方法
- (void)updaeeRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate UpdateTabarViewControllers];
}

#pragma mark 点击用户右侧的箭头的标志
/**
 *  按下三角的提示
 */
- (void)clickDropDownView
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:LOGINVIEWTAG_Line];
    
    
    [UIView animateWithDuration:KAmationTimer    animations:^{
        
        CGRect frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, 0);
        
        if (dropDownView.frame.size.height==0) {
            
            frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, KDropDownViewHeight);
        }
        
        [dropDownView showDropDownViewWithFrame:frame selectUserName:textFieldUser.text];
        
        
    }];
}

/**
 *  删除到没有账号了，用通知试图把弹出的试图收起来
 */
- (void)deleteLastAccountCallBack:(int)type
{
    switch (type) {
        case deleteType_SelectUser:
        {
            textFieldUser.text  = @"";
            textFieldPW.text    = @"";
        }
            break;
        case deleteType_DeleteAll:
        {
            [self clickDropDownView];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  选中账号
 *
 *  @param index 选中账号的索引
 */
- (void)didSelectAccountWithIndex:(JVCUserInfoModel *)model
{
    textFieldUser.text  = model.userName;
    textFieldPW.text    = model.passWord;
    
    [self clickDropDownView];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];


    return YES;
}

#pragma mark
/**
 *  注册按钮的点击时间
 */
- (void)registerClick
{
    if (![[JVCAlertHelper shareAlertHelper]predicateNetWorkState]) {
        
        return;
    };
    
    JVCRegisterViewController *resignVC = [[JVCRegisterViewController alloc] init];
    resignVC.resignDelegate = self;
    [self.navigationController pushViewController:resignVC animated:YES];
    [resignVC release];
}


-(void)resiginTextFields
{
    if (dropDownView.frame.size.height>0) {
        [self clickDropDownView];
    }
    
    [textFieldUser resignFirstResponder];
    [textFieldPW resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [textFieldPW release];
    [textFieldUser release];
    [super dealloc];
}

@end