//
//  JVCOperationController.h
//  CloudSEE_II
//  播放类库
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCDeviceModel.h"
#import "AQSController.h"
#import "JVCCustomOperationBottomView.h"
#import "JVCCustomCoverView.h"

@class JVCManagePalyVideoComtroller;

@protocol operationControllerDelegate <NSObject>

/**
 *  分割视频源窗口
 *
 *  @param singeShowViewNumber 一页显示几个监控画面(最大16个)
 */
-(void)splitViewWindow:(int)singeShowViewNumber;

@end


@interface JVCOperationController : UIViewController<customBottomDelegate,CustomCoverViewDelegate>
{
    NSMutableArray *_aDeviceChannelListData;        //存放
    int             _iSelectedChannelIndex;
    UIAlertView    *wheelAlterInfo;
    NSMutableArray *_amUnSelectedImageNameListData;
    NSMutableArray *_amSelectedImageNameListData;
    
    bool             _issound;
    bool             _isTalk;
    bool             _isLocalVideo;
    bool             _isPlayBack;
    int              _iViewState;  // 0：正常 1: 注销登陆 2: 地图登陆
    NSMutableArray  *_playBackVideoDataArray;//远程回放视频列表
    NSMutableString *_playBackDateString;
    UIScrollView    *scrollview;
    UIButton        *_bSmallMoreBtn;
    
    int              skinSelect;
    
    id <operationControllerDelegate> delegate;
    JVCManagePalyVideoComtroller  *_managerVideo;
}

@property (nonatomic,retain) NSMutableArray *_aDeviceChannelListData;
@property (nonatomic,assign) int             _iSelectedChannelIndex;
@property (nonatomic,assign) bool            _issound,_isTalk,_isLocalVideo,_isPlayBack;
@property (nonatomic,assign) int             _iViewState;
@property (nonatomic,retain) NSMutableString *_playBackDateString;
@property (nonatomic,retain) NSMutableArray  *_playBackVideoDataArray;
@property (nonatomic,assign) BOOL             showSingeleDeviceLongTap;
@property (nonatomic,assign) id <operationControllerDelegate> delegate;

- (void)saveLocalVideo:(NSString*)urlString;
-(void)unAllLink;
-(void)ytoHidenClick;
-(void)playSoundPressed;
-(void)gotoBack;
-(void)ytoClick:(UIButton*)button;
-(void)changeRotateFromInterfaceOrientationFrame:(BOOL)IsRotateFrom;
-(BOOL)returnIsplayBackVideo;
-(BOOL)returnOperationState;
- (void)setScrollviewByIndex:(NSInteger)Index;
-(void)gotoShowSpltWindow;
-(void)changeSplitView:(int)_splitWindows;
-(NSMutableArray*)getSplitWindowMaxNumbers;
-(BOOL)isCheckCurrentSingleViewGlViewHidden;

/**
 * 按下事件的执行方法
 *
 *  @param index btn的index
 */
- (void)MiddleBtnClickWithIndex:(int )index;

/**
 *  音频监听功能（关闭）
 *
 *  @param bState YES:(对讲模式下)  NO：音频监听模式下
 */
-(void)audioButtonClick:(BOOL)bState;

@end
