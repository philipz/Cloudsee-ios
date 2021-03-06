//
//  JVCAPConfigPreparaViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAPConfigPreparaViewController.h"

static const int  ADDCONFIGHEIGIN = 64;//按钮多出来的那个高度

@interface JVCAPConfigPreparaViewController ()

@end

@implementation JVCAPConfigPreparaViewController

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
    
    self.title = LOCALANGER(@"jvc_ap_title");
    
    NSString *imageBundlePath = [UIImage imageBundlePath:LOCALANGER(@"add_apConfig")];
    UIImage *iamgeAp = [[UIImage alloc] initWithContentsOfFile:imageBundlePath];
    
    NSString *btnBgBundlePath = [UIImage imageBundlePath:@"arm_dev_btn.png"];
    UIImage *btnBg = [[UIImage alloc] initWithContentsOfFile:btnBgBundlePath];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    scrollView.contentSize = CGSizeMake(iamgeAp.size.width, iamgeAp.size.height+ADDCONFIGHEIGIN);
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iamgeAp.size.width, iamgeAp.size.height)];
    imageview.image = iamgeAp;
    [scrollView addSubview:imageview];
    [imageview release];
    [iamgeAp release];
    [self.view addSubview:scrollView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.view.width -btnBg.size.width)/2.0 , imageview.height+(ADDCONFIGHEIGIN -btnBg.size.height)/2.0, btnBg.size.width, btnBg.size.height);
    [btn setBackgroundImage:btnBg forState:UIControlStateNormal];
    [btn setTitle:LOCALANGER(@"jvc_ap_start_add") forState:UIControlStateNormal];
    [scrollView addSubview:btn];
    [btn addTarget:self action:@selector(exitToAPPConfig) forControlEvents:UIControlEventTouchUpInside];
    [scrollView release];
    [btnBg release];

}

/**
 *  弹出alert提示，看看是否退出程序
 */
- (void)exitToAPPConfig
{
  
    [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:LOCALANGER(@"home_ap_Alert_message_ios7")  delegate:self selectAction:@selector(exist) cancelAction:nil  selectTitle:LOCALANGER(@"home_ap_Alert_GOON") cancelTitle:LOCALANGER(@"home_ap_Alert_NO")alertTage:0];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {//继续
        
        [self exist];
        
    }
}

- (void)exist
{
    exit(0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DDLogVerbose(@"%@=======%s",[self class],__FUNCTION__);
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
