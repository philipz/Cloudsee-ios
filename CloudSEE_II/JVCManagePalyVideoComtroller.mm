//
//  JVCManagePalyVideoComtroller.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCManagePalyVideoComtroller.h"
#import "JVCMonitorConnectionSingleImageView.h"
#import "JVNetConst.h"
#import "OpenALBufferViewcontroller.h"
#import "JVCAppHelper.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCHorizontalScreenBar.h"
#import "GlView.h"
#import "JVCLogHelper.h"

@interface JVCManagePalyVideoComtroller () {

    UIScrollView            *WheelShowListView;
}

@end

@implementation JVCManagePalyVideoComtroller

@synthesize amChannelListData,_operationController,imageViewNums;
@synthesize _iCurrentPage,_iBigNumbers,nSelectedChannelIndex;
@synthesize strSelectedDeviceYstNumber,delegate;
@synthesize isPlayBackVideo,isShowVideo;
@synthesize isConnectAll;

static const int  kPlayViewDefaultMaxValue            = showWindowNumberType_Four;
static const int  kPlayVideoWithFullFramCriticalValue = 4;

int  nAllLinkFlag;
BOOL isAllLinkRun;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self._iBigNumbers    = kPlayViewDefaultMaxValue;
        self.backgroundColor = [UIColor blackColor];
        isActive             = TRUE;
        
        AppDelegate *delegateApp             = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegateApp.appDelegateVideoDelegate = self;
    }
    return self;
}

#pragma mark ----------------- AppDelegate Deleagte

-(void)stopPlayVideoCallBack{

    isActive = FALSE;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        int endIndex   = (self._iCurrentPage + 1) * self.imageViewNums;
        int startIndex =  self._iCurrentPage      * self.imageViewNums;
        int maxCount   = [self channelCountAtSelectedYstNumber];
        
        endIndex =  endIndex >= maxCount ? maxCount : endIndex;
        
        
        for (int i = startIndex; i < endIndex; i++) {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:i+1 remoteOperationCommand:JVN_CMD_VIDEOPAUSE];
        }
    });
}


-(void)continuePlayVideoCallBack{

    isActive = TRUE;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        int endIndex   = (self._iCurrentPage + 1) * self.imageViewNums;
        int startIndex =  self._iCurrentPage      * self.imageViewNums;
        int maxCount   = [self channelCountAtSelectedYstNumber];
        
        endIndex =  endIndex >= maxCount ? maxCount : endIndex;
        
        
        for (int i = startIndex; i < endIndex; i++) {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:i+1 remoteOperationCommand:JVN_CMD_VIDEO];
        }
        
    });
}

/**
 *  初始化视频显示窗口
 */
-(void)initWithLayout{
    
    JVCCloudSEENetworkHelper *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    int channelCount                              = [self channelCountAtSelectedYstNumber];
    ystNetWorkHelperObj.ystNWHDelegate   =self;
    
    WheelShowListView       = [[UIScrollView alloc] init];
    WheelShowListView.frame = CGRectMake(0.0,0.0, self.frame.size.width, self.frame.size.height);
	WheelShowListView.directionalLockEnabled = YES;
	WheelShowListView.pagingEnabled = YES;
	WheelShowListView.showsVerticalScrollIndicator=NO;
	WheelShowListView.showsHorizontalScrollIndicator=YES;
	WheelShowListView.bounces=NO;
	WheelShowListView.delegate = self;
	WheelShowListView.backgroundColor=[UIColor clearColor];
	[self addSubview:WheelShowListView];
	[WheelShowListView release];
    
    int ncolumnCount  = sqrt(self.imageViewNums);
    
    if (ncolumnCount >= 1) {
        
        self._iBigNumbers = 1;
    }
    
    CGFloat imageViewHeight = self.frame.size.height / ncolumnCount;
    CGFloat imageViewWidth  = self.frame.size.width  / ncolumnCount;
    
	for (int i = 0;i < channelCount ; i++) {
        
		JVCMonitorConnectionSingleImageView *singleVideoShow = [[JVCMonitorConnectionSingleImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageViewWidth, imageViewHeight)];
      
        singleVideoShow.layer.borderWidth=1.0;
        [singleVideoShow unSelectUIView];
        singleVideoShow.singleViewType=1;
        singleVideoShow.wheelShowType=1;
        singleVideoShow.delegate =self;
		[singleVideoShow initWithView];
		singleVideoShow.tag=KWINDOWSFLAG+i;
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingelTabFrom_FOUR:)];
		singleRecognizer.numberOfTapsRequired = 1; // 单击
		[singleVideoShow addGestureRecognizer:singleRecognizer];
        
        UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTabFrom:)];
		doubleRecognizer.numberOfTapsRequired = 2; // 双击
		[singleVideoShow addGestureRecognizer:doubleRecognizer];
		
		// 关键在这一行，如果双击确定偵測失败才會触发单击
		[singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
		[singleRecognizer release];
		[doubleRecognizer release];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedOncell:)];
        
        [singleVideoShow addGestureRecognizer:longPress];
        longPress.allowableMovement = NO;
        longPress.minimumPressDuration = 0.5;
        [longPress release];
        
        
        UISwipeGestureRecognizer *recognizer;
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [singleVideoShow addGestureRecognizer:recognizer];
        [recognizer release];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [singleVideoShow addGestureRecognizer:recognizer];
        [recognizer release];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [singleVideoShow  addGestureRecognizer:recognizer];
        [recognizer release];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [singleVideoShow  addGestureRecognizer:recognizer];
        
        [recognizer release];
        
