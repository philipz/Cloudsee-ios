//
//  JVCMonitorConnectionSingleImageView.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMonitorConnectionSingleImageView.h"
#import "JVCCloudSEENetworkMacro.h"
#import "AppDelegate.h"
#import "GlView.h"
#import "JVCHorizontalScreenBar.h"
#import "JVCCloudSEENetworkHelper.h"
#import "UIImage+BundlePath.h"
@implementation JVCMonitorConnectionSingleImageView

@synthesize  singleViewType,wheelShowType,_isPlayBackState;
@synthesize _isConnectType,_glView,delegate;
@synthesize nStreamType,nOldStreamType,isHomeIPC;
@synthesize iEffectType,nStorageType,isNewDevice,isNewHomeIPC;
@synthesize mdDeviceRemoteInfo;

static const int  KVerticalHeight  = 44;
static const int  KVerticalViewTag = 133242;
static const int  kLabelOriginX    = 20;

int   _iConnectInfoIndex;
float min_offset;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
	    self.backgroundColor=[UIColor clearColor];
		sing_y=self.frame.origin.y;
		sing_x=self.frame.origin.x;
        _amConnectInfoList=[[NSMutableArray alloc] initWithCapacity:10];
        _iConnectInfoIndex=-1;
        self.iEffectType = -1;
        self.nStorageType = -1;
        int indexPath=arc4random()%100;
        [_amConnectInfoList addObject:[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"Connected with server ", nil),indexPath+1,NSLocalizedString(@" successfully...", nil)]];
        [_amConnectInfoList addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Asking for video data now...", nil)]];
        [_amConnectInfoList addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Asking for video data now, please wait...", nil)]];
        
        NSMutableDictionary *mdDeviceInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.mdDeviceRemoteInfo           = mdDeviceInfo;
        [mdDeviceInfo release];
    }
    
    return self;
}

