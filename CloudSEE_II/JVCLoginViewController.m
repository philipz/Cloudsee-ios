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

#import "JVCDeviceListViewController.h"
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
    UITextField *textFieldUser ;
    /**
     *  密码的textfield
     */
    UITextField *textFieldPW;
    

}

@end

@implementation JVCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    UIImage *imageBg = [UIImage imageNamed:[[JVCSystemUtility shareSystemUtilityInstance] getImageByImageName:@"log_bg.png"]];
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageViewBg.image = imageBg;
    [self.view addSubview:imageViewBg];
    [imageViewBg release];
    
    /**
     *  图标的logo
     */
    UIImage *imageLogo = [UIImage imageNamed:@"log_logo.png"];
    UIImageView *imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width- imageLogo.size.width)/2.0, 80, imageLogo.size.width, imageLogo.size.height)];
    imageViewLogo.image = imageLogo;
    [self.view addSubview:imageViewLogo];
    [imageViewLogo release];
    
    /**
     *  用户名模块
     */
    // 横杆
    UIImage *imageInPutLine = [UIImage imageNamed:@"log_line.png"];
    UIImageView *imageviewInPutLine = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-imageInPutLine.size.width)/2.0, 70+imageViewLogo.frame.origin.y+imageViewLogo.frame.size.height, imageInPutLine.size.width, imageInPutLine.size.height)];
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
    textFieldUser.placeholder = @"用户名";
    [self.view addSubview:textFieldUser];
    
    //    /**
    //     *  三角，当用户多时，显示出来
    //     */
    //    UIImage *imgBtnTriangel = [UIImage imageNamed:@"log_Down.png"];
    //    UIButton *btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btnDown.frame = CGRectMake(textFieldUser.frame.origin.x+textFieldUser.frame.size.width+5, textFieldUser.frame.origin.y, imgBtnTriangel.size.width, imgBtnTriangel.size.height);
    //    [btnDown setBackgroundImage:imgBtnTriangel forState:UIControlStateNormal];
    //    btnDown.tag = LOGINVIEWTAG_Down;
    //    [btnDown addTarget:self action:@selector(clickDropDownView) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:btnDown];
    
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
         *  演示点、注册按钮
         */
        UIImage *imgDemoAndResign = [UIImage imageNamed:@"log_darbg.png"];
        UIImageView *imgViewDemoAndResign = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-imgDemoAndResign.size.width)/2.0, btnLogin.frame.size.height+btnLogin.frame.origin.y+20, imgDemoAndResign.size.width, imgDemoAndResign.size.height)];
        imgViewDemoAndResign.image = imgDemoAndResign;
        [self.view addSubview:imgViewDemoAndResign];
        [imgViewDemoAndResign release];
    
        /**
         *  演示点按钮
         */
        UIButton *btnDemo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDemo.frame = CGRectMake(imgViewDemoAndResign.frame.origin.x, imgViewDemoAndResign.frame.origin.y , imgDemoAndResign.size.width/2.0, imgDemoAndResign.size.height);
        [btnDemo setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnDemo setTitle:@"演示点" forState:UIControlStateNormal];
        btnDemo.tag = LOGINVIEWTAG_Demo;
        [self.view addSubview:btnDemo];
        /**
         *  注册
         */
        UIButton *btnResig = [UIButton buttonWithType:UIButtonTypeCustom];
        btnResig.frame = CGRectMake(imgViewDemoAndResign.frame.origin.x+btnDemo.frame.size.width, imgViewDemoAndResign.frame.origin.y , imgDemoAndResign.size.width/2.0, imgDemoAndResign.size.height);
        [btnResig setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnResig setTitle:@"注册" forState:UIControlStateNormal];
        [btnResig addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
        btnResig.tag = LOGINVIEWTAG_Resign;
        [self.view addSubview:btnResig];
    
    
        /**
         *  下拉view视图
         */
//        customDownView= [[customDropDownView alloc] initWithFrame:CGRectMake(imageviewInPutLine.frame.origin.x, imageviewInPutLine.frame.origin.y, imageviewInPutLine.frame.size.width, 0)];
//        [self.view addSubview:customDownView];
//        customDownView.dropDownDelegate = self;
//        [self.view bringSubviewToFront:customDownView];
//    
//        [[UserInfoManager shareUserInfoManager] createUserInfoTable];
//    
//        [[UserInfoManager shareUserInfoManager]  insertUserInfoWithUserName:@"123456" passWord:@"123"];

}

#pragma mark 按下登录按钮
- (void)clickTologin
{
    
#pragma mark 测试用
    JVCDeviceListViewController *deviceVC = [[JVCDeviceListViewController alloc] init];
    
    [self.navigationController pushViewController:deviceVC animated:YES];
    
    [deviceVC release];
    
//    [self resiginTextFields];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    
//        int result = [[JVCAccountHelper sharedJVCAccountHelper] UserLogin:textFieldUser.text passWord:textFieldPW.text];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//        
//            DDLogInfo(@"=%s=%d",__FUNCTION__,result);
//            
//            
//            
//        });
//    });
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
    
    DDLogInfo(@"=%@=%@==%@",kkUserName,kkPassword,textFieldUser.text);
    
    /**
     *  登录
     */
    [self clickTologin];
}


#pragma mark
/**
 *  注册按钮的点击时间
 */
- (void)registerClick
{
    JVCRegisterViewController *resignVC = [[JVCRegisterViewController alloc] init];
    resignVC.resignDelegate = self;
    [self.navigationController pushViewController:resignVC animated:YES];
    [resignVC release];
}

-(void)resiginTextFields
{
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