//        //横屏隐藏横屏底端按钮
//        UITapGestureRecognizer *tapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenHorizontalScreenBar)];
//        [singleVideoShow addGestureRecognizer:tapGesture];
//        [tapGesture release];
        /**
         *  捏合的手势
         */
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(fingerpPinchGesture:)];
        [singleVideoShow  addGestureRecognizer:pinchGesture];
        [pinchGesture release];
        
        [WheelShowListView  addSubview:singleVideoShow];
        [singleVideoShow release];
    }
    
    [self isConnectAllStatus];
    
    [self changeContenView];
}

//隐藏下面的横屏帝都按钮
- (void)hidenHorizontalScreenBar
{
    JVCHorizontalScreenBar *horiBar = [JVCHorizontalScreenBar shareHorizontalBarInstance];

    if (horiBar.alpha == 0.0) {
        
        horiBar.alpha = 1.0f;
        
    }else{
    
        horiBar.alpha = 0.0f;
    }
}

/**
 *  判断当前界面是否为全连状态
 */
-(void)isConnectAllStatus{
    
    int count = [self channelCountAtSelectedYstNumber];
    
    if (self.isConnectAll) {
        
        if (count > showWindowNumberType_One && count <= showWindowNumberType_Four ) {
            
            self.imageViewNums = showWindowNumberType_Four;
            
        }else if (count > showWindowNumberType_Four && count <= showWindowNumberType_Nine ){
        
            self.imageViewNums = showWindowNumberType_Nine;
            
        }else if (count > showWindowNumberType_Nine && count <= showWindowNumberType_Sixteen) {
        
            self.imageViewNums = showWindowNumberType_Sixteen;
            
        }else if ( count > 0 && count <= showWindowNumberType_One) {
            
            self.imageViewNums = showWindowNumberType_One;
            
        }else if (count > showWindowNumberType_Sixteen ){
        
            self.imageViewNums = showWindowNumberType_Sixteen ;
            
        }else {
        
            self.imageViewNums = showWindowNumberType_One;
        }
    }
}

/**
 *  根据当前的索引返回云视通号
 *
 *  @return 当前选择的云视通号
 */
-(NSString *)ystNumberAtCurrentSelectedIndex{

    return self.strSelectedDeviceYstNumber;

}

/**
 *  根据索引返回云视通号
 *
 *  @return 当前选择的云视通号
 */
-(NSString *)ystNumberAtCurrentSelectedIndex:(int)nIndex{
    
    return self.strSelectedDeviceYstNumber;
    
}

- (void)setScrollviewByIndex:(NSInteger)Index
{
    CGPoint point = CGPointMake(Index*320, 0);
    
    [WheelShowListView setContentOffset:point animated:NO];
}

#pragma mark  手势的动作
- (void)fingerpPinchGesture:(UIPinchGestureRecognizer*)pinchGesture
{
    
    //横屏，进行云台控制，竖屏左右滑动scrollview
    
    int bDevieOrigin = [[UIApplication sharedApplication] statusBarOrientation];
    
    NSLog(@"handleSwipeFrom ==%d",bDevieOrigin);
    
    if (bDevieOrigin == UIInterfaceOrientationPortrait ||bDevieOrigin ==  UIInterfaceOrientationPortraitUpsideDown) {
        
        return;
    }
    
    NSLog(@"pinchGesture=%lf",pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        
    }else if(pinchGesture.scale<1) {//捏合缩小
        
        [self sendYTOperationWithOperationType:JVN_YTCTRL_BBX];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_BBXT];

    }else if(pinchGesture.scale>1)//捏合放大
    {
        [self sendYTOperationWithOperationType:JVN_YTCTRL_BBD];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_BBDT];
    }
    
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
  
    //横屏，进行云台控制，竖屏左右滑动scrollview
    
    int bDevieOrigin = [[UIApplication sharedApplication] statusBarOrientation];
    
    NSLog(@"handleSwipeFrom ==%d",bDevieOrigin);
    
    if (bDevieOrigin == UIInterfaceOrientationPortrait ||bDevieOrigin ==  UIInterfaceOrientationPortraitUpsideDown) {
        
        return;
    }
    
    // NSLog(@"Swipe received.");
    
    if (recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
    
        [self sendYTOperationWithOperationType:JVN_YTCTRL_D];
        usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_DT];

        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        [self sendYTOperationWithOperationType:JVN_YTCTRL_U];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_UT];

        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        [self sendYTOperationWithOperationType:JVN_YTCTRL_L];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_LT];

        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        [self sendYTOperationWithOperationType:JVN_YTCTRL_R];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_RT];

        
    }
}

