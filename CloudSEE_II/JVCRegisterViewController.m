//
//  JVCRegisterViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCRegisterViewController.h"
#import "JVCAccountHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCAccountMacro.h"
#import "JVCResultTipsHelper.h"
#import "JVCRGBHelper.h"
#import "JVCDataBaseHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCControlHelper.h"
#import "JVCUserResignTextViewController.h"
#import "JVCLogHelper.h"
#import "JVCConfigModel.h"

static const int ORIGIN_Y  = 40;//第一个textfield距离顶端的距离

static const int SEPERATE  = 30;//textfield之间的间距

static const NSTimeInterval ANIMATIONTIME  = 0.5;//动画的时间

static const int SLIDEHEIGINT  = -100;//动画的时间

static const int RESISTERRESULT_SUCCESS  = 0;//返回值成功

static  NSString const *APPNAME  = @"CloudSEE";//app标识

static const int RESIGNFONT  = 10;//font 的大小

static const int PREDICATESECCESS  = 0 ;//正则校验成功

static const int KLabelWith  = 10 ;//label的宽度

static const int KUserRESIGNFONT  = 18;//font 的大小

@interface JVCRegisterViewController ()
{
    /**
     *  用户名
     */
    UITextField *textFieldUser;
    
    /**
     *  用户名的提示lable
     */
    UILabel *labUser;
    
    /**
     *  密码
     */
    UITextField *textFieldPassWord;
    
    /**
     *  密码的提示label
     */
    UILabel *labPassWord;

    /**
     *  确认密码
     */
    UITextField *textFieldEnSurePassWord;
    
    /**
     *  密码的提示label
     */
    UILabel *labEnPassWord;
    
    /**
     *  是否同意的btn
     */
    UIButton *btnAgree;
    
}

@end

@implementation JVCRegisterViewController

@synthesize resignDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    DDLogVerbose(@"%@====%s",[self class],__FUNCTION__);
    [textFieldUser release];
    textFieldUser = nil;
    
    [labUser release];
    labUser = nil;
    
    [textFieldPassWord release];
    textFieldEnSurePassWord = nil;
    
    [labPassWord release];
    labUser = nil;
    
    [textFieldEnSurePassWord release];
    textFieldEnSurePassWord = nil;
    
    [labEnPassWord release];
    labEnPassWord = nil;
    
    [super dealloc];
}