-(void)initWithView{
    
    
    UIScrollView   *allImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    allImageScrollView.minimumZoomScale = 1.0;
    allImageScrollView.maximumZoomScale = 1.0;
    allImageScrollView.backgroundColor = [UIColor clearColor];
    allImageScrollView.delegate = self;
    allImageScrollView.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    allImageScrollView.tag = 109;
    [self addSubview:allImageScrollView];
    [allImageScrollView release];
    
	UIImageView *imgView =[[UIImageView alloc] init];
    
	imgView.frame=CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
	imgView.userInteractionEnabled=YES;
	imgView.backgroundColor=[UIColor clearColor];
	imgView.tag=101;
    
	UILabel *selectedSourceTV=[[UILabel alloc] init];
	selectedSourceTV.frame=CGRectMake(15.0,(self.frame.size.height-40.0)/2,self.frame.size.width-30.0, 40.0);
	selectedSourceTV.textColor=[UIColor greenColor];
	selectedSourceTV.font=[UIFont boldSystemFontOfSize:10];
	selectedSourceTV.adjustsFontSizeToFitWidth=YES;
	selectedSourceTV.numberOfLines=3;
	selectedSourceTV.tag=102;
	selectedSourceTV.backgroundColor=[UIColor clearColor];
	[imgView addSubview:selectedSourceTV];
	[selectedSourceTV release];
	
	UILabel *sourceTV=[[UILabel alloc] init];
	sourceTV.frame=CGRectMake(10.0, 5.0, self.frame.size.width-20.0, 16.0);
	sourceTV.textColor=[UIColor greenColor];
	sourceTV.font=[UIFont boldSystemFontOfSize:10];
	sourceTV.tag=103;
	sourceTV.textAlignment=UITextAlignmentRight;
	sourceTV.lineBreakMode=UILineBreakModeMiddleTruncation;
	sourceTV.backgroundColor=[UIColor clearColor];
	[imgView addSubview:sourceTV];
	[sourceTV release];
	
	UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] init];
	activity.frame=CGRectMake((self.frame.size.width-25.0)/2,(self.frame.size.height-25.0)/2, 25.0, 25.0);
	[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
	activity.tag=104;
	[imgView addSubview:activity];
	[activity release];
    
    [allImageScrollView addSubview:imgView];
    
	[imgView release];
    
    UILabel *connectInfoTV=[[UILabel alloc] init];
	connectInfoTV.frame=CGRectMake(10.0, activity.frame.origin.y+activity.frame.size.height, self.frame.size.width-20.0, 16.0);
	connectInfoTV.textColor=[UIColor greenColor];
	connectInfoTV.font=[UIFont boldSystemFontOfSize:10];
	connectInfoTV.tag=106;
	connectInfoTV.textAlignment=UITextAlignmentCenter;
	connectInfoTV.lineBreakMode=UILineBreakModeMiddleTruncation;
	connectInfoTV.backgroundColor=[UIColor clearColor];
	[imgView addSubview:connectInfoTV];
	[connectInfoTV release];
    [connectInfoTV setHidden:YES];
    
    viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - KVerticalHeight, self.width, KVerticalHeight)];
    viewContent.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    viewContent.tag = KVerticalViewTag;
    
    
    UIImage *effectImage=[UIImage imageNamed:@"effect_0.png"];
    
    UIButton *effectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    effectBtn.tag=108;
    effectBtn.frame=CGRectMake(self.frame.size.width-effectImage.size.width-10.0, (KVerticalHeight - effectImage.size.height)/2.0, effectImage.size.width, effectImage.size.height);
    [effectBtn setBackgroundImage:effectImage forState:UIControlStateNormal];
    effectBtn.alpha=0.8;
    [effectBtn addTarget:self action:@selector(effectClick) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:effectBtn];
    viewContent.hidden = YES;
    [self addSubview:viewContent];
    [viewContent release];
    
    effectBtn.hidden=YES;

    NSString *strVoice = [UIImage imageBundlePath:@"voc_open.png"];
    UIImage *imageVoice = [[UIImage alloc] initWithContentsOfFile:strVoice];
    
    NSString *strVoiceClose = [UIImage imageBundlePath:@"voc_close.png"];
    UIImage *imageVoiceClose = [[UIImage alloc] initWithContentsOfFile:strVoiceClose];
    
    btnVoice = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnVoice.frame = CGRectMake(effectBtn.left-  imageVoice.size.width -10, effectBtn.top, imageVoice.size.width, imageVoice.size.height);
    [btnVoice setImage:imageVoiceClose forState:UIControlStateNormal];
    [btnVoice setImage:imageVoice forState:UIControlStateSelected];
    [btnVoice addTarget:self action:@selector(clickVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:btnVoice];

    [imageVoice release];
    [imageVoiceClose release];
    
    labelVerticalYST = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, effectBtn.top, effectBtn.left, effectBtn.height)];
    labelVerticalYST.backgroundColor = [UIColor clearColor];
    labelVerticalYST.textColor = [UIColor whiteColor];
    [viewContent addSubview:labelVerticalYST];
    [labelVerticalYST release];
    
    
    UIImage *_playImage = [UIImage imageNamed:@"play_1.png"];
    
    UIButton *_bPlayVideoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _bPlayVideoBtn.frame=CGRectMake((self.frame.size.width-_playImage.size.width)/2.0, (self.frame.size.height-_playImage.size.height)/2, _playImage.size.width, _playImage.size.height);
    [_bPlayVideoBtn addTarget:self action:@selector(playVideoCilck) forControlEvents:UIControlEventTouchDown];
    [_bPlayVideoBtn setTag:105];
    [_bPlayVideoBtn setBackgroundImage:_playImage forState:UIControlStateNormal];
    [self addSubview:_bPlayVideoBtn];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(10.0, self.frame.size.height-50.0,self.frame.size.width-20, 20.0)];
    //访问UISlider的值
    //    [slider setValue:3 animated:YES];  //设置slider的值
    
    slider.minimumValue = 0.0;  //设置滑轮所能滚动到的最小值
    
    slider.maximumValue = 100.0;  //设置滑轮所能滚动到的最大值
    
    //设置UISlider的行为
    [slider addTarget:self action:@selector(fastforward:) forControlEvents:UIControlEventValueChanged];
    
    //为slider添加方法当slider的值改变时就会触发change方法
    slider.tag=107;
    slider.continuous = NO;
    [self addSubview:slider];
    [slider release];
    [slider setHidden:YES];
    
}

/**
 *	获得当前的视频窗口对应的GLView对象
 *
 */