-(void)longPressedOncell:(id)sender{
    
//    if (self.frame.size.height>=300.0||[_operationController returnIsplayBackVideo]) {
//        return;
//    }
//    
//    if ([(UILongPressGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
//        JVCMonitorConnectionSingleImageView *singleView=(JVCMonitorConnectionSingleImageView*)((UILongPressGestureRecognizer *)sender).view;
//        if (![singleView getActivity]) {
//            
//            for (int i=0; i<[amChannelListData count]; i++) {
//                JVCMonitorConnectionSingleImageView *imgView=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
//                // NSLog(@"value=%d",self.tag);
//                //NSLog(@"imgView=%@",imgView );
//                if (singleView.tag!=imgView.tag) {
//                    [imgView unSelectUIView];
//                }else {
//                    if (self.imageViewNums==1) {
//                        [imgView unSelectUIView];
//                    }else{
//                        
//                        [imgView selectUIView];
//                    }
//                    _operationController._iSelectedChannelIndex=i;
//                }
//            }
//            //[_operationController gotoDeviceShowChannels];
//        }
//    }
}

#pragma mark  向设备发送手势
/**
 *  云台操作的回调
 *
 *  @param YTJVNtype 云台控制的命令
 */
- (void)sendYTOperationWithOperationType:(int )YTJVNtype
{
    DDLogInfo(@"==%s===%d",__FUNCTION__,YTJVNtype);
    
    [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] RemoteOperationSendDataToDevice:self.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_YTO remoteOperationCommand:YTJVNtype];
}

/**
 *  设置scrollview滚动状态
 *
 *  @param scrollState 状态
 */
- (void)setManagePlayViewScrollState:(BOOL)scrollState
{
    WheelShowListView.scrollEnabled = scrollState;
}

/**
 *  双击选中事件
 *
 *  @param sender 选中的视频显示窗口
 */
-(void)handleDoubleTabFrom:(id)sender{
    
    JVCHorizontalScreenBar *horiBar = [JVCHorizontalScreenBar shareHorizontalBarInstance];

    if (horiBar.hidden == NO) {
        
        return;
    }
    
    UITapGestureRecognizer *viewimage=(UITapGestureRecognizer*)sender;
    
    int channelsCount = [self channelCountAtSelectedYstNumber];
    
    if (channelsCount <= 1) {
        
        return;
    }

    if (self.imageViewNums != self._iBigNumbers) {
        
        [_operationController reductionDefaultAudioAndTalkAndVideoBtnImage];
        
        int _views                 = self.imageViewNums;
        self.imageViewNums         = self._iBigNumbers;
        self._iBigNumbers          = _views;
        self.nSelectedChannelIndex =viewimage.view.tag-KWINDOWSFLAG;
        
        self.isShowVideo = TRUE;
        [self changeContenView];
        self.isShowVideo = FALSE;
    }
    
}

/**
 *  双击击选中事件
 *
 *  @param sender 选中的视频显示窗口
 */
-(void)handleSingelTabFrom_FOUR:(id)sender{
    

    UITapGestureRecognizer *viewimage=(UITapGestureRecognizer*)sender;
    JVCMonitorConnectionSingleImageView *_clickSingleView=(JVCMonitorConnectionSingleImageView*)viewimage.view;

    if ([_clickSingleView._glView._kxOpenGLView isHidden]) {
        
        return;
    }
    
    JVCHorizontalScreenBar *horiBar = [JVCHorizontalScreenBar shareHorizontalBarInstance];
    
    if (horiBar.alpha == 0.0) {
        
        horiBar.alpha = 1.0f;
        
    }else{
        
        horiBar.alpha = 0.0f;
    }

    
    if (showWindowNumberType_One ==self.imageViewNums) {
        

        if ([_operationController returnIsplayBackVideo]) {
            
            _clickSingleView._isPlayBackState=!_clickSingleView._isPlayBackState;
        }
        
        if (horiBar.hidden) {
            
            [_clickSingleView setVerticalContEntViewState:![_clickSingleView getVerticalContenViewState]];
        }
        
        return;
    }else{
        JVCMonitorConnectionSingleImageView *_clickSingleView=(JVCMonitorConnectionSingleImageView*)viewimage.view;

        [_clickSingleView setVerticalContEntViewState:YES];

    }
    
    
    if (viewimage.view.tag==KWINDOWSFLAG+self.nSelectedChannelIndex) {
        
        return;
    }
    
    int channelsCount = [self channelCountAtSelectedYstNumber];
    
    for (int i=0; i< channelsCount ; i++) {
        
        JVCMonitorConnectionSingleImageView *imgView = [self singleViewAtIndex:i];
        
        if (viewimage.view.tag!=imgView.tag) {
            
            [imgView unSelectUIView];
            
        }else {
            
            [imgView selectUIView];
            
            self.nSelectedChannelIndex=i;
        }
    }
}

