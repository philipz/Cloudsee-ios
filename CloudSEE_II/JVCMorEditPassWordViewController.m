//
//  JVCMorEditPassWordViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/29/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMorEditPassWordViewController.h"
#import "JVCPredicateHelper.h"
#import "JVCResultTipsHelper.h"
#import "JVCAccountHelper.h"
#import "JVCDataBaseHelper.h"
#import "AppDelegate.h"
#import "JVCRGBHelper.h"
#import "JVCRGBColorMacro.h"

/**
 *  textFeild 的类型
 */
enum TEXTFIELDTYPE
{
    TEXTFIELDTYPE_OLDPASSWORD=0,//老密码
    TEXTFIELDTYPE_NEWPASSWORD,//新密码
    TEXTFIELDTYPE_ENSUREPASSWORD,//确认密码
    
};

static const int  SYSTEM_FONT           = 16;//字体大小
static const int TEXTFIELD_SEPERATE     = 20;//间距
static const int KEDITPWDSLIDEHEIGINT   = 100;//滑动距离
static const NSTimeInterval KANIMATIN_DURARTION = 0.5;//动画时间
static const int kPredicateSuccess   = 0;//正则校验成功
static const int kDelayTimer         = 3;//弹出提示的时间


@interface JVCMorEditPassWordViewController ()
{
    /**
     *  老密码
     */
    UITextField *_textFieldOldPassWord;
    
    /**
     *  新密码
     */
    UITextField *_textFieldNewPassWord;
    
    /**
     *  确认新密码
     */
    UITextField *_textFieldEnSurePassWord;
    
    /**
     *  uicontroll
     */
    UIControl *mControll;
    

}

@end

@implementation JVCMorEditPassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)dealloc{

    [self resignEditPWDTextFields];
    [_textFieldOldPassWord release];
    [_textFieldNewPassWord release];
    [_textFieldEnSurePassWord release];
    [mControll release];
    [super dealloc];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LOCALANGER(@"jvc_more_editPw");
    
    [self initControll];
    
    _textFieldOldPassWord = [self initTextFieldWithTextFieldType:TEXTFIELDTYPE_OLDPASSWORD];
    [_textFieldOldPassWord becomeFirstResponder];
    _textFieldNewPassWord = [self initTextFieldWithTextFieldType:TEXTFIELDTYPE_NEWPASSWORD];
    _textFieldEnSurePassWord = [self initTextFieldWithTextFieldType:TEXTFIELDTYPE_ENSUREPASSWORD];
    
    [mControll addSubview:_textFieldOldPassWord];
    [mControll addSubview:_textFieldNewPassWord];
    [mControll addSubview:_textFieldEnSurePassWord];

    [self initSaveBtn];
}

- (void)initControll
{
    mControll = [[UIControl alloc] initWithFrame:self.view.frame];
    mControll.backgroundColor = [UIColor clearColor];
    [mControll addTarget:self action:@selector(resignEditPWDTextFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mControll];
    
}

/**
 *  注销所有的响应者
 */
- (void)resignEditPWDTextFields
{
    [self editPwdSlideDown];
    
    [_textFieldOldPassWord resignFirstResponder];
    [_textFieldNewPassWord resignFirstResponder];
    [_textFieldEnSurePassWord resignFirstResponder];
}

/**
 *  初始化textfield模块
 */
- (UITextField *)initTextFieldWithTextFieldType:(int )textFieldType
{
    /**
     *  用户名
     */
    UIImage *tImage = [UIImage imageNamed:@"tex_field.png"];
    
    UITextField  * _textFieldUserName = [[UITextField alloc] initWithFrame:CGRectMake(20, 20+textFieldType*(tImage.size.height+TEXTFIELD_SEPERATE), tImage.size.width, tImage.size.height) ];
    _textFieldUserName.delegate = self;
    _textFieldUserName.borderStyle = UITextBorderStyleNone;
    _textFieldUserName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _textFieldUserName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFieldUserName.background = tImage;
    _textFieldUserName.returnKeyType = UIReturnKeyDone;
    _textFieldUserName.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldUserName.textAlignment = UITextAlignmentLeft;
    _textFieldUserName.secureTextEntry = YES;
    UIColor *grayClor =[[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroLoginGray];
    if (grayClor) {
        _textFieldUserName.textColor = grayClor;
    }
    UILabel *labelLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KTextFieldLeftLabelViewWith, _textFieldUserName.height)];
    labelLeftView.backgroundColor = [UIColor clearColor];
    _textFieldUserName.leftViewMode = UITextFieldViewModeAlways;
    _textFieldUserName.leftView = labelLeftView;
    [labelLeftView release];
    
    NSString *strTitle = nil;
    switch (textFieldType) {
        case TEXTFIELDTYPE_OLDPASSWORD:
            strTitle =NSLocalizedString(@"oldPW", nil);
            break;
        case TEXTFIELDTYPE_NEWPASSWORD:
            strTitle =NSLocalizedString(@"newPW", nil);
            break;
        case TEXTFIELDTYPE_ENSUREPASSWORD:
            strTitle =NSLocalizedString(@"newInsurePw", nil);
            break;
            
        default:
            strTitle =@"";
            break;
    }
    _textFieldUserName.placeholder = strTitle;
    
    
    return _textFieldUserName ;
}

