//
//  JVCLogShowViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-18.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCLogShowViewController.h"
#import  "JVCSystemUtility.h"
#import "JVCAlertHelper.h"
#import "JVCURlRequestHelper.h"

@interface JVCLogShowViewController ()

@end

@implementation JVCLogShowViewController

@synthesize strLogPath;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *path= nil;
    
    path = [[NSBundle mainBundle] pathForResource:@"arm_clear" ofType:@"png"];
    
    if (path == nil) {
        
        path = [[NSBundle mainBundle] pathForResource:@"arm_clear@2x" ofType:@"png"];
        
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    
    NSString *pathSend= nil;
    
    pathSend = [[NSBundle mainBundle] pathForResource:@"log_send" ofType:@"png"];
    
    if (pathSend == nil) {
        
        pathSend = [[NSBundle mainBundle] pathForResource:@"log_send@2x" ofType:@"png"];
        
    }
    
    UIImage *imageSend = [[UIImage alloc] initWithContentsOfFile:pathSend];
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(0, 0, imageSend.size.width, imageSend.size.height);
    [btnSend addTarget:self action:@selector(sendLogMessage) forControlEvents:UIControlEventTouchUpInside];
    [btnSend setBackgroundImage:imageSend forState:UIControlStateNormal];
    
    UIBarButtonItem *barButtonItemSend = [[UIBarButtonItem  alloc] initWithCustomView:btnSend];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barButtonItem,barButtonItemSend, nil];
    [barButtonItem release];
    [barButtonItemSend release];
    [image release];
    [imageSend release];

    UITextView  *textView     = [[UITextView alloc] initWithFrame:self.view.frame];
    textView.textColor        = [UIColor darkTextColor];
    textView.font             = [UIFont systemFontOfSize:14];
    textView.backgroundColor  = [UIColor grayColor];
    textView.editable         = NO;
    textView.scrollEnabled    = YES;
    textView.text             = [self textWithLog];
    
    [self.view addSubview:textView];
    
    [textView release];
}

/**
 *  发送log日志
 */
- (void)sendLogMessage
{
    NSString       *path= [[JVCSystemUtility shareSystemUtilityInstance] getDocumentpathAtFileName:self.strLogPath];
    NSString *stringSend = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
   
    JVCURlRequestHelper  *urlRequest = [[[JVCURlRequestHelper alloc] init] autorelease];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    BOOL result = [urlRequest sendLogMesssage:stringSend];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result) {
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_suggestion_send_success")];
            }else{
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_suggestion_send_error")];

            }
        });

    });
}


-(void)clear {

    NSString       *path= [[JVCSystemUtility shareSystemUtilityInstance] getDocumentpathAtFileName:self.strLogPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
    
    
    [[JVCAlertHelper shareAlertHelper] alertWithMessage:NSLocalizedString(@"JVCLog_clear", nil)];
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  获取日志文本内容
 *
 *  @return 账号日志内容
 */
-(NSString *)textWithLog {
    
    NSMutableString *returnText = [[NSMutableString alloc] initWithCapacity:10];
    NSString        *pathAccount= [[JVCSystemUtility shareSystemUtilityInstance] getDocumentpathAtFileName:self.strLogPath];
    NSData          *data = [NSData dataWithContentsOfFile:pathAccount];
    
    if (data.length > 0) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [returnText appendString:result];
        
        [result release];
    }

    return  [returnText autorelease];
}

-(void)dealloc {

    DDLogVerbose(@"%s------------------",__FUNCTION__);
    [strLogPath release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