-(void)getGlViewmodel{
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    int singleViewFlag = self.tag-KWINDOWSFLAG;
    int openGLViewFlag = singleViewFlag%(OPENGLMAXCOUNT);
    
    UIScrollView   *allImageScrollView = (UIScrollView*)[self viewWithTag:109];
    self._glView =(GlView*)[appDelegate._amOpenGLViewListData objectAtIndex:openGLViewFlag];
    
    [allImageScrollView addSubview:self._glView._kxOpenGLView];
    [self._glView updateDecoderFrame:self.bounds.size.width displayFrameHeight:self.bounds.size.height];
    [self._glView hiddenWithOpenGLView];
}


#pragma mark UIView中的UIImageView的选中与未选中边框颜色处理
-(void)selectUIView{
    
    self.layer.borderColor=  SETLABLERGBCOLOUR(48.0, 135.0, 240.0).CGColor;
	
}
-(void)unSelectUIView{
    
    self.layer.borderColor=SETLABLERGBCOLOUR(1.0, 14.0, 32.0).CGColor;
}

// 设置UIScrollView中要缩放的视图

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imgView =(UIImageView*)[self viewWithTag:101];
    
    return imgView;
    
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    UIImageView *imgView =(UIImageView*)[self viewWithTag:101];
    
    imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


-(void)playBackVideoNumber:(int)value{
    
    UISlider *slider=(UISlider*)[self viewWithTag:107];
    self._isPlayBackState=FALSE;
    [slider setMaximumValue:value];
    [slider setValue:0];
}

-(void)DoubleTap:(UITapGestureRecognizer*)recognizer
{
    if (!disFlag) {
        return;
    }
    
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:109];
    
    if (recognizer.view.frame.size.width<=self.frame.size.width) {
        
        [scrollView setZoomScale:2.0];
        
    }else{
        
        if (recognizer.view.frame.size.width>self.frame.size.width) {
            
            [scrollView setZoomScale:1.0];
            
		}
    }
}

#pragma 捏合放大的手势
- (void) handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    if (!disFlag) {
        return;
    }
    if([recognizer state]==UIGestureRecognizerStateEnded){
		
        lastScale=1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (lastScale - [recognizer scale]);
    
    // managePalyVideoComtroller *_managePlay=(managePalyVideoComtroller*)f_view;
    
    if (scale>1.0200&&recognizer.view.frame.size.width<=self.frame.size.width) {
        
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, 2.0, 2.0);
        
        //_managePlay.WheelShowListView.scrollEnabled=NO;
        
    }else{
        
        if (scale<0.9800&&recognizer.view.frame.size.width>self.frame.size.width) {
            
			CGAffineTransform currentTransform = recognizer.view.transform;
			CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 0.5, 0.5);
			[recognizer.view setTransform:newTransform];
            recognizer.view.frame=CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
            //_managePlay.WheelShowListView.scrollEnabled=YES;
		}
    }
    
    lastScale=[recognizer scale];
}