/**
 *  完成按钮
 */
- (void)initSaveBtn
{
    UIImage *tImageBtn = [UIImage imageNamed:@"btn_Bg.png"];
    UIButton *tFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tFinishBtn.frame = CGRectMake(20, _textFieldEnSurePassWord.frame.size.height+_textFieldEnSurePassWord.frame.origin.y+30, tImageBtn.size.width, tImageBtn.size.height);
    [tFinishBtn addTarget:self action:@selector(modifyUserPassWord) forControlEvents:UIControlEventTouchUpInside];
    [tFinishBtn setBackgroundImage:tImageBtn forState:UIControlStateNormal];
    [tFinishBtn setTitle:NSLocalizedString(@"binding_finish", nil) forState:UIControlStateNormal];
    [tFinishBtn.titleLabel setFont:[UIFont systemFontOfSize:SYSTEM_FONT]];
    [mControll addSubview:tFinishBtn];
    
}

- (void)modifyUserPassWord
{
    [self editPwdSlideDown];
    
    int result =[[JVCPredicateHelper shareInstance] predicateUserOldPassWord:_textFieldOldPassWord.text
                                                     NewPassWord:_textFieldNewPassWord.text
                                                  EnsurePassWord:_textFieldEnSurePassWord.text UserSavePassWord:kkPassword];
    
    if (result == kPredicateSuccess) {//正则判断成功，修改功能调用
        
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            int  result =[[JVCAccountHelper sharedJVCAccountHelper] ModifyUserPassword:_textFieldOldPassWord.text newPassWord:_textFieldNewPassWord.text];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                

                if (result == kPredicateSuccess) {//成功
                    
                    [[JVCDataBaseHelper shareDataBaseHelper] updateUserAutoLoginStateWithUserName:kkUserName loginState:kLoginStateOFF];
                    
                    AppDelegate *delegateApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    
                    [delegateApp presentLoginViewController];
                    
                    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

                    [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_mor_pwSuccess")];
                    
                    [self loginOutUser];
                    [self.navigationController popViewControllerAnimated:NO];
                    
                }else{//失败
                    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

                    [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"Modify_PW_fail")];
                }

            });
        
        });
                
    }else{//正则判断失败
        
        [[JVCResultTipsHelper shareResultTipsHelper] showEditUserPassWordResult:result ];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        
    if (range.location>=KPassWordMaxLength) {
        
        return NO;
    }
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setTextFieldStateNormal];
    [self setTextFieldStateSelect:textField];
    
    if (textField == _textFieldEnSurePassWord) {
        
        [self editPwdSlideUp];
    }
}


/**
 *  设置backGround的背景颜色
 */
- (void)setTextFieldStateNormal
{
    NSString *imagePath = [UIImage imageBundlePath:@"tex_field.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [_textFieldOldPassWord setBackground:image];
    [_textFieldNewPassWord setBackground:image];
    [_textFieldEnSurePassWord setBackground:image];
    [image release];
}

/**
 *  设置backGround的背景颜色
 */
- (void)setTextFieldStateSelect:(UITextField *)textField
{
    NSString *imagePath = [UIImage imageBundlePath:@"tex_field_sec.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [textField setBackground:image];
    [image release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self editPwdSlideDown];
    return YES;
}

//
- (void)setTextFieldNormal
{
}
/**
 *  注销用户
 */
- (void)loginOutUser
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [[JVCAccountHelper sharedJVCAccountHelper] UserLogout];
        
    });
}


#pragma mark 动画移动
#pragma mark 让控件上弹
- (void)editPwdSlideUp
{
    [UIView animateWithDuration:KANIMATIN_DURARTION animations:^{
        
        self.view.frame = CGRectMake(0, -KEDITPWDSLIDEHEIGINT, self.view.width, self.view.height);
    
    }];
    
}

- (void)editPwdSlideDown
{
    [UIView animateWithDuration:KANIMATIN_DURARTION animations:^{
        
      self.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);

    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