#pragma mark scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
	int index=fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    
    if (self.nSelectedChannelIndex != index) {
        
        [_operationController reductionDefaultAudioAndTalkAndVideoBtnImage];
    }
    
    int channsCount = [self channelCountAtSelectedYstNumber];
    
    self._iCurrentPage=index;
    
    if (self.imageViewNums == showWindowNumberType_One) {
        
        if (self.nSelectedChannelIndex!=index) {
            
        }
    
        self.nSelectedChannelIndex=index;
        
    }else {
        
        self.nSelectedChannelIndex = index *self.imageViewNums;
        
        for (int i=0; i < channsCount; i++) {
            
            JVCMonitorConnectionSingleImageView *imgView = [self singleViewAtIndex:i];
            
            if (self.nSelectedChannelIndex != i) {
                
                [imgView unSelectUIView];
                
            }else {
                
                [imgView selectUIView];
            }
        }
    }
    
    [self connectSingleDevicesAllChannel];
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];
    
    [self refreshStreamType:singleView.nStreamType withIsHomeIPC:singleView.isHomeIPC effectType:singleView.iEffectType StorageType:singleView.nStorageType withOldStreamType:singleView.nOldStreamType];
    
    [NSThread detachNewThreadSelector:@selector(stopVideoOrFrame) toTarget:self withObject:nil];
}

-(void)dealloc{
    
    AppDelegate *delegateApp             = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegateApp.appDelegateVideoDelegate = nil;
    
    [amChannelListData release];
    [strSelectedDeviceYstNumber release];
    
    DDLogVerbose(@"%s-----------------------",__FUNCTION__);
    
    [super dealloc];
}


/**
 *  返回当前选择设备的通道个数
 *
 *  @return 当前选择设备的通道个数
 */
- (int)channelCountAtSelectedYstNumber {

    JVCChannelScourseHelper  *channelHelper       = [JVCChannelScourseHelper shareChannelScourseHelper];
    return [channelHelper channelModelWithDeviceYstNumber:self.strSelectedDeviceYstNumber].count;
}

/**
 *  获取指定索引的单个视图窗口
 *
 *  @param index 索引
 *
 *  @return 单个视图窗口
 */
-(JVCMonitorConnectionSingleImageView *)singleViewAtIndex:(int)index {
    
     return (JVCMonitorConnectionSingleImageView*)[self viewWithTag:KWINDOWSFLAG+index];
}

/**
 *  改变窗体布局
 */
-(void)changeContenView{
    
    int channelCount              = [self channelCountAtSelectedYstNumber];
    JVCAppHelper *apphelper       = [JVCAppHelper shareJVCAppHelper];

    WheelShowListView.frame=CGRectMake(0.0,0.0, self.frame.size.width, self.frame.size.height);
    
    int count    = channelCount;
    
    int pageNums = count/self.imageViewNums;
    
	if (count%self.imageViewNums != 0) {
        
		pageNums = pageNums+1;
	}
    
	CGSize newSize = CGSizeMake(self.frame.size.width*pageNums,self.frame.size.height);
	[WheelShowListView setContentSize:newSize];
    
    CGFloat  totalWidth      = self.frame.size.width;
    CGFloat  totalHeight     = self.frame.size.height;
    int      ncolumnCount    = sqrt(self.imageViewNums);
    CGFloat  imageViewHeight = totalHeight/ncolumnCount;
    CGFloat  imageViewWidth  = totalWidth/ncolumnCount;
    
	for (int i=0;i < count ; i++) {
        
        int pageIndex = i / self.imageViewNums;
        int index     = i % self.imageViewNums;
        
        CGRect rect;
        rect.size.width  = imageViewWidth ;
        rect.size.height = imageViewHeight;
        
        [apphelper viewInThePositionOfTheSuperView:totalWidth viewCGRect:rect nColumnCount:ncolumnCount viewIndex:index+1];
        
        rect.origin.x += totalWidth * pageIndex;
        
        JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:i];
		singleVideoShow.frame = rect;
        [singleVideoShow updateChangeView];
        [singleVideoShow unSelectUIView];
	}
    
    int positionIndex  = self.nSelectedChannelIndex;
    
    self._iCurrentPage = positionIndex;
    
    if (self.imageViewNums != showWindowNumberType_One ) {
        
        JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];
        
        [singleVideoShow selectUIView];
        
        positionIndex      = positionIndex/self.imageViewNums;
        self._iCurrentPage =positionIndex;
    }
    
    CGPoint position = CGPointMake(self.bounds.size.width*positionIndex,0);
	[WheelShowListView setContentOffset:position animated:NO];
    
    [self connectSingleDevicesAllChannel];
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];
    
    [self refreshStreamType:singleView.nStreamType withIsHomeIPC:singleView.isHomeIPC effectType:singleView.iEffectType StorageType:singleView.nStorageType withOldStreamType:singleView.nOldStreamType];
    
    [NSThread detachNewThreadSelector:@selector(stopVideoOrFrame) toTarget:self withObject:nil];
    
    if (showWindowNumberType_One !=self.imageViewNums) {
        
        JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];
        
        [singleView setVerticalContEntViewState:YES];
    }


}