#pragma 拖动的手势
- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    if (!disFlag) {
        
        return;
    }
    
    UIImageView *piece =(UIImageView*) [recognizer view];
	
	if (recognizer.view.frame.size.width<=self.frame.size.width&&recognizer.view.frame.size.height<=self.frame.size.height) {
		return;
	}
	if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
		
		
		CGPoint translation = [recognizer translationInView:[piece superview]];
		CGFloat x=[piece center].x+translation.x;
		CGFloat y=[piece center].y+translation.y;
		CGFloat _startx=piece.frame.origin.x;
		CGFloat _starty=piece.frame.origin.y;
		[piece setCenter:CGPointMake(x, y)];
		
		[recognizer setTranslation:CGPointZero inView:[piece superview]];
		
		CGFloat _endx=piece.frame.origin.x;
		CGFloat _endy=piece.frame.origin.y;
		CGFloat _width=self.frame.size.width;
		CGFloat _height=self.frame.size.height;
        //_managePlay.WheelShowListView.scrollEnabled=NO
		if (_endx-_startx<=0) {
            
			if (piece.frame.origin.x+piece.frame.size.width<_width) {
			    [UIView beginAnimations:@"move" context:nil];
			    [UIView setAnimationDuration:0.5];
			    piece.frame=CGRectMake(-(piece.frame.size.width-_width), piece.frame.origin.y, piece.frame.size.width, piece.frame.size.height);
			    [UIView commitAnimations];
			}
            
		}else{
            
			if (piece.frame.origin.x+piece.frame.size.width>piece.frame.size.width) {
			    [UIView beginAnimations:@"move" context:nil];
			    [UIView setAnimationDuration:0.5];
			    piece.frame=CGRectMake(0, piece.frame.origin.y, piece.frame.size.width, piece.frame.size.height);
			    [UIView commitAnimations];
			}
		}
		if(_endy-_starty<=0){
            
            if (piece.frame.origin.y+piece.frame.size.height<_height) {
                [UIView beginAnimations:@"move" context:nil];
                [UIView setAnimationDuration:0.5];
                piece.frame=CGRectMake(piece.frame.origin.x, -(piece.frame.size.height-_height), piece.frame.size.width, piece.frame.size.height);
                [UIView commitAnimations];
            }
            
		}else {
            
			if (piece.frame.origin.y+piece.frame.size.height>piece.frame.size.height) {
				[UIView beginAnimations:@"move" context:nil];
				[UIView setAnimationDuration:0.5];
				piece.frame=CGRectMake(piece.frame.origin.x, 0, piece.frame.size.width, piece.frame.size.height);
				[UIView commitAnimations];
			}
		}
	}
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)updateChangeView{
    
    sing_y=self.frame.origin.y;
    sing_x=self.frame.origin.x;
    
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:109];
    [scrollView setZoomScale:1.0];
    
    [scrollView setContentSize: CGSizeMake(self.frame.size.width, self.frame.size.height)];
    scrollView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    
    UIImageView *imgView =(UIImageView*)[self viewWithTag:101];
	imgView.frame=CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    [self._glView updateDecoderFrame:self.frame.size.width displayFrameHeight:self.frame.size.height];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imgView =(UIImageView*)[self viewWithTag:101];
    imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    
    UILabel *selectedSourceTV=(UILabel*)[imgView viewWithTag:102];
	selectedSourceTV.frame=CGRectMake(15.0,(self.frame.size.height-40.0)/2,self.frame.size.width-30.0, 40.0);
	UILabel *sourceTV=(UILabel*)[imgView viewWithTag:103];
	sourceTV.frame=CGRectMake(10.0, 5.0, self.frame.size.width-20.0, 16.0);
    UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[imgView viewWithTag:104];
	activity.frame=CGRectMake((self.frame.size.width-25.0)/2,(self.frame.size.height-25.0)/2, 25.0, 25.0);
    
    
    
    NSMutableString *_imageNameString=[[NSMutableString alloc] initWithCapacity:10];
    
    UIView *superView = [self superview];
    int imageViewNums = superView.frame.size.width / self.frame.size.width;
    [_imageNameString appendFormat:@"play_%d.png",imageViewNums];
    UIImage *_playImageBg=[UIImage imageNamed:_imageNameString];
    [_imageNameString release];
    
    UIButton *_bPlayVideoBtn=(UIButton*)[self viewWithTag:105];
    [_bPlayVideoBtn setImage:_playImageBg forState:UIControlStateNormal];
    _bPlayVideoBtn.frame= CGRectMake((self.frame.size.width-_playImageBg.size.width)/2.0, (self.frame.size.height-_playImageBg.size.height)/2, _playImageBg.size.width, _playImageBg.size.height);
    
    UILabel *connectInfoTV=(UILabel*)[self viewWithTag:106];
	connectInfoTV.frame=CGRectMake(10.0, activity.frame.origin.y+activity.frame.size.height, self.frame.size.width-20.0, 16.0);
    
    UISlider *slider=(UISlider*)[self viewWithTag:107];
    slider.frame=CGRectMake(10.0, self.frame.size.height-50.0,self.frame.size.width-20.0, 20.0);
}

-(void)hiddenSlider{

    UISlider *slider=(UISlider*)[self viewWithTag:107];
    [slider setValue:0.0];
    [slider setHidden:YES];
    
    [self setEffectBtnState:NO];
}