-(void)deallocWithViewDidDisappear
{
    [self resignTextFields];

    [super deallocWithViewDidDisappear];
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    
    self.tenCentKey = kTencentKey_resign;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    /**
     *  设置背景的点击事件
     */
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.frame];
    
    [control addTarget:self action:@selector(resignTextFields) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:control];
    
    [control release];
    
    /**
     *  设置标题
     */
    self.title = LOCALANGER(@"jvc_resign_Title");
    
    UIImage *imgTextFieldBg = [UIImage imageNamed:@"tex_field.png"];
    
    //用户名
    textFieldUser = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - imgTextFieldBg.size.width)/2.0, ORIGIN_Y, imgTextFieldBg.size.width, imgTextFieldBg.size.height)];
    textFieldUser.borderStyle = UITextBorderStyleNone;
    textFieldUser.delegate = self;
    textFieldUser.contentVerticalAlignment  =  UIControlContentVerticalAlignmentCenter;
    [textFieldUser becomeFirstResponder];
    textFieldUser.autocorrectionType = UITextAutocorrectionTypeNo;
    [textFieldUser setBackground:imgTextFieldBg];
    textFieldUser.returnKeyType = UIReturnKeyDone;
    textFieldUser.placeholder = NSLocalizedString(@"jvc_resign_user", nil);
    textFieldUser.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:textFieldUser];
    UILabel *userLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabelWith, textFieldUser.height)];
    userLeftView.backgroundColor = [UIColor clearColor];
    textFieldUser.leftViewMode = UITextFieldViewModeAlways;
    textFieldUser.leftView = userLeftView;
    [userLeftView release];
    
    //用户名提示
    labUser = [[UILabel alloc] initWithFrame:CGRectMake(textFieldUser.left, textFieldUser.bottom, textFieldUser.width, SEPERATE)];
    labUser.backgroundColor = [UIColor clearColor];
    labUser.font = [UIFont systemFontOfSize:RESIGNFONT];
    [self.view addSubview:labUser];
    
    //密码
    textFieldPassWord = [[UITextField alloc] initWithFrame:CGRectMake(textFieldUser.frame.origin.x, textFieldUser.bottom+SEPERATE, imgTextFieldBg.size.width, imgTextFieldBg.size.height)];
    textFieldPassWord.borderStyle = UITextBorderStyleNone;
    textFieldPassWord.delegate = self;
    textFieldPassWord.contentVerticalAlignment  =  UIControlContentVerticalAlignmentCenter;
    textFieldPassWord.secureTextEntry = YES;
    textFieldPassWord.placeholder = LOCALANGER(@"jvc_resign_pw");
    textFieldPassWord.returnKeyType = UIReturnKeyDone;
    textFieldPassWord.keyboardType = UIKeyboardTypeASCIICapable;
    [textFieldPassWord setBackground:imgTextFieldBg];
    [self.view addSubview:textFieldPassWord];
    UILabel *pwLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabelWith, textFieldUser.height)];
    pwLeftView.backgroundColor = [UIColor clearColor];
    textFieldPassWord.leftViewMode = UITextFieldViewModeAlways;
    textFieldPassWord.leftView = pwLeftView;
    [pwLeftView release];
    
    //密码的提示
    labPassWord = [[UILabel alloc] initWithFrame:CGRectMake(textFieldPassWord.left, textFieldPassWord.bottom, textFieldUser.width, SEPERATE)];
    labPassWord.backgroundColor = [UIColor clearColor];
    labPassWord.font = [UIFont systemFontOfSize:RESIGNFONT];
    [self.view addSubview:labPassWord];
    
    //确认密码
    textFieldEnSurePassWord = [[UITextField alloc] initWithFrame:CGRectMake(textFieldPassWord.left, textFieldPassWord.bottom+SEPERATE, imgTextFieldBg.size.width, imgTextFieldBg.size.height)];
    textFieldEnSurePassWord.delegate = self;
    textFieldEnSurePassWord.borderStyle = UITextBorderStyleNone;
    textFieldEnSurePassWord.secureTextEntry = YES;
    textFieldEnSurePassWord.contentVerticalAlignment  =  UIControlContentVerticalAlignmentCenter;
    textFieldEnSurePassWord.placeholder =LOCALANGER(@"jvc_resign_enpw");
    textFieldEnSurePassWord.returnKeyType = UIReturnKeyDone;
    textFieldEnSurePassWord.leftViewMode = UITextFieldViewModeAlways;
    [textFieldEnSurePassWord setBackground:imgTextFieldBg];
    [self.view addSubview:textFieldEnSurePassWord];
    UILabel *pwEnLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabelWith, textFieldUser.height)];
    pwEnLeftView.backgroundColor = [UIColor clearColor];
    textFieldEnSurePassWord.leftViewMode = UITextFieldViewModeAlways;
    textFieldEnSurePassWord.leftView = pwEnLeftView;
    [pwEnLeftView release];
    
    //密码的提示
    labEnPassWord = [[UILabel alloc] initWithFrame:CGRectMake(textFieldPassWord.left, textFieldEnSurePassWord.bottom, textFieldUser.width, SEPERATE)];
    labEnPassWord.backgroundColor = [UIColor clearColor];
    labEnPassWord.font = [UIFont systemFontOfSize:RESIGNFONT];
    [self.view addSubview:labEnPassWord];
    
    JVCAppParameterModel *appModel = [JVCAppParameterModel shareJVCAPPParameter];
    
    btnAgree = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAgree.frame = CGRectMake(labEnPassWord.left, labEnPassWord.bottom, btnAgree.width, 0);

    int addHeighBottom = SEPERATE;
    switch (appModel.nHasRegister) {
        case JVCRegisterType_Default:
            addHeighBottom =0;
            break;
        case JVCRegisterType_China:
        {
            addHeighBottom =0;
            
            if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
                addHeighBottom = SEPERATE;
                /**
                 *  同意按钮
                 */
                JVCControlHelper *controlHelp = [JVCControlHelper shareJVCControlHelper];
                btnAgree = [controlHelp buttonWithTitile:nil normalImage:@"reg_btn_nor.png" horverimage:@"reg_btn_hor.png"];
                btnAgree.frame = CGRectMake(labEnPassWord.left, labEnPassWord.bottom, btnAgree.width, btnAgree.height);
                [btnAgree addTarget:self  action:@selector(changeUserAgreeState) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btnAgree];
                btnAgree.selected = YES;
                UILabel *labelUser = [controlHelp labelWithText:LOCALANGER(@"jvc_resign_Resign_Text") textFontSize:KUserRESIGNFONT];
                labelUser.frame = CGRectMake(btnAgree.right, labEnPassWord.bottom-7, labelUser.width, labelUser.height);
                [self.view addSubview:labelUser];
                
                UILabel *labelUserText = [controlHelp labelWithUnderLine:LOCALANGER(@"jvc_resign_Resign_DownLineText") fontSize:KUserRESIGNFONT];
                labelUserText.frame = CGRectMake(labelUser.right, labelUser.top, labelUserText.width, labelUserText.height);
                [self.view addSubview:labelUserText];
                UIColor *colorDown = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:KJVCresigDownLabecolor];
                if (colorDown) {
                    
                    labelUserText.textColor = colorDown;
                }
                labelUserText.userInteractionEnabled = YES;
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserDetailTextView)];
                [labelUserText addGestureRecognizer:gesture];
                [gesture release];

            }
        }
            
            break;
        case JVCRegisterType_ALL:
        {
            addHeighBottom = SEPERATE;

            /**
             *  同意按钮
             */
            JVCControlHelper *controlHelp = [JVCControlHelper shareJVCControlHelper];
            btnAgree = [controlHelp buttonWithTitile:nil normalImage:@"reg_btn_nor.png" horverimage:@"reg_btn_hor.png"];
            btnAgree.frame = CGRectMake(labEnPassWord.left, labEnPassWord.bottom, btnAgree.width, btnAgree.height);
            [btnAgree addTarget:self  action:@selector(changeUserAgreeState) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnAgree];
            btnAgree.selected = YES;
            UILabel *labelUser = [controlHelp labelWithText:LOCALANGER(@"jvc_resign_Resign_Text") textFontSize:KUserRESIGNFONT];
            labelUser.frame = CGRectMake(btnAgree.right, labEnPassWord.bottom-7, labelUser.width, labelUser.height);
            [self.view addSubview:labelUser];
            
            UILabel *labelUserText = [controlHelp labelWithUnderLine:LOCALANGER(@"jvc_resign_Resign_DownLineText") fontSize:KUserRESIGNFONT];
            labelUserText.frame = CGRectMake(labelUser.right, labelUser.top, labelUserText.width, labelUserText.height);
            [self.view addSubview:labelUserText];
            UIColor *colorDown = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:KJVCresigDownLabecolor];
            if (colorDown) {
                
                labelUserText.textColor = colorDown;
            }
            labelUserText.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserDetailTextView)];
            [labelUserText addGestureRecognizer:gesture];
            [gesture release];

        }
            break;
        default:
            break;
    }
    

    //注册按钮
    UIImage *imageBtn = [UIImage imageNamed:@"btn_Bg.png"];
    
    UIButton *btnResign = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnResign.frame = CGRectMake((self.view.width - imageBtn.size.width)/2.0, btnAgree.bottom+addHeighBottom, imageBtn.size.width, imageBtn.size.height);
    
    [btnResign setBackgroundImage:imageBtn forState:UIControlStateNormal];
    
    [btnResign addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    
    [btnResign setTitle:LOCALANGER(@"jvc_resign_Title") forState:UIControlStateNormal];
    
    [self.view addSubview:btnResign];
    
}

