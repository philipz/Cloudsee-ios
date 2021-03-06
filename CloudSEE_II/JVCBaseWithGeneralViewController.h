//
//  JVCBaseWithGeneralViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-29.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCBaseWithGeneralViewController : UIViewController
{
    NSString *tenCentKey;
}
@property(nonatomic,retain)  NSString *tenCentKey;
/**
 *  视图可见时加载的view
 */
- (void)initLayoutWithViewWillAppear;

/**
 *  视图不可见时释放的View
 */
-(void)deallocWithViewDidDisappear;

/**
 *  点击返回事件，如果有其他的处理方法，子类可以重写父类的方法
 */
- (void)BackClick;

/**
 *  根据图片大小返回一个UImageView
 *
 *  @param imageName 图片的名称
 *
 *  @return 返回一个图片大小的ImageView
 */
-(UIImageView *)imageViewWithImageName:(NSString *)imageName;

@end