///**
// *  04版主控的显示方式
// *
// *  @param imageBuffer               YUV数据
// *  @param decoderFrameWidth         解码的宽
// *  @param decoderFrameHeight        解码的高
// *  @param nPlayBackFrametotalNumber 远程回放的数据
// */
//-(void)setOldImageBuffer:(char *)imageBuffer decoderFrameWidth:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber{
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        UILabel *connectInfoTV = (UILabel*)[self viewWithTag:106];
//        
//        if (!connectInfoTV.hidden) {
//            
//            connectInfoTV.hidden = !connectInfoTV.hidden;
//        }
//        
//        UIButton *_bPlayVideoBtn=(UIButton*)[self viewWithTag:105];
//        [_bPlayVideoBtn setHidden:YES];
//        
//        NSData *imageData     = [NSData dataWithBytes:imageBuffer length:decoderFrameWidth*decoderFrameHeight*2+66];
//        UIImage *image        = [UIImage imageWithData:imageData];
//        UIImageView *imgView  = (UIImageView *)[self viewWithTag:101];
//        
//        [imgView setImage:image];
//        
//        JVCCloudSEENetworkHelper *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
//        
//        DDLogVerbose(@"%s-----------------tag=%d",__FUNCTION__,self.tag -KWINDOWSFLAG + 1);
//        
//        [ystNetworkObj RemoteOperationSendDataToDevice:self.tag -KWINDOWSFLAG + 1 remoteOperationType:RemoteOperationType_oldDeviceNextVideoFrame remoteOperationCommand:-1];
//    });
//}


/**
 *  05版主控的显示方式
 *
 *  @param imageBufferY              Y数据
 *  @param imageBufferU              U数据
 *  @param imageBufferV              V数据
 *  @param decoderFrameWidth         解码的宽
 *  @param decoderFrameHeight        解码的高
 *  @param nPlayBackFrametotalNumber 远程回放的总帧数
 */
-(void)setImageBuffer:(char*)imageBufferY imageBufferU:(char*)imageBufferU imageBufferV:(char*)imageBufferV decoderFrameWidth:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (decoderFrameHeight<=0) {
            
            disFlag=FALSE;
            UIImageView *imgView =(UIImageView*)[self viewWithTag:101];
            [imgView setImage:nil];
            UIButton *_bPlayVideoBtn=(UIButton*)[self viewWithTag:105];
            [_bPlayVideoBtn setHidden:NO];
            UISlider *slider=(UISlider*)[self viewWithTag:107];
            [slider setValue:0.0];
            [slider setMaximumValue:0.0];
            [slider setHidden:YES];
            
            if (![self._glView._kxOpenGLView isHidden]) {
                
                [self._glView hiddenWithOpenGLView];
                [self bringSubviewToFront:imgView];
        
                [self setEffectBtnState:YES];
            }
            
        }else {
            
            UILabel *connectInfoTV = (UILabel*)[self viewWithTag:106];
            
            if (!connectInfoTV.hidden) {
                
                connectInfoTV.hidden = !connectInfoTV.hidden;
            }
            
            UIButton *_bPlayVideoBtn=(UIButton*)[self viewWithTag:105];
            [_bPlayVideoBtn setHidden:YES];
            
            
            UISlider *slider = (UISlider*)[self viewWithTag:107];
            
            if (nPlayBackFrametotalNumber > 0) {
                
                if (slider.hidden) {
                    
                     [slider setMaximumValue:nPlayBackFrametotalNumber];
                     [slider setHidden:NO];
                    
                }else{
                
                     [slider setValue:slider.value+1];
                }

                [self setEffectBtnState:YES];

                self._isPlayBackState=FALSE;
                
            }else{
                
                [slider setHidden:YES];
            }
            
            [self._glView decoder:(char*)imageBufferY imageBufferU:(char*)imageBufferU imageBufferV:(char*)imageBufferV decoderFrameWidth:decoderFrameWidth decoderFrameHeight:decoderFrameHeight];
            
            if ([self._glView._kxOpenGLView isHidden]) {
                
                [self._glView._kxOpenGLView setHidden:NO];
                [self bringSubviewToFront:self._glView._kxOpenGLView];
                
                [self setEffectBtnState:NO];
            }
            
            disFlag=YES;
        }
        
    });
    
}

/**
 *  设置进度条到默认进度条
 */