#pragma mark 全连接处理

/**
 *  全连事件(子线程调用)
 */
-(void)connectSingleDevicesAllChannel{
	
    [NSThread detachNewThreadSelector:@selector(runConnectAllVideoByLocalChannelID) toTarget:self withObject:nil];
}

/**
 *  全连函数
 */
-(void)runConnectAllVideoByLocalChannelID{
    
    
    [self CancelConnectAllVideoByLocalChannelID];
    
    nAllLinkFlag   = CONNECTALLDEVICE_Run;
    
    int endIndex   = (self._iCurrentPage + 1) * self.imageViewNums;
    int startIndex =  self._iCurrentPage      * self.imageViewNums;
    int maxCount   = [self channelCountAtSelectedYstNumber];
    
    endIndex =  endIndex >= maxCount ? maxCount : endIndex;
    
    
    for (int i = startIndex; i < endIndex; i++) {
        
        if (isAllLinkRun) {
            
            isAllLinkRun = FALSE;
            nAllLinkFlag = CONNECTALLDEVICE_End;
            return;
        }
        
        [self connectVideoByLocalChannelID:KWINDOWSFLAG+i];
        
        if (i!=endIndex-1){
            
            usleep(CONNECTINTERVAL);
        }
    }
    
    nAllLinkFlag = CONNECTALLDEVICE_End;
}

/**
 *  取消全连事件 (子线程调用)
 */
-(void)CancelConnectAllVideoByLocalChannelID {
    
    if (nAllLinkFlag == CONNECTALLDEVICE_Run) {
        
        isAllLinkRun=true;
        
        while (true) {
            
            if (isAllLinkRun) {
                
                usleep(CONNECTINTERVAL);
                
            }else{
                
                isAllLinkRun=FALSE;
                break;
            }
        }
    }
}

#pragma mark monitorConnectionSingleImageView delegate

-(void)connectVideoCallBack:(int)nShowWindowID{
    
    [self connectVideoByLocalChannelID:nShowWindowID];
}

/**
 *  远程回放快进
 *
 *  @param nFrameValue 快进的帧数
 */
-(void)fastforwardToFrameValue:(int)nFrameValue{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:self.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_RemotePlaybackSEEK remoteOperationCommand:nFrameValue];
      
    });

}


#pragma mark 与网络库交互的功能模块 ystNetWorkHeper delegate

/**
 *  云视通连接的回调函数
 *
 *  @param connectCallBackInfo 连接的返回信息
 *  @param nlocalChannel       对应的本地通道
 *  @param connectResultType   连接返回的状态
 */
-(void)ConnectMessageCallBackMath:(NSString *)connectCallBackInfo nLocalChannel:(int)nlocalChannel connectResultType:(int)connectResultType{
    
    [connectCallBackInfo retain];
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:nlocalChannel-1];

    [singleView connectResultShowInfo:connectCallBackInfo connectResultType:connectResultType];
    
    /**
     *  返回的类型判断是否成功
     */
    if (connectResultType != CONNECTRESULTTYPE_Succeed ) {
        
        
        if (!singleView.isNewHomeIPC && singleView.nStreamType > 0) {
            
            [[JVCLogHelper shareJVCLogHelper] writeDataToFile:[self ystNumberAtCurrentSelectedIndex:nlocalChannel-1] fileType:LogType_ystNumber];
        }
        
        /**
         *判断断开的是不是当前的播放的窗口
         */
        if ( nlocalChannel-1 == self.nSelectedChannelIndex  ) {
            
            if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(connectVideoFailCallBack:)]) {
                
                [self.delegate connectVideoFailCallBack:connectResultType==CONNECTRESULTTYPE_VerifyFailed];
            }
        }
    }
    
    [connectCallBackInfo release];
}

/**
 *  根据所选显示视频的窗口的编号连接通道集合中指定索引的通道对象
 *
 *  @param nlocalChannelID 本地显示窗口的编号
 */
