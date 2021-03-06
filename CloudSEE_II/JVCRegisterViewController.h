//
//  JVCRegisterViewController.h
//  CloudSEE_II
//  注册界面
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "JVCBaseSliderViewController.h"
#import "JVCBindingEmailViewController.h"

@protocol RegisterUserDelegate <NSObject>

/**
 *  用户注册成功的回调
 */
- (void)registerUserSuccessCallBack;

@end
@interface JVCRegisterViewController : JVCBaseSliderViewController<UITextFieldDelegate,FinishAndSkipBindingEmailDelegate>
{
    id<RegisterUserDelegate> resignDelegate;
}

@property(nonatomic,assign)id<RegisterUserDelegate> resignDelegate;
@end