- (void)setSliderToMaxValue
{
    UISlider *slider = (UISlider*)[self viewWithTag:107];

    [slider setValue:slider.maximumValue];

}

/**
 *  开始连接
 *
 *  @param connectChannelInfo 连接的通道信息
 *  @param isConnectType      连接的类型（YES：YST NO：IP）
 */
-(void)startActivity:(NSString*)connectChannelInfo isConnectType:(BOOL)isConnectType{
    
    self._isConnectType = isConnectType;
    
    [self runSetConnectDeviceInfo:connectChannelInfo];
    
    [self performSelectorOnMainThread:@selector(startActivityShow) withObject:nil waitUntilDone:YES];
}

/**
 *  执行显示连接的通道的信息
 *
 *  @param connectInfo 显示连接的通道的信息
 */
-(void)runSetConnectDeviceInfo:(NSString *)connectInfo{
    
    [connectInfo retain];
    
    [self performSelectorOnMainThread:@selector(setConnectDeviceInfo:) withObject:connectInfo waitUntilDone:YES];
    
    [connectInfo release];
}

/**
 *  显示连接的通道的信息
 *
 *  @param connectInfo 通道的信息
 */
-(void)setConnectDeviceInfo:(NSString *)connectInfo{
    
    UILabel *sourceTV=(UILabel*)[self viewWithTag:103];
    sourceTV.text=[NSString stringWithFormat:@"%@",connectInfo];
    sourceTV.hidden=YES;
    [self bringSubviewToFront:sourceTV];
    
    labelVerticalYST.text = connectInfo;
    
    UILabel *selectedSourceTV=(UILabel*)[self viewWithTag:102];
    selectedSourceTV.text=[NSString stringWithFormat:@"%@",@""];
    [selectedSourceTV setHidden:YES];
    UIButton *_bPlayVideoBtn=(UIButton*)[self viewWithTag:105];
    [_bPlayVideoBtn setHidden:YES];
    UILabel *connectInfoTV=(UILabel*)[self viewWithTag:106];
    [connectInfoTV setHidden:NO];
    
}

-(void)startActivityShow {
    
    UIImageView *imgView =(UIImageView*)[self viewWithTag:101];
    UIActivityIndicatorView *activity =(UIActivityIndicatorView*)[imgView viewWithTag:104];
    activity.hidden=NO;
    [activity startAnimating];
    [self bringSubviewToFront:activity];
    
    [self getGlViewmodel];
    
    if (self._isConnectType) {
        
        [self startChangeTimer];
        
    }else{
        
        UILabel *connectInfoTV=(UILabel*)[self viewWithTag:106];
        
        connectInfoTV.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Asking for video data now...", nil)];
    }
}

-(void)startChangeTimer{
    
    
    UILabel *connectInfoTV=(UILabel*)[self viewWithTag:106];
    
    _tConnectInfoTimer=[NSTimer
                        scheduledTimerWithTimeInterval:2.0
                        target:self
                        selector:@selector(changeConnectInfo:)
                        userInfo:nil repeats:YES];
    
    connectInfoTV.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Connecting with server now...", nil)];
    
}

-(void)changeConnectInfo:(NSTimer*)timer{
    
    _iConnectInfoIndex++;
    if (_iConnectInfoIndex==[_amConnectInfoList count]) {
        
        [timer invalidate];
        timer=nil;
        _tConnectInfoTimer=nil;
        _iConnectInfoIndex=-1;
        
    }else{
        
        UILabel *connectInfoTV=(UILabel*)[self viewWithTag:106];
        connectInfoTV.text=[NSString stringWithFormat:@"%@",[_amConnectInfoList objectAtIndex:_iConnectInfoIndex]];
    }
    
}


-(NSString*)getConnectChannelInfo{
    
	UILabel *sourceTV=(UILabel*)[self viewWithTag:103];
	return sourceTV.text;
}

-(BOOL)getActivity{
	UIActivityIndicatorView *activity =(UIActivityIndicatorView*)[self viewWithTag:104];
	return activity.isAnimating;
}

- (void)dealloc {
    
    //[self removeAllSubviews];
    [_amConnectInfoList release];
    [mdDeviceRemoteInfo release];
    [_glView release];
    _glView=nil;
    [super dealloc];
    
}