-(void)connectVideoByLocalChannelID:(int)nlocalChannelID{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCChannelScourseHelper             *channelSourceObj    = [JVCChannelScourseHelper shareChannelScourseHelper];
        NSMutableArray                      *channels            = [channelSourceObj channelModelWithDeviceYstNumber:self.strSelectedDeviceYstNumber];
        int                                  channelID           = nlocalChannelID - KWINDOWSFLAG + 1;
        JVCMonitorConnectionSingleImageView *singleView          = [self singleViewAtIndex:nlocalChannelID - KWINDOWSFLAG];
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        BOOL                                 connectStatus       = [ystNetWorkHelperObj checknLocalChannelExistConnect:channelID];
        JVCDeviceModel                      *deviceModel         = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:self.strSelectedDeviceYstNumber];
        int                                  channelIndex        = nlocalChannelID - KWINDOWSFLAG;
        
        [channels retain];
        
        JVCChannelModel                     *channelModel            = (JVCChannelModel *)[channels objectAtIndex:channelIndex];
        NSString                            *connectInfo             = [NSString stringWithFormat:@"%@-%d",channelModel.strNickName,channelModel.nChannelValue];
    
        //重复连接
        if (!connectStatus) {
            
            [singleView startActivity:connectInfo isConnectType:!deviceModel.linkType];
            
            if (deviceModel.linkType) {
                
                connectStatus = [ystNetWorkHelperObj ipConnectVideobyDeviceInfo:channelID nRemoteChannel:channelModel.nChannelValue  strUserName:deviceModel.userName strPassWord:deviceModel.passWord strRemoteIP:deviceModel.ip nRemotePort:[deviceModel.port intValue] nSystemVersion:IOS_VERSION isConnectShowVideo:self.isPlayBackVideo == TRUE ? FALSE : TRUE withConnectType:[[JVCLogHelper shareJVCLogHelper] checkYstNumberIsInYstNumbers:channelModel.strDeviceYstNumber] == YES ? TYPE_3GMOHOME_UDP : TYPE_3GMO_UDP];
                
                
               
            }else{
                
                connectStatus = [ystNetWorkHelperObj ystConnectVideobyDeviceInfo:channelID nRemoteChannel:channelModel.nChannelValue strYstNumber:channelModel.strDeviceYstNumber strUserName:deviceModel.userName strPassWord:deviceModel.passWord nSystemVersion:IOS_VERSION isConnectShowVideo:self.isPlayBackVideo == TRUE ? FALSE : TRUE withConnectType:[[JVCLogHelper shareJVCLogHelper] checkYstNumberIsInYstNumbers:channelModel.strDeviceYstNumber] == YES ? TYPE_3GMOHOME_UDP : TYPE_3GMO_UDP];
            }
        }
        
        [channels release];
    });
}

/**
 *  OpenGL显示的视频回调函数
 *
 *  @param nLocalChannel      本地显示窗口的编号
 *  @param imageBufferY       YUV数据中的Y数据
 *  @param imageBufferU       YUV数据中的U数据
 *  @param imageBufferV       YUV数据中的V数据
 *  @param decoderFrameWidth  视频的宽
 *  @param decoderFrameHeight 视频的高
 */
-(void)H264VideoDataCallBackMath:(int)nLocalChannel
                    imageBufferY:(char *)imageBufferY
                    imageBufferU:(char *)imageBufferU
                    imageBufferV:(char *)imageBufferV
               decoderFrameWidth:(int)decoderFrameWidth
              decoderFrameHeight:(int)decoderFrameHeight
       nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber
                   withVideoType:(BOOL)isVideoType{
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:nLocalChannel-1];
    
    if (isShowVideo || !isActive) {
        
        return;
    }
    
        
    dispatch_async(dispatch_get_main_queue(), ^{
    

        if ([JVCHorizontalScreenBar shareHorizontalBarInstance].hidden) {
            
            if (self.imageViewNums > showWindowNumberType_One) {//只有单屏的时候才显示
                
                [singleView hidenEffectBtn];
                
            }else{
                
                if (nLocalChannel == self.nSelectedChannelIndex + 1) {
                    
                    [singleView showEffectBtn];
                    
                }else{
                    
                    [singleView hidenEffectBtn];
                }
            }
            
        }else{
        
             [singleView hidenEffectBtn];
        }
    
    });
        
    [singleView setImageBuffer:imageBufferY imageBufferU:imageBufferU imageBufferV:imageBufferV decoderFrameWidth:decoderFrameWidth decoderFrameHeight:decoderFrameHeight nPlayBackFrametotalNumber:nPlayBackFrametotalNumber];
   
    [NSThread detachNewThreadSelector:@selector(stopVideoOrFrame) toTarget:self withObject:nil];
    
}

/**
 *  获取当前设备是否是05版编码的设备
 *
 *  @return YES:05
 */
-(BOOL)getCurrentSelectedSingelViewIs05Device{
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];
    
    return singleView.isNewDevice;
}

/**
 *  设置远程回放的进度条为最大值
 */
- (void)setCurrentSingleViewSlideToMaxNum
{
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];

    [singleView setSliderToMaxValue];
}
/**
 *  视频来O帧之后请求文本聊天
 *
 *  @param nLocalChannel 本地显示的通道编号 需减去1
 */