- (void)gotoUserDetailTextView
{
    JVCUserResignTextViewController *textVC = [[JVCUserResignTextViewController alloc] init];
    [self.navigationController pushViewController:textVC animated:YES];
    [textVC release];
}

- (void)changeUserAgreeState
{
    if (btnAgree.selected) {
        btnAgree.selected = NO;
    }else{
        btnAgree.selected = YES;
    }
}

#pragma mark textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setTextBackGroudNormal];
    [self setTextBackGroudSelect:textField];
    if (textField == textFieldEnSurePassWord) {
        
        [self slideUP];
    }
}

- (void)setTextBackGroudNormal
{
    NSString *imagePath = [UIImage imageBundlePath:@"tex_field.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [textFieldUser setBackground:image];
    [textFieldPassWord setBackground:image];
    [textFieldEnSurePassWord setBackground:image];
    [image release];

}

- (void)setTextBackGroudSelect:(UITextField *)textField
{
    NSString *imagePath = [UIImage imageBundlePath:@"tex_field_sec.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [textField setBackground:image];
    [image release];
    
}

- (void)resignTextField
{
    NSString *imagePath = [UIImage imageBundlePath:@"tex_field.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [textFieldUser setBackground:image];
    [textFieldPassWord setBackground:image];
    [textFieldEnSurePassWord setBackground:image];
    [image release];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.text.length==0) {
        
        return;
    }
    
    if (textField == textFieldUser) {//判断用户名是否被注册过用户名
        
        int resultValue = [[JVCPredicateHelper shareInstance] predicateUserNameIslegal:textFieldUser.text];
        
        if (PREDICATESECCESS != resultValue) {//校验没有通过
            
            NSString *_strTitle = nil;
            
            switch (resultValue) {
                    
                case VALIDATIONUSERNAMETYPE_LENGTH_E:
                    _strTitle =LOCALANGER(@"loginResign_LENGTH_E");
                    break;
                case VALIDATIONUSERNAMETYPE_NUMBER_E:
                    _strTitle =LOCALANGER(@"loginResign_NUMBER_E");
                    break;
                case VALIDATIONUSERNAMETYPE_OTHER_E:
                    _strTitle =LOCALANGER(@"loginResign_OTHER_E");
                    break;
                case VALIDATIONUSERNAMETYPE_EMAIL_E:
                    _strTitle =LOCALANGER(@"home_email_error");
                    break;
                default:
                    break;
            }
            
            [self setLabelRed:labUser];
            labUser.text =_strTitle;
            
        }else{//校验通过
        
            [self judgeUserNameHasResign];
            
        }

    }else if(textFieldPassWord == textField)//密码
    {
        BOOL bStatePassWord = [[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:textFieldPassWord.text];
    
        if (!bStatePassWord) {//失败
            [self setLabelRed:labPassWord];
            labPassWord.text = LOCALANGER(@"loginResign_passWord_error");//LOGINRESULT_PASSWORLD_ERROR

        }else{
            
            labPassWord.text =@"";
        }
        
        if ([[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:textFieldEnSurePassWord.text]) {
            
            if(![textFieldPassWord.text isEqualToString:textFieldEnSurePassWord.text]) {
                
                [self setLabelRed:labEnPassWord];
                labEnPassWord.text =LOCALANGER(@"PasswordNoEqual");
            }
            
        }else{
            
            if (textFieldEnSurePassWord.text.length>0) {
                
                labEnPassWord.text =LOCALANGER(@"loginResign_passWord_error");
                
            }
        }
    }else
    {
        if([[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:textFieldPassWord.text]) {
            
            if (![textFieldEnSurePassWord.text isEqualToString:textFieldPassWord.text]) {
                [self setLabelRed:labEnPassWord];

                labEnPassWord.text =LOCALANGER(@"PasswordNoEqual");
                return;
            }
        }
        
        BOOL resutl = [[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:textFieldEnSurePassWord.text];
        
        if (!resutl) {
            [self setLabelRed:labEnPassWord];

            labEnPassWord.text = LOCALANGER(@"loginResign_passWord_error");
            
        }else{
        
            labEnPassWord.text=@"";
        
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == textFieldUser) {
        
        if(range.location>=KUserNameMaxLength)
            
            return NO;
    }else{
    
        if (range.location>=KPassWordMaxLength) {
            
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self slideDown];
    return YES;
}

/**
 *  判断用户名是否被注册过
 */
- (void)judgeUserNameHasResign
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int exitResult = [[JVCAccountHelper sharedJVCAccountHelper] IsUserExist:textFieldUser.text];
        
        DDLogInfo(@"再这里就行了修改，回头要去掉==exitResult= 0;");
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [self handleJudgeUserNameHsaResign:exitResult];
        });
        
    });

}

/**
 *  根据返回的数据处理结果
 *
 *  @param tType 注册的返回结果信息
 */
- (void)handleJudgeUserNameHsaResign:(int )tType
{
        if (tType == USER_HAS_EXIST) {
            
            [self setLabelRed:labUser];

            labUser.text = LOCALANGER(@"home_login_resign_user_exit");
            
        }else if(tType == USER_NOT_EXIST){
            
            [self setUserLabelBlue:labUser];
            labUser.text = LOCALANGER(@"home_login_resign_user_noFound");
        }else if(tType == PHONE_NUM_ERROR){
            
            [self setLabelRed:labUser];
            labUser.text = LOCALANGER(@"home_login_resign_PhoneNum_error");
        }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 注销所有的textfield
- (void)resignTextFields
{
    [self slideDown];
    
    [textFieldUser resignFirstResponder];
    
    [textFieldPassWord resignFirstResponder];

    [textFieldEnSurePassWord resignFirstResponder];
    

}
#pragma mark 注册按钮按下时间
- (void)signUp
{
    JVCAppParameterModel *appModel = [JVCAppParameterModel shareJVCAPPParameter];
    
    switch (appModel.nHasRegister) {
        case JVCRegisterType_Default:
            break;
        case JVCRegisterType_China:
        {
            if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
                if (!btnAgree.selected) {
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_resign_Resign_AgreeResign")];
                    return;
                }
            }
        }
            break;
        case JVCRegisterType_ALL:
        {
            if (!btnAgree.selected) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_resign_Resign_AgreeResign")];
                return;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    /**
     *  检索用户输入的字符串是否合法
     */
    textFieldUser.text = textFieldUser.text.lowercaseString;
    int resultPredicate = [[JVCPredicateHelper shareInstance] predicatUserResignWithUser:textFieldUser.text andPassWord:textFieldPassWord.text andEnsurePassWord:textFieldEnSurePassWord.text ];
    
    if (LOGINRESULT_SUCCESS == resultPredicate) {//成功，判断用户名是否被注册过
    
        [self resignUserToServer];
        
    }else{//不成功
        
        [[JVCResultTipsHelper shareResultTipsHelper] showLoginPredacateAlertWithResult:resultPredicate];
        
    }
}

/**
 *  往服务器注册用户
 */
- (void)resignUserToServer
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int result = [[JVCAccountHelper sharedJVCAccountHelper] UserRegister:textFieldUser.text passWord:textFieldPassWord.text appTypeName:APPNAME];
        
        [[JVCLogHelper shareJVCLogHelper] writeDataToFile:[NSString stringWithFormat:@"%s==%d",__FUNCTION__,result] fileType:LogType_LoginManagerLogPath];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            DDLogInfo(@"%s==注册收到的返回值 =%d",__FUNCTION__,result);
            
            [self dealWithRegisterResutl:result];
            
        });
        
    });

}