/**
 *  网络连接返回的连接状态和对应
 *
 *  @param connectResultText 连接返回的信息
 *  @param connectResultType 连接返回的类型
 */
-(void)connectResultShowInfo:(NSString *)connectResultText  connectResultType:(int)connectResultType {
    
    
    [connectResultText retain];
    
    NSMutableString *connectResultInfo = [[NSMutableString alloc] initWithCapacity:10];
    
    DDLogVerbose(@"%s=====connectResultType=%d",__FUNCTION__,connectResultType);
    switch (connectResultType) {
            
        case  CONNECTRESULTTYPE_ConnectFailed:
        case  CONNECTRESULTTYPE_AbnormalConnectionDisconnected: //Disconnected Due To CloudSEE Service Has Been Stopped
        case  CONNECTRESULTTYPE_ServiceStop:                    //"Disconnected Due To CloudSEE Service Has Been Stopped"
        case  CONNECTRESULTTYPE_DisconnectFailed:               //Connection Failed
        case  CONNECTRESULTTYPE_YstServiceStop:                  //CloudSEE Service Has Been Stopped
        case  CONNECTRESULTTYPE_VerifyFailed:                      //身份验证不成功
        case  CONNECTRESULTTYPE_ConnectMaxNumber:
        case CONNECTRESULTTYPE_ChannelIsNotOpen:{
            
            NSString *localInfoKey=[NSString  stringWithFormat:@"connectResultInfo_%d",connectResultType];
            
            [connectResultInfo appendString:NSLocalizedString(localInfoKey, nil)];
            
            [self runStopActivity:connectResultInfo];
            [self performSelectorOnMainThread:@selector(playButtonShow) withObject:nil waitUntilDone:YES];
        }
            
            break;
        case CONNECTRESULTTYPE_Succeed:{
            
            [self runStopActivity:connectResultInfo];
            
        }
            break;
            
        case CONNECTRESULTTYPE_Disconnect:{
            
            [self runStopActivity:connectResultInfo];
            [self performSelectorOnMainThread:@selector(playButtonShow) withObject:nil waitUntilDone:YES];
            
        }
            break;
            
        default:{
        
        }
            break;
    }
    
    [connectResultInfo release];
    [connectResultText release];
}

/**
 *  视频播放的事件
 */
-(void)playVideoCilck{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(connectVideoCallBack:)]) {
        
        [self.delegate connectVideoCallBack:self.tag];
    }
}

/**
 *  传递btn的选中状态
 *
 *  @param btn voice btn
 */
- (void)clickVoiceBtn:(UIButton *)btn
{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseVoiceBtnEvent:)]) {
        
        [self.delegate responseVoiceBtnEvent:btn.selected];
    }
}

/**
 *  远程回放快进
 *
 *  @param sender 快进的UI 对象
 */
-(void)fastforward:(UISlider*)sender{
    
    int frameNumber = [[NSString stringWithFormat:@"%lf",sender.value] intValue];
    
    if (frameNumber <= 0) {
        
        frameNumber = 1;
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(fastforwardToFrameValue:)]) {
        
        [self.delegate fastforwardToFrameValue:frameNumber];
    }
}

/**
 *  停止Activity旋转
 *
 *  @param connectInfo 提示的信息
 */
-(void)runStopActivity:(NSString*)connectInfo {
    
    [connectInfo retain];
    
    [self performSelectorOnMainThread:@selector(stopActivity:) withObject:connectInfo waitUntilDone:YES];
    
    [connectInfo release];
}

