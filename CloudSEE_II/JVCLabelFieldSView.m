//
//  JVCLabelFieldSView.m
//  CloudSEE_II
//  label和TextField的view
//  Created by Yanghu on 10/11/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLabelFieldSView.h"
#import "JVCRGBHelper.h"
#import "JVCRGBColorMacro.h"

@interface JVCLabelFieldSView ()
{
    NSArray *arrayLabelTitiles;           //存放label名称的数组
    NSArray *arrayTextFields;             //存放textfiel的数组
    UIButton *btnClick;                   // 按钮
    NSMutableArray *textFieldAllocArray;  //存放textfield的数组
}

@end
@implementation JVCLabelFieldSView
@synthesize delegate;

static const float KLabelOriginX    = 15;//距离左侧的距离
static const float KLabelOriginY    = 30;//距离顶端的距离
static const float KLabelWith       = 70;//距离顶端的距离
static const float KSpan            = 15;//label之间的距离
static const float KLabelFieldSpan  = 5;//label与textfield之间的距离
static const int   KLabelFont       = 16;//label的字体大小
static const int   KLabelFontEN       = 14;//label的字体（英文环境下）

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initViewWithTitlesArray:(NSArray *)titleArray
{
    self.userInteractionEnabled =YES;
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.bounds];
    NSLog(@"%@==%@",NSStringFromCGRect(control.frame),NSStringFromCGRect(self.bounds));
    [control addTarget:self action:@selector(backGroundClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    [control release];
    
    textFieldAllocArray = [[NSMutableArray alloc] init];
    
    arrayLabelTitiles = [titleArray retain];
    
    NSString *strImage = [UIImage imageBundlePath:@"con_fieldUnSec.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:strImage];
    
    CGRect frameTextFildButton ;
    
    for (int i=0; i<arrayLabelTitiles.count; i++) {
        
        UILabel *label = nil;
    
        
        UIColor *colorlabel = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:KLickTypeLeftLabelColor] ;
        UIColor *colortextfield = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:KLickTypeTextFieldColor] ;

        
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(KLabelOriginX, KLabelOriginY+(image.size.height+KSpan)*i, KLabelWith, image.size.height);
        label.text = [arrayLabelTitiles objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        if (colorlabel) {
            label.textColor = colorlabel;
        }
        if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
            
            label.font = [UIFont systemFontOfSize:KLabelFont];

        }else{
            label.font = [UIFont systemFontOfSize:KLabelFontEN];
            label.frame = CGRectMake(KLabelOriginX-8, KLabelOriginY+(image.size.height+KSpan)*i, KLabelWith+8, image.size.height);


        }
        [self addSubview:label];
        [label release];
        
        UILabel *labelLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabelFieldSpan, image.size.height)];
        
        labelLeftView.backgroundColor = [UIColor clearColor];
        UITextField *textField ;// [arrayTextFields objectAtIndex:i];
        textField = [[UITextField alloc] initWithFrame:CGRectMake(label.right+KLabelFieldSpan, label.top, image.size.width, image.size.height)];
        textField.backgroundColor = [UIColor colorWithPatternImage:image];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.returnKeyType = UIReturnKeyDone;
        textField.leftView = labelLeftView;
        if (colortextfield) {
            
            textField.textColor = colortextfield;

        }
        [labelLeftView release];
        [self addSubview:textField];
        
        frameTextFildButton = textField.frame;
        
        [textFieldAllocArray addObject:textField];
        [textField release];
        
    }
    
    NSString *btnPath = [UIImage imageBundlePath:@"con_Btn.png"];
    UIImage *imagebtn = [[UIImage alloc] initWithContentsOfFile:btnPath];
    btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClick.frame = CGRectMake(frameTextFildButton.origin.x, frameTextFildButton.origin.y+frameTextFildButton.size.height+KSpan+5, frameTextFildButton.size.width, imagebtn.size.height+10);
    [btnClick setTitle:LOCALANGER(@"JVCLabelFieldSView_save") forState:UIControlStateNormal];
    [btnClick setBackgroundImage:imagebtn forState:UIControlStateNormal];
    [btnClick addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClick];
    [image release];
    [imagebtn release];
}

/**
 *  按钮按下的回调
 */
- (void)editBtnClick
{
    if (delegate !=nil && [delegate respondsToSelector:@selector(JVCLabelFieldBtnClickCallBack)]) {
        [delegate JVCLabelFieldBtnClickCallBack];
    }
}

- (void)backGroundClick
{
    if (delegate !=nil && [delegate respondsToSelector:@selector(touchUpInsiderBackGroundCallBack)]) {
        [delegate touchUpInsiderBackGroundCallBack];
    }
}

/**
 *  获取指定的textField
 *
 *  @param index 第几个
 *
 *  @return 指定的textfield
 */
- (UITextField *)textFieldWithIndex:(int)index
{
    if (index>=textFieldAllocArray.count) {
        
        return nil;
    }else
    {
        return [textFieldAllocArray objectAtIndex:index];
    }
}

- (void)dealloc
{
    [textFieldAllocArray release];
    [arrayLabelTitiles release];
    
    [UITextField release];
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