-(void)RequestTextChatCallback:(int)nLocalChannel withDeviceType:(int)nDeviceType withIsNvrDevice:(BOOL)isNvrDevice{
    
    JVCMonitorConnectionSingleImageView  *singleView          =  [self singleViewAtIndex:nLocalChannel-1];
    
    
    if (!isActive) {
        
        [self stopPlayVideoCallBack];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        if (self.isPlayBackVideo) {
            
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(RemotePlayBackVideo)]) {
                
                [self.delegate RemotePlayBackVideo];
            }
            
        }else {
        
            if (singleView.nStreamType == VideoStreamType_Default) {
                
                ystNetWorkHelperObj.ystNWTDDelegate  = self;
                
                [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
                [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
                
            }else {
                
                [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationType:TextChatType_paraInfo remoteOperationCommand:-1];
            }
        }
    });
}

/**
 *  文本聊天返回的回调
 *
 *  @param nYstNetWorkHelpTextDataType 文本聊天的状态类型
 *  @param objYstNetWorkHelpSendData   文本聊天返回的内容
 */
-(void)ystNetWorkHelpTextChatCallBack:(int)nLocalChannel withTextDataType:(int)nYstNetWorkHelpTextDataType objYstNetWorkHelpSendData:(id)objYstNetWorkHelpSendData
{
    
    switch (nYstNetWorkHelpTextDataType) {
            
        case TextChatType_paraInfo:{
            
            if ([objYstNetWorkHelpSendData isKindOfClass:[NSMutableDictionary class]]) {
                
                JVCMonitorConnectionSingleImageView  *singleView          =  [self singleViewAtIndex:nLocalChannel-1];
                [singleView.mdDeviceRemoteInfo addEntriesFromDictionary:(NSDictionary *)objYstNetWorkHelpSendData];
                
                if (nLocalChannel == self.nSelectedChannelIndex + 1) {
                    
                    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshDeviceRemoteInfoCallBack:)]) {
                        
                        [self.delegate refreshDeviceRemoteInfoCallBack:singleView.mdDeviceRemoteInfo];
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
}

/**
 *  判断设备是否是05和04的回调
 *
 *  @param nLocalChannel 本地显示的通道编号 需减去1
 *  @param nDeviceModel  设备的编码类型（YES:05）
 */
-(void)RequestTextChatIs05DeviceCallback:(int)nLocalChannel withDeviceModel:(BOOL)nDeviceModel {
    
    DDLogVerbose(@"%s---%d",__FUNCTION__,nDeviceModel);
    JVCMonitorConnectionSingleImageView  *singleView          =  [self singleViewAtIndex:nLocalChannel-1];
    singleView.isNewDevice                                    =  nDeviceModel;
}

/**
 *  文本聊天请求的结果回调
 *
 *  @param nLocalChannel 本地本地显示窗口的编号
 *  @param nStatus       文本聊天的状态
 */
-(void)RequestTextChatStatusCallBack:(int)nLocalChannel withStatus:(int)nStatus{

    if (nStatus == JVN_RSP_TEXTACCEPT) {
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWRODelegate                      = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationType:TextChatType_paraInfo remoteOperationCommand:-1];
            
        });
    }
}

/**
 *  获取当前连接通道的码流参数
 *
 *  @param nLocalChannel 本地连接通道编号
 *  @param nStreamType     码流类型  1:高清 2：标清 3：流畅 0:默认不支持切换码流
 */
-(void)deviceWithFrameStatus:(int)nLocalChannel withStreamType:(int)nStreamType withIsHomeIPC:(BOOL)isHomeIPC withEffectType:(int)effectType withStorageType:(int)storageType withIsNewHomeIPC:(BOOL)isNewHomeIPC withIsOldStreeamType:(int)nOldStreamType{
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:nLocalChannel-1];
    
    singleView.nStreamType                          = nStreamType;
    singleView.nOldStreamType                       = nOldStreamType;
    singleView.isHomeIPC                            = isHomeIPC;
    singleView.iEffectType                          = effectType;
    singleView.nStorageType                         = storageType;
    singleView.isNewHomeIPC                         = isNewHomeIPC;
    
    
    if (self.nSelectedChannelIndex + 1 == nLocalChannel) {
    
        [self refreshStreamType:nStreamType withIsHomeIPC:singleView.isHomeIPC effectType:singleView.iEffectType StorageType:storageType withOldStreamType:nOldStreamType];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [singleView updateEffectBtn:effectType&0x04];
        
    });
}



/**
 *  刷新当前码流参数信息
 *
 *  @param nStreamType 码流类型
 */
-(void)refreshStreamType:(int)nStreamType withIsHomeIPC:(BOOL)isHomeIPC  effectType:(int)effectType StorageType:(int)storageType withOldStreamType:(int)nOldStreamType{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(changeCurrentVidedoStreamType:withIsHomeIPC:withEffectType:withStorageType:withOldStreamType:)]) {
    
        [self.delegate changeCurrentVidedoStreamType:nStreamType withIsHomeIPC:isHomeIPC withEffectType:effectType withStorageType:storageType withOldStreamType:nOldStreamType];
    }
}