-(void)stopActivity:(NSString*)connectInfo{
    
    [self.mdDeviceRemoteInfo removeAllObjects];
    
	UIImageView *imgView =(UIImageView*)[self viewWithTag:101];
    
	UIActivityIndicatorView *activity =(UIActivityIndicatorView*)[imgView viewWithTag:104];
    
//    labelVerticalYST.text = @"";
    
	if (activity.isAnimating) {
        
		[activity stopAnimating];
        
        if (_iConnectInfoIndex!=-1&&!self._isConnectType) {
            
            if (_tConnectInfoTimer!=nil) {
                
                if (_tConnectInfoTimer!=nil) {
                    
                    if ([_tConnectInfoTimer isValid]) {
                        [_tConnectInfoTimer invalidate];
                        _tConnectInfoTimer=nil;
                        
                    }
                }
            }
            
            _iConnectInfoIndex=-1;
        }
	}
    
    if (connectInfo.length > 0 ) {
        
        UILabel *connectInfoTV = (UILabel*)[self viewWithTag:106];
        connectInfoTV.text     = @"";
        connectInfoTV.hidden   = YES;
        
    }else{
        
        UILabel *connectInfoTV = (UILabel*)[self viewWithTag:106];
       connectInfoTV.text     = LOCALANGER(@"JVCMonitorConnectionSingleImageView_connecting");
    }

	UILabel *selectedSourceTV=(UILabel*)[self viewWithTag:102];
	selectedSourceTV.text=[NSString stringWithFormat:@"%@",connectInfo];
	[selectedSourceTV setHidden:NO];
    
    [self bringSubviewToFront:selectedSourceTV];
}

/**
 *  显示播放按钮
 */
-(void)playButtonShow{
    
    UIImageView *imgView =(UIImageView*)[self viewWithTag:101];
    [imgView setImage:nil];
    UIButton *_bPlayVideoBtn=(UIButton*)[self viewWithTag:105];
    [_bPlayVideoBtn setHidden:NO];
    UISlider *slider=(UISlider*)[self viewWithTag:107];
    [slider setValue:0.0];
    [slider setMaximumValue:0.0];
    [slider setHidden:YES];
    [self._glView hiddenWithOpenGLView];
    [self bringSubviewToFront:imgView];

    [self hidenEffectBtn];
}

/**
 *  设置图像翻转的按钮的状态
 *
 *  @param state 状态
 */
- (void)setEffectBtnState:(BOOL)state
{
    
    
    UIButton *effectBtn=(UIButton*)[self viewWithTag:108];
    
    if (viewContent.hidden) {
        return;
    }
    
    if ( self.iEffectType == -1 ) {
        
        return;
    }
        
    effectBtn.hidden=state;
   
    [self bringSubviewToFront:effectBtn];

}

/**
 *  横屏的时候隐藏旋转按钮
 */
- (void)hidenEffectBtn
{
    [self setEffectBtnState:YES];
}

/**
 *  横屏的时候隐藏旋转按钮
 */
- (void)showEffectBtn
{
    UISlider *slider = (UISlider*)[self viewWithTag:107];
    
    if([JVCHorizontalScreenBar shareHorizontalBarInstance].hidden == YES && slider.hidden)
    {
        [self setEffectBtnState:NO];

    }else{
    
        [self setEffectBtnState:YES];
    }
}

/**
 *  设置竖屏条的状态
 *
 *  @param state yes 显示  no 不显示
 */
- (void)setVerticalContEntViewState:(BOOL)state
{
    
    viewContent.hidden = state;
}

/**
 *  设置显示的云视通号
 *
 *  @param string 内容
 */
- (void)setlabelVerticalYSTText:(NSString *)string
{
    labelVerticalYST.text = string;
}
/**
 *  返回竖屏条的状态
 *
 *  @return yes 显示  no  隐藏
 */
- (BOOL)getVerticalContenViewState
{
    return viewContent.hidden ;
}

/**
 *  刷新按钮选择状态
 *
 *  @param flagVale 状态
 */
-(void)updateEffectBtn:(int)flagVale{
    
    [self showEffectBtn];
    
    UIButton *effectBtn=(UIButton*)[self viewWithTag:108];
    UIImage *effectImage=[UIImage imageNamed:[NSString stringWithFormat:@"effect_%d.png",flagVale]];
    
    [effectBtn setBackgroundImage:effectImage forState:UIControlStateNormal];
}

- (void)effectClick
{

    if (delegate !=nil &&[delegate respondsToSelector:@selector(effectTypeClickCallBack)]) {
        
        [delegate effectTypeClickCallBack];
    }
}

/**
 *  设备按钮选中状态
 *
 *  @param state yes 选中  no 没有选中
 */
- (void)setVoliceBtnState:(BOOL)state
{
    btnVoice.selected = state;
}

/**
 *  获取设备按钮选中状态
 *
 *  @param state yes 选中  no 没有选中
 */
- (BOOL)getVoliceBtnState
{
    return  btnVoice.selected;
}

@end