#pragma mark 处理注册的返回结果
- (void)dealWithRegisterResutl:(int)iResult
{
    if (RESISTERRESULT_SUCCESS == iResult) {//成功，把用户名密码保存起来
        
        kkUserName = textFieldUser.text;
        kkPassword = textFieldPassWord.text;
        
        JVCDataBaseHelper *fmdbHelp =  [JVCDataBaseHelper shareDataBaseHelper] ;
        [fmdbHelp writeUserInfoToDataBaseWithUserName:textFieldUser.text passWord:textFieldPassWord.text];
        
        if ([[ JVCPredicateHelper shareInstance] predicateEmailLegal:kkUserName] == PREDICATESECCESS) {//邮箱注册
            
            [self callResignDelegateMaths];
            
            [self.navigationController popViewControllerAnimated:NO];

            
        }else{//不是邮箱注册，跳转到绑定界面，但是要先登录
        
            [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
            
//                int resultnewType = [[JVCAccountHelper sharedJVCAccountHelper] UserLogin:kkUserName passWord:kkPassword];
                BOOL resultLanguage = [[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage];

                int resultnewType = [[JVCAccountHelper sharedJVCAccountHelper] userLoginV2:kkUserName passWord:kkPassword tokenString:kkToken languageType:!resultLanguage alarmFlag:![JVCConfigModel shareInstance].bSwitchSafe];

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[JVCAlertHelper shareAlertHelper]alertHidenToastOnWindow];

                    if (LOGINRESULT_SUCCESS == resultnewType) {//成功
        
                        [self initBindViewController];
                        
                    }else{//不成功，不用跳转到绑定界面，直接登录就行
                        
                        [self callResignDelegateMaths];

                        [self.navigationController popViewControllerAnimated:NO];

                    }
                    
                });
            });

        }
        
        
    }else{//失败
    
        DDLogError(@"=%s=注册失败收到的返回值=%d",__FUNCTION__,iResult);
        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_resign_Resign_eror")];
    }
}