/**
 *  刷新当前图片翻转状态
 *
 *  @param nchannel   通道号（要减1）
 *  @param effectType 图像翻转状态
 */
-(void)refreshEffectType:(int)nLocalChannel  effectType:(int)effectType{
    
    if (effectType < 0) {
        
        return;
    }
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [singleView updateEffectBtn:effectType];

    });
}

/**
 *  停止视频和开启播放的回调
 */
-(void)stopVideoOrFrame {
    
     JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    /**
     *  视频只发I帧处理
     */
    [ystNetWorkHelperObj RemoteOperationSendDataToDeviceWithfullOrOnlyIFrame:self.imageViewNums > kPlayVideoWithFullFramCriticalValue];
    
     int channelCount  = [self channelCountAtSelectedYstNumber];  //返回当前的窗体个数
    
    int endIndex   = (self._iCurrentPage + 1) * self.imageViewNums;
    int startIndex =  self._iCurrentPage      * self.imageViewNums;

    for (int i = 0;i < channelCount ; i++) {
        
        if (i >= startIndex && i < endIndex) {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:i+1 remoteOperationCommand:JVN_CMD_VIDEO];
            
        }else {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:i+1 remoteOperationCommand:JVN_CMD_VIDEOPAUSE];
        }
	}
}

/**
 *  刷新当前图片翻转状态
 *
 *  @param enable   当前滚动视图是否可以滚动
 */
-(void)setScrollViewEnable:(BOOL)enable {

    WheelShowListView.scrollEnabled = enable;
}

/**
 *  音频监听回调
 *
 *  @param soundBuffer     音频数据
 *  @param soundBufferSize 音频数据大小
 *  @param soundBufferType 音频的类型
 */
-(void)playVideoSoundCallBackMath:(char *)soundBuffer soundBufferSize:(int)soundBufferSize soundBufferType:(BOOL)soundBufferType{
    
    [[OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance] openAudioFromQueue:(short *)soundBuffer dataSize:soundBufferSize playSoundType:soundBufferType == YES ? playSoundType_8k16B : playSoundType_8k8B];
}

/**
 *  隐藏旋转按钮
 */
- (void)hiddenEffectView
{
    JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[WheelShowListView viewWithTag:KWINDOWSFLAG+self.nSelectedChannelIndex];
    [singleVideoShow hidenEffectBtn];
    
}

/**
 *  显示旋转按钮
 */
- (void)showEffectView
{
    JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[WheelShowListView viewWithTag:KWINDOWSFLAG+self.nSelectedChannelIndex];
    [singleVideoShow showEffectBtn];
    
}

/**
 *  图像翻转按钮的回调
 */
- (void)effectTypeClickCallBack
{
    JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];

    [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper]RemoteOperationSendDataToDevice:self.nSelectedChannelIndex+1 remoteOperationType:TextChatType_EffectInfo remoteOperationCommand:(singleVideoShow.iEffectType&0x04) == EffectType_UP ? singleVideoShow.iEffectType|0x04:(singleVideoShow.iEffectType&(~0x04))];
    
}

/**
 *  获取当前设备是否是新的家用ipc
 *
 *  @return yes 新的 no Old
 */
- (BOOL)getCurrentIsOldHomeIPC
{
    JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];
    return singleVideoShow.isNewHomeIPC;
}

/**
 *  获取当前设备是否缓存
 *
 *  @return yes 存在 no Old
 */
- (BOOL)getCurrentIsLocalExist
{
    
    return [[JVCLogHelper shareJVCLogHelper] checkYstNumberIsInYstNumbers:[self ystNumberAtCurrentSelectedIndex]];
}


/**
 *  设置singleview的隐藏显示状态
 *
 *  @param state yes 隐藏  no 显示
 */
- (void)setSingleViewVerticalViewState:(BOOL)state
{
    JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];
    [singleVideoShow setVerticalContEntViewState:state];
}

/**
 *  设置singelview的云视通显示
 *
 *  @param string 文字
 */
- (void)setSingleViewVerticalViewLabelText:(NSString *)string
{
    JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];
    [singleVideoShow setlabelVerticalYSTText:string];
    
}

/**
 *  设置singleview的音量状态
 *
 *  @param state yes close no open
 */
- (void)setSingleViewVoiceBtnSelect:(BOOL)state
{
    JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];
    [singleVideoShow setVoliceBtnState:state];
}


/**
 *  设置singleview的音量状态
 *
 *  @param state yes close no open
 */
- (BOOL)getSingleViewVoiceBtnState
{
    JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];
   return  [singleVideoShow getVoliceBtnState];
}

/**
 *  返回voice的状态
 *
 *  @param state yes 选中  on 没有
 */
- (void)responseVoiceBtnEvent:(BOOL)state
{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSingleViewVoicebtnEvent:)]) {
        
        [self.delegate responseSingleViewVoicebtnEvent:state];
    }
}




@end
