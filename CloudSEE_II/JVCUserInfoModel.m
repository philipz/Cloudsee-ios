//
//  JVCUserInfoModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCUserInfoModel.h"

@implementation JVCUserInfoModel

@synthesize  userName,passWord;

@synthesize loginTimer,bAutoLoginState;



- (void)dealloc
{
    loginTimer = 0.0f;
    
    [userName release];
    userName = nil;
    
    [passWord release];
    passWord = nil;
    
    [super dealloc];
    
}
@end