/**
 *  跳转到绑定界面
 */
- (void)initBindViewController
{
    JVCBindingEmailViewController *bindVC = [[JVCBindingEmailViewController alloc] init];
    bindVC.delegateEmail = self;
    [self.navigationController pushViewController:bindVC animated:YES];
    [bindVC release];
    
}
/**
 *  绑定邮箱的回调、完成或者跳过的回调
 */
- (void)FinishAndSkipBindingEmailCallback
{
    [self callResignDelegateMaths];
}

- (void)callResignDelegateMaths
{
    if (resignDelegate !=nil && [resignDelegate  respondsToSelector:@selector(registerUserSuccessCallBack)]) {
        
        [resignDelegate registerUserSuccessCallBack];
    }

}
#pragma mark 新账号登录


#pragma mark 界面向上滑动
/**
 *  向上滚动试图
 */
- (void)slideUP
{
    [UIView animateWithDuration:ANIMATIONTIME animations:^{
        
        self.view.frame = CGRectMake(0, SLIDEHEIGINT, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

/**
 *  向下滚动试图
 */
- (void)slideDown
{
    [UIView animateWithDuration:ANIMATIONTIME animations:^{
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
}

#pragma mark 设置lable的颜色值为红色
- (void)setLabelRed:(UILabel *)label
{
    UIColor *redColor  = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroRed];
    
    if (redColor) {
        
        label.textColor = redColor;
    }
}

#pragma mark 设置lable的颜色值为蓝色
- (void)setUserLabelBlue:(UILabel *)label
{
    UIColor *redColor  = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroBlue];
    
    if (redColor) {
        
        label.textColor = redColor;
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
