//
//  TRCustomAlert.m
//  AlertTroila
//
//  Created by Admin on 2018/9/20.
//  Copyright © 2018年 马银伟. All rights reserved.
//  Version: 0.2.2

#import "TRCustomAlert.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
//屏幕宽高
#define TR_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define TR_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//主题颜色
static NSString * const MainColor = @"#586BFB";
//当前界面的样式
typedef NS_ENUM(NSInteger, AlertType) {
    AlertTypeSimple,//简单样式
    AlertTypeButton,//按钮样式b
    AlertTypeLoading,//loading样式
    AlertTypeBottom,//底部样式
    AlertTypeCustom//自定义视图
};
@interface TRCustomAlert()
@property (nonatomic, strong)UIView *alertView;

@property (nonatomic, strong)NSMutableArray *buttonArray;//按钮模式的按钮

@property(nonatomic,copy)complete completeBlock;//回调

@property(nonatomic,assign)BOOL isFull;//是否是自带按钮
@property(nonatomic,assign)BOOL isShade;//是否带遮罩层

@property(nonatomic,assign)AlertType alertType;//当前界面的样式

@property (nonatomic, strong)UILabel *titleLab;//对话框标题
@property (nonatomic, strong)UILabel *contentLab;//对话框标题
@property(nonatomic,strong)WKWebView *wkWebView;//加载gif浏览器
@property(nonatomic,strong)UIProgressView *progressView;//加载进度条
@property (nonatomic, strong)UILabel *progressLab;//进度lab
@property(nonatomic,strong)NSTimer *time;
@property (nonatomic, strong)UIImageView *titleImgView;//确认框顶部图片
@property(nonatomic,assign)BOOL isFit;//是否为底部自适应弹框
@property (nonatomic, strong)UIWindow *fatherWindow;//父视图
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@end
@implementation TRCustomAlert

-(UIWindow *)fatherWindow{
    if (_fatherWindow==nil) {
        _fatherWindow=[self frontWindow];
    }
    return _fatherWindow;
}

-(NSMutableArray *)buttonArray{
    if (_buttonArray==nil) {
        _buttonArray=[NSMutableArray array];
    }
    return _buttonArray;
}
//单例模式
+ (TRCustomAlert*)sharedView {
    static dispatch_once_t once;
    static TRCustomAlert *sharedView;
    dispatch_once(&once, ^{
        sharedView=[[self alloc]init];
    });
    return  sharedView;
}

//初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[self bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"] pathForResource:@"loading" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        [self.wkWebView loadData:gifData MIMEType:@"image/gif" characterEncodingName:nil baseURL:nil];
        
        
        //监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)note
{
    //取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect frameKeyBoard=rect;
   __block CGRect frameAlertView=self.alertView.frame;
    //判断是否有遮罩层
    if(!self.isShade){
        frameAlertView=self.frame;
    }
    //计算差值
    CGFloat poor_value=CGRectGetMaxY(frameAlertView)-(TR_SCREEN_HEIGHT-frameKeyBoard.size.height);//差值
    //判断键盘是否遮挡
    if(poor_value>0){
        [UIView animateWithDuration:duration animations:^{
            //超出范围
            frameAlertView.origin.y=frameAlertView.origin.y-poor_value-15;
            if(!self.isShade){
                self.frame=frameAlertView;
            }else{
                self.alertView.frame=frameAlertView;
            }
        }];
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillHide:(NSNotification *)note
{
    //取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIView *tempView=nil;
    if (self.isShade) {
        tempView=self.alertView;
    }else{
        tempView=self;
    }
    CGRect frame=tempView.frame;
    //恢复到原来尺寸
    if (self.alertType==AlertTypeSimple||self.alertType==AlertTypeButton||self.alertType==AlertTypeLoading||self.alertType==AlertTypeCustom) {
        frame.origin.y=(TR_SCREEN_HEIGHT-frame.size.height)/2;
        
    }else if (self.alertType==AlertTypeBottom){
        frame.origin.y=TR_SCREEN_HEIGHT-frame.size.height-80;
    }
    [UIView animateWithDuration:duration animations:^{
        tempView.frame=frame;
    }];
}


#pragma mark 【第一种】创建基础界面
-(void)createCustomViewWithMessage:(NSString *)message image:(UIImage *)image isShade:(BOOL)isShade{
    
//    __weak TRCustomAlert *self = self;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
    
        self.alertType=AlertTypeSimple;
        //隐藏之前视图
        [self dissmis];
    
        //添加到视图上
        [self.fatherWindow addSubview:self];
        //是否带有动画
        self.isShade=isShade;
        
        UIView *alertView=[[UIView alloc]init];
        self.alertView=alertView;
        alertView.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.7];
        alertView.layer.cornerRadius=10;
        alertView.layer.masksToBounds=YES;
        [self addSubview:alertView];
        
        //提示图片
        UIImageView *titleImgView=[[UIImageView alloc]initWithImage:image];
        [alertView addSubview:titleImgView];
        
        //提示文字
        UILabel *titleLab=[[UILabel alloc]init];
        titleLab.textColor=[UIColor whiteColor];
        self.contentLab=titleLab;
        titleLab.font=[UIFont systemFontOfSize:15];
        titleLab.numberOfLines=0;
        titleLab.text=message;
        titleLab.textAlignment=NSTextAlignmentCenter;
        [alertView addSubview:titleLab];
        
        //设置尺寸
        CGFloat padding=15;
        CGFloat alertView_with=0;
        UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
        if (duration==UIDeviceOrientationUnknown||duration==UIDeviceOrientationPortraitUpsideDown||duration==UIDeviceOrientationPortrait) {
            //竖屏
            alertView_with=TR_SCREEN_WIDTH*0.5;
        }else{
            alertView_with=TR_SCREEN_HEIGHT*0.5;
        }
        if (image!=nil) {
            [titleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(alertView);
                make.top.equalTo(alertView).offset(padding*2);
                make.size.mas_equalTo(CGSizeMake(35, 35));
            }];
        }
    
        [titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(alertView).offset(padding);
            make.right.equalTo(alertView).offset(-padding);
            if (image!=nil) {
                make.top.equalTo(titleImgView.mas_bottom).offset(padding);
            }else{
                make.center.equalTo(alertView);
            }
        }];
        //父视图和子视图同样尺寸
        if (isShade) {
            //显示遮罩层
            [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self).priorityHigh();
                make.width.mas_equalTo(alertView_with);
                make.bottom.equalTo(titleLab).offset(padding*2).priorityHigh();
            }];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(self.fatherWindow).priorityHigh();
                make.top.left.equalTo(self.fatherWindow);
            }];
            self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
        }else{
            self.backgroundColor=[UIColor clearColor];
            [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self).priorityHigh();
                make.width.mas_equalTo(alertView_with);
                make.bottom.equalTo(titleLab).offset(padding*2);
            }];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(alertView).priorityHigh();
                make.center.equalTo(self.fatherWindow);
            }];
        }
        NSTimer *time=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dissmis) userInfo:nil repeats:NO];
        self.time=time;
        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
//    }];
    
}

//获取window
- (UIWindow *)frontWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}
//获取键盘类
- (UIView *)findKeyboard{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
        
    }
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view{
    for (UIView *subView in [view subviews])    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)            {
                return tempView;
            }
        }
    }
    return nil;
}

/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @result float 返回的高度
 */
- (CGFloat) heightForString:(NSString *)value Width:(float)width font:(UIFont *)font{
    CGSize size = CGSizeMake(width, MAXFLOAT);//最大范围
    NSDictionary *tdic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    CGSize textSize = [value boundingRectWithSize:size
                       
                                          options:NSStringDrawingUsesLineFragmentOrigin 
                       
                                       attributes:tdic
                       
                                          context:nil].size;
    
    CGFloat height = textSize.height+ 1;
    
    return height;
}


//成功简单提示
+(void)showSuccessWithMessage:(NSString *)message{
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"success" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:NO];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//失败简单提示
+(void)showErrorWithMessage:(NSString *)message{
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"error" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:NO];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//显示警告提示
+(void)showWarningWithMessage:(NSString *)message{
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"warning" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:NO];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//带遮罩层成功提示
+(void)showShadeSuccessWithMessage:(NSString *)message{
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"success" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:YES];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//带遮罩层失败提示
+(void)showShadeErrorWithMessage:(NSString *)message{
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"error" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:YES];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//带遮罩层警告提示
+(void)showShadeWarningWithMessage:(NSString *)message{
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"warning" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:YES];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//自定义图片，简单按钮
+(void)showMessage:(NSString *)message image:(UIImage *)image{
    [[self sharedView] createCustomViewWithMessage:message image:image isShade:NO];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//带遮罩层成功提示
+(void)showShadeWithMessage:(NSString *)message image:(UIImage *)image{
    [[self sharedView] createCustomViewWithMessage:message image:image isShade:YES];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}


//显示在底部的纯文字弹框
+(void)showBottomMessage:(NSString *)message{
    [[self sharedView] createCustomViewWithMessage:message image:nil isShade:NO];
    [self sharedView].alertType=AlertTypeBottom;
    //修改尺寸
    [[self sharedView] setSelfFrameWithIsFit:NO];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//显示底部自适应纯文字，简单框
+(void)showFitBottomMessage:(NSString *)message{
    [[self sharedView] createCustomViewWithMessage:message image:nil isShade:NO];
    [self sharedView].alertType=AlertTypeBottom;
    //修改尺寸
    [[self sharedView] setSelfFrameWithIsFit:YES];
    //动画显示
    [[self sharedView]  animationWithIsShow:YES];
}

//重新设置尺寸，适应底部简单提醒
-(void)setSelfFrameWithIsFit:(BOOL)isFit{
    self.isFit=isFit;
    //距离底部距离
    CGFloat bottom=80;
    CGFloat padding=15;
    //自适应宽度弹框
    CGFloat max_width=TR_SCREEN_WIDTH*0.7;//最大宽度
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
    if (duration==UIDeviceOrientationUnknown||duration==UIDeviceOrientationPortraitUpsideDown||duration==UIDeviceOrientationPortrait) {
        //竖屏
        max_width=TR_SCREEN_WIDTH*0.7;
    }else{
        max_width=TR_SCREEN_HEIGHT*0.7;
    }
    if (isFit) {
        
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.alertView);
            make.width.lessThanOrEqualTo(@(max_width-padding*2));//最大宽度
        }];
        
        [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentLab).offset(padding*4);
            make.height.equalTo(self.contentLab).offset(padding*2);
            make.center.equalTo(self);
        }];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.alertView);
            make.centerX.equalTo(self.fatherWindow);
            make.bottom.equalTo(self.fatherWindow).offset(-bottom).priorityHigh();
        }];
    }else{
       //固定宽度弹框
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.alertView);
            make.width.mas_equalTo(max_width-padding*2);//最大宽度
        }];
        [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentLab).offset(padding*4);
            make.height.equalTo(self.contentLab).offset(padding*2);
            make.center.equalTo(self);
        }];
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.alertView);
            make.centerX.equalTo(self.fatherWindow);
            make.bottom.equalTo(self.fatherWindow).offset(-bottom);
        }];

    }
    
}


//显示动画
-(void)show{
    UIViewController *vc=[self topViewController];
    [vc.view addSubview:self];
    [self animationWithIsShow:YES];
}

//隐藏
-(void)dissmis{
    if (self.subviews.count>0) {
        [self.subviews[0] removeFromSuperview];
        if (self.subviews.count==0) {
            [self removeFromSuperview];
            self.alertView=nil;
        }
    }else{
        [self removeFromSuperview];
        self.alertView=nil;
    }
    //清除进度
    self.progress=0;
    [self clearTime];
}

+(void)dissmis{
    if([self sharedView].alertType==AlertTypeLoading || [self sharedView].alertType==AlertTypeCustom){
        [[self sharedView] dissmis];
    }
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}


- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark 显示和隐藏动画
-(void)animationWithIsShow:(BOOL)isShow{
    if (isShow) {
        //判断当前是否有键盘
        UIView *keyBoardView=[self findKeyboard];
        if(keyBoardView!=nil&&!keyBoardView.hidden){
//            [self layoutIfNeeded];
            [self.superview layoutIfNeeded];
            CGRect frameKeyBoard=keyBoardView.frame;
            CGRect frameAlertView=self.alertView.frame;
            //判断是否有遮罩层
            if(!self.isShade){
                frameAlertView=self.frame;
            }
            //计算差值
            CGFloat poor_value=CGRectGetMaxY(frameAlertView)-(self.fatherWindow.frame.size.height-frameKeyBoard.size.height);//差值
            //判断键盘是否遮挡
            if(poor_value>0){
                //超出范围
                frameAlertView.origin.y=frameAlertView.origin.y-poor_value-15;
                if(!self.isShade){
                    //无遮罩
                    self.frame=frameAlertView;
                }else{
                    //有遮罩
                    self.alertView.frame=frameAlertView;
                }
                
            }
        }
        //弹出动画
        // 第一步：将view宽高缩至无限小（点）
        self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                          CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.3
                         animations:^{
                             // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                             self.alertView.transform =CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  // 第三步： 以动画的形式将view恢复至原始大小
                                                  self.alertView.transform = CGAffineTransformIdentity;
                                              }];
                         }];
    }else{
        //隐藏动画
        [UIView animateWithDuration:0.2
                         animations:^{
                             // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                             self.alertView.transform =
                             CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                                                  self.alertView.transform = CGAffineTransformScale(
                                                                                                    CGAffineTransformIdentity, 0.001, 0.001);
                                              }
                                              completion:^(BOOL finished) {
                                                  // 第三步： 移除
                                                  [self removeFromSuperview];
                                              }];
                         }];
    }
}


//多个按钮，模式
+(void)showAlertWithButtonTitleArray:(NSArray<NSString *> *)titleArray style:(TRCustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [self sharedView].alertType=AlertTypeButton;
    //情况按钮数组
    [[self sharedView].buttonArray removeAllObjects];
    NSString *imageName=@"";
    if (style==TRCustomAlertStyleSuccess) {
        imageName=@"success_blue";
    }else if (style==TRCustomAlertStyleError){
        imageName=@"error_blue";
    }else if (style==TRCustomAlertStyleWarning){
        imageName=@"warning_blue";
    }
    
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] creatAlertViewWithButtonTitleArray:titleArray image:[UIImage imageNamed:imageName inBundle:resource_bundle
                                                                 compatibleWithTraitCollection:nil] title:title isFull:NO content:content innerView:nil complete:completeBlock];
    
}

//自定义图标
+(void)showAlertWithButtonTitleArray:(NSArray<NSString *> *)titleArray image:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [self sharedView].alertType=AlertTypeButton;
    [[self sharedView] creatAlertViewWithButtonTitleArray:titleArray image:image title:title isFull:NO content:content innerView:nil complete:completeBlock];
}


//自带确定和取消，默认图片样式
+(void)showAlertFullWithStyle:(TRCustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [self sharedView].alertType=AlertTypeButton;
    NSString *imageName=@"";
    if (style==TRCustomAlertStyleSuccess) {
        imageName=@"success_blue";
    }else if (style==TRCustomAlertStyleError){
        imageName=@"error_blue";
    }else if (style==TRCustomAlertStyleWarning){
        imageName=@"warning_blue";
    }
    
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] creatAlertViewWithButtonTitleArray:@[@"取消",@"确定"] image:[UIImage imageNamed:imageName inBundle:resource_bundle
                                                                     compatibleWithTraitCollection:nil] title:title isFull:YES content:content innerView:nil complete:completeBlock];
}

//自带确定和取消，自定义图片
+(void)showAlertFullWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    
    [self sharedView].alertType=AlertTypeButton;
    [[self sharedView] creatAlertViewWithButtonTitleArray:@[@"取消",@"确定"] image:image title:title isFull:YES content:content innerView:nil complete:completeBlock];
}

//确定样式
+(void)showAlertFinishWithStyle:(TRCustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [self sharedView].alertType=AlertTypeButton;
    NSString *imageName=@"";
    if (style==TRCustomAlertStyleSuccess) {
        imageName=@"success_blue";
    }else if (style==TRCustomAlertStyleError){
        imageName=@"error_blue";
    }else if (style==TRCustomAlertStyleWarning){
        imageName=@"warning_blue";
    }
    
    NSBundle *resource_bundle =[[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] creatAlertViewWithButtonTitleArray:@[@"确定"] image:[UIImage imageNamed:imageName inBundle:resource_bundle
                                                               compatibleWithTraitCollection:nil]  title:title isFull:YES content:content innerView:nil complete:completeBlock];
}

//确定按钮，自定义图片
+(void)showAlertFinishWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [self sharedView].alertType=AlertTypeButton;
    [[self sharedView] creatAlertViewWithButtonTitleArray:@[@"确定"] image:image title:title isFull:YES content:content innerView:nil complete:completeBlock];
}

//设置按钮对话框按钮单击背景色
+(void)setAlertBtnClickBackgroundColorWithColor:(UIColor *)color index:(NSInteger)index{
    if ([self sharedView].alertType==AlertTypeButton) {
        if (index<[self sharedView].buttonArray.count) {
            //防止越界
            UIButton *btn=[self sharedView].buttonArray[index];
            [btn setBackgroundImage:[[self sharedView] createImageWithColor:color] forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
    }
    
}

- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark 【第二种】创建对话框样式,中间可以自定义视图
-(void)creatAlertViewWithButtonTitleArray:(NSArray<NSString *> *)titleArray image:(UIImage *)image title:(NSString *)title isFull:(BOOL)isFull content:(NSString *)content innerView:(UIView *)innerView complete:(complete)completeBlock{
//    __weak TRCustomAlert *self = self;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.isShade=YES;
        [self dissmis];
        //添加到视图上
        [self.fatherWindow addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.fatherWindow);
            make.center.equalTo(self.fatherWindow);
        }];
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    
        self.isFull=isFull;
        self.completeBlock=completeBlock;//保存代码快
        UIView *alertView=[[UIView alloc]init];
        self.alertView=alertView;
        alertView.backgroundColor=[UIColor whiteColor];
        alertView.layer.cornerRadius=10;
        alertView.layer.masksToBounds=YES;
        [self addSubview:alertView];
        
        CGFloat padding=5;
        CGFloat alertView_with=0;
        UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
        if (duration==UIDeviceOrientationUnknown||duration==UIDeviceOrientationPortraitUpsideDown||duration==UIDeviceOrientationPortrait) {
            //竖屏
            alertView_with=TR_SCREEN_WIDTH*0.7;
        }else{
            alertView_with=TR_SCREEN_HEIGHT*0.7;
        }
        CGFloat marginTop=27;
        //提示图片
        UIImageView *titleImgView=nil;
        if (image!=nil) {
            titleImgView=[[UIImageView alloc]init];
            titleImgView.image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
            titleImgView.tintColor=[self colorWithHexString:MainColor];
            [alertView addSubview:titleImgView];
//            titleImgView.frame=CGRectMake((alertView_with-35)/2,marginTop, 35, 35);
            [titleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(alertView);
                make.top.equalTo(alertView).offset(marginTop);
                make.size.mas_equalTo(CGSizeMake(35, 35));
            }];
        }
        self.titleImgView=titleImgView;
        
        
        //标题文字
        UILabel *titleLab=[[UILabel alloc]init];
        self.titleLab=titleLab;
        titleLab.font=[UIFont systemFontOfSize:19];
        titleLab.textColor=[self colorWithHexString:MainColor];
        titleLab.text=title;
        titleLab.textAlignment=NSTextAlignmentCenter;
        [alertView addSubview:titleLab];
        [titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (image!=nil) {
                make.top.equalTo(titleImgView.mas_bottom).offset(padding*2.5);
            }else{
                make.top.equalTo(alertView).offset(marginTop);
            }
            make.left.equalTo(alertView).offset(padding);
            make.right.equalTo(alertView).offset(-padding);
        }];
        
        //内容文字
        UILabel *contentLab=[[UILabel alloc]init];
        self.contentLab=contentLab;
        contentLab.lineBreakMode=NSLineBreakByWordWrapping;
        contentLab.font=[UIFont systemFontOfSize:15];
        contentLab.numberOfLines=0;
        contentLab.text=content;
        contentLab.textColor=[self colorWithHexString:@"#333333"];
    
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:content];;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:4];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
        contentLab.attributedText = attributedString;
        contentLab.textAlignment=NSTextAlignmentCenter;
        [alertView addSubview:contentLab];
        [contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).offset(padding*3);
            make.left.equalTo(alertView).offset(20);
            make.right.equalTo(alertView).offset(-20);
        }];
    
    //判断是否有中间视图
    UIView *tempView=contentLab;
    self.innerView=innerView;
    if (innerView!=nil) {
        //断言检查自定义中间控件是否设置了尺寸
        NSAssert(innerView.bounds.size.width!=0, @"Error=提示: (自定义中间视图，需要设置size)");
        tempView=innerView;
        [alertView addSubview:innerView];
        CGSize innserSize=innerView.bounds.size;
        [innerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.top.equalTo(contentLab.mas_bottom).offset(padding*3);
            make.size.mas_equalTo(innserSize);
        }];
    }
        //设置按钮
        if (titleArray.count>0) {
            //分割线
            UIView *cutView=[[UIView alloc]init];
            cutView.tag=101;
            cutView.backgroundColor=[self colorWithHexString:@"#e2e2e2"];//
            [alertView addSubview:cutView];
            [cutView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tempView.mas_bottom).offset(20);
                make.width.equalTo(alertView);
                make.height.mas_equalTo(1);
                make.left.equalTo(alertView);
            }];
            [self.buttonArray removeAllObjects];
            for (int i=0;i<titleArray.count;i++) {
                NSString *title=titleArray[i];
                if ([title isKindOfClass:[NSString class]]) {
                    //这里只创建两个按钮
                    if (i==2) {
                        break;
                    }
                    UIButton *button=[UIButton buttonWithType:0];
                    [self.buttonArray addObject:button];
                    [button setTitle:title forState:0];
                    //默认颜色
                    if (i==1) {
                        [button setTitleColor:[self colorWithHexString:MainColor] forState:0];
                    }else{
                        [button setTitleColor:[self colorWithHexString:@"#666666"] forState:0];
                    }
                    //当只有一个时，设置主题色
                    if(titleArray.count==1){
                        [button setTitleColor:[self colorWithHexString:MainColor] forState:0];
                    }
                    button.tag=i;
                    button.titleLabel.font=[UIFont systemFontOfSize:14];
                    [button addTarget:self action:@selector(completeClick:) forControlEvents:UIControlEventTouchUpInside];
                    [alertView addSubview:button];
                    CGFloat button_width=alertView_with;//按钮宽度
                    if (titleArray.count>1) {
                        button_width=alertView_with/2;
                    }
                    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(alertView).offset(i*button_width);
                        make.top.equalTo(cutView.mas_bottom);
                        make.size.mas_equalTo(CGSizeMake(button_width, 40));
                    }];
                }
            }
            //添加中间装饰线
            if(titleArray.count>1){
                //WithFrame:CGRectMake(alertView_with/2, CGRectGetMaxY(cutView.frame)+10, 1, 20)
                UIView *cutView_mid=[[UIView alloc]init];
                cutView_mid.backgroundColor=cutView.backgroundColor;
                cutView_mid.tag=102;
                [alertView addSubview:cutView_mid];
                [cutView_mid mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(alertView);
                    make.size.mas_equalTo(CGSizeMake(1, 20));
                    make.top.equalTo(cutView.mas_bottom).offset(10);
                }];
            }
            
            [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.width.mas_equalTo(alertView_with);
                make.bottom.equalTo(((UIButton *)self.buttonArray[0]));
            }];
        }else{
            //没有按钮
            [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.width.mas_equalTo(alertView_with);
                make.bottom.equalTo(tempView).offset(20);
            }];
        }
    
        //显示
        [self animationWithIsShow:YES];
        
//    }];
    
}

//按钮点击事件
-(void)completeClick:(UIButton *)sender{
    NSInteger index=sender.tag;
    NSString *title=sender.titleLabel.text;
    if (self.completeBlock!=nil) {
        self.completeBlock(index, title);
    }
    [self dissmis];
//    if (self.isFull&&index==0) {
//
//    }
}


//颜色转换
-(UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
    return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//设置对话框底部按钮样式
-(void)setButtonColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor fontSize:(UIFont *)fontSize isAll:(BOOL)isAll index:(NSInteger)index{
    for (int i=0;i<self.buttonArray.count;i++) {
        UIButton *btn =self.buttonArray[i];
        if (isAll) {
            if(color!=nil){
                [btn setTitleColor:color forState:0];
            }
            if(fontSize!=nil){
                btn.titleLabel.font=fontSize;
            }
            if (backgroundColor!=nil) {
                [btn setBackgroundColor:backgroundColor];
            }
        }else{
            if (index==i) {
                if(color!=nil){
                    [btn setTitleColor:color forState:0];
                }
                if(fontSize!=nil){
                    btn.titleLabel.font=fontSize;
                }
                if (backgroundColor!=nil) {
                    [btn setBackgroundColor:backgroundColor];
                }
            }
        }
    }
}
#pragma mark 样式设置
+(void)setBackgroundColor:(UIColor *)color{
    [self sharedView].alertView.backgroundColor=color;
}

+(void)setTitleColor:(UIColor *)color{
    [self sharedView].titleLab.textColor=color;
}

+(void)setTitleFont:(UIFont *)font{
    [self sharedView].titleLab.font=font;
}

+(void)setButtonColor:(UIColor *)color{
    [[self sharedView] setButtonColor:color backgroundColor:nil fontSize:nil isAll:YES index:0];
}

+(void)setButtonBackgroundColor:(UIColor *)color index:(NSInteger)index{
    [[self sharedView] setButtonColor:nil backgroundColor:color fontSize:nil isAll:NO index:index];
}

+(void)setButtonFont:(UIFont *)font{
    [[self sharedView] setButtonColor:nil backgroundColor:nil fontSize:font isAll:YES index:0];
}

+(void)setButtonFont:(UIFont *)font color:(UIColor *)color{
    [[self sharedView] setButtonColor:color backgroundColor:nil fontSize:font isAll:YES index:0];
}

+(void)setButtonColor:(UIColor *)color index:(NSInteger)index{
    [[self sharedView] setButtonColor:color backgroundColor:nil fontSize:nil isAll:NO index:index];
}

+(void)setButtonFont:(UIFont *)font index:(NSInteger)index{
    [[self sharedView] setButtonColor:nil backgroundColor:nil fontSize:font isAll:NO index:index];
}

+(void)setButtonFont:(UIFont *)font color:(UIColor *)color index:(NSInteger)index{
    [[self sharedView] setButtonColor:color backgroundColor:nil fontSize:font isAll:NO index:index];
}

+(void)setAlertCornerRadius:(CGFloat)value{
    [self sharedView].alertView.layer.cornerRadius=value;
    [self sharedView].alertView.layer.masksToBounds=YES;
}


+(void)setConfirmImageColor:(UIColor *)color{
    if ([self sharedView].alertType==AlertTypeButton) {
        //对话框模式
        [self sharedView].titleImgView.tintColor=color;
    }
}

+(void)setFontColor:(UIColor *)color{
    [self sharedView].contentLab.textColor=color;
}

+(void)setFont:(UIFont *)font{
    
//    UIView *alertView=[self sharedView].alertView;
    UILabel *lab=[self sharedView].contentLab;
    lab.font=font;
//    CGRect frame=lab.frame;
//    CGRect alertViewFrame=alertView.frame;
//    if([self sharedView].alertType==AlertTypeSimple){
//        //简单提示框
//        CGRect viewFrame=[self sharedView].frame;
//        CGFloat alertView_with=TR_SCREEN_WIDTH*0.5;
//        CGFloat newHeight=[[self sharedView] heightForString:lab.text Width:alertView_with-15*2 font:font];
//        frame.size.height=newHeight;
//        alertViewFrame.size.height=CGRectGetMaxY(frame)+40;
//        if (![self sharedView].isShade) {
//            //没有遮罩层
//            viewFrame.size.height=CGRectGetMaxY(frame)+15;
//            CGFloat viewFrame_y=(TR_SCREEN_HEIGHT-viewFrame.size.height)/2;
//            viewFrame.origin.y=viewFrame_y;
//        }else{
//            CGFloat alertViewFrame_y=(TR_SCREEN_HEIGHT-alertViewFrame.size.height)/2;
//            alertViewFrame.origin.y=alertViewFrame_y;
//        }
//        lab.frame=frame;
//        [self sharedView].frame=viewFrame;
//        alertView.frame=alertViewFrame;
//
//    }else if([self sharedView].alertType==AlertTypeButton||[self sharedView].alertType==AlertTypeLoading||[self sharedView].alertType==AlertTypeCustom){
//        //提示框,loading
//        [alertView.layer removeAllAnimations];//移除所有动画
//        alertView.hidden=YES;//隐藏控件
//        NSTimer *time=  [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(showAlert:) userInfo:@{@"font":font} repeats:NO];
//        [self sharedView].time=time;;
//        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
//    }
//    else if([self sharedView].alertType==AlertTypeBottom){
//        //提示框,loading
//        [alertView.layer removeAllAnimations];//移除所有动画
//        alertView.hidden=YES;//隐藏控件
//        NSTimer *time=  [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(showAlert:) userInfo:@{@"font":font} repeats:NO];
//        [self sharedView].time=time;;
//        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
//
//    }
    
}
//显示提示框
+(void)showAlert:(NSTimer *)timer{
    UIFont *font=[timer userInfo][@"font"];
    UIView *alertView=[self sharedView].alertView;
    UILabel *lab=[self sharedView].contentLab;
    CGRect frame=lab.frame;
    CGRect alertViewFrame=alertView.frame;
    
    if ([self sharedView].alertType==AlertTypeLoading) {
        //loading样式
        CGFloat lab_width=frame.size.width;
        CGFloat newHeight=[[self sharedView] heightForString:lab.text Width:lab_width font:font];
        frame.size.height=newHeight;
        lab.frame=frame;
        //父窗体
        alertViewFrame.size.height=CGRectGetMaxY(lab.frame)+15;
        alertView.frame=alertViewFrame;
    }else if([self sharedView].alertType==AlertTypeButton||[self sharedView].alertType==AlertTypeCustom){
        //对话框
        CGFloat alertView_with=TR_SCREEN_WIDTH*0.7;
        CGFloat newHeight = [lab sizeThatFits:CGSizeMake(alertView_with-40, CGFLOAT_MAX)].height;
        frame.size.height=newHeight;
        lab.frame=frame;
        UIView *tempView=lab;
        //如果是自定义视图
        if ([self sharedView].alertType==AlertTypeCustom) {
            tempView=[self sharedView].innerView;
            CGRect tempView_frame= tempView.frame;
            tempView_frame.origin.y=CGRectGetMaxY(lab.frame)+15;
            tempView.frame=tempView_frame;
            frame=tempView.frame;
        }
        
        if ([self sharedView].buttonArray.count>0) {
            //分割线
            UIView *cutView_Horizontal=nil;//横分割线
            UIView *cutView_Vertical=nil;//竖分割线
            for(UIView *view in alertView.subviews){
                if (view.tag==101) {
                    cutView_Horizontal=view;
                }else if (view.tag==102) {
                    cutView_Vertical=view;
                }
            }
            //水平分割线
            CGRect cutView_Horizontal_Frame=cutView_Horizontal.frame;
            cutView_Horizontal_Frame.origin.y=CGRectGetMaxY(frame)+20;
            cutView_Horizontal.frame=cutView_Horizontal_Frame;
            
            UIButton *tempBtn=nil;
            for(UIButton *btn in [self sharedView].buttonArray){
                tempBtn=btn;
                CGRect btn_Frame=btn.frame;
                btn_Frame.origin.y=CGRectGetMaxY(cutView_Horizontal_Frame);
                btn.frame=btn_Frame;
                if (cutView_Vertical!=nil) {
                    CGRect cutView_Vertical_Frame=cutView_Vertical.frame;
                    cutView_Vertical_Frame.origin.y=CGRectGetMaxY(cutView_Horizontal.frame)+(btn_Frame.size.height-cutView_Vertical_Frame.size.height)/2;
                    cutView_Vertical.frame=cutView_Vertical_Frame;
                }
            }
            //父视图尺寸
            alertViewFrame.size.height=CGRectGetMaxY(tempBtn.frame);
        }else{
            //父视图尺寸
            alertViewFrame.size.height=CGRectGetMaxY(lab.frame)+10;
            
        }
        alertViewFrame.origin.y=(TR_SCREEN_HEIGHT-alertViewFrame.size.height)/2;
        alertView.frame=alertViewFrame;
    }else if ([self sharedView].alertType==AlertTypeBottom){
        //底部样式
        [[self sharedView] setSelfFrameWithIsFit:[self sharedView].isFit];
    }
    alertView.hidden=NO;
    [[self sharedView] animationWithIsShow:YES];
    [[self sharedView] clearTime];
    
}

//销毁定时器
-(void)clearTime{
    if (self.time!=nil) {
        if ([self.time isValid]) {
            [self.time invalidate];
            self.time = nil;
        }
    }
}

#pragma mark 【第三种】加载等待
-(void)createLoadingWithMessage:(NSString *)message isShade:(BOOL)isShade{
//    __weak TRCustomAlert *self = self;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.isShade=isShade;
        self.alertType=AlertTypeLoading;
        [self dissmis];
        //添加到视图上
        [self.fatherWindow addSubview:self];
    
        UIView *alertView=[[UIView alloc]init];
        self.alertView=alertView;
        alertView.backgroundColor= [UIColor colorWithWhite:0.1 alpha:0.7];
        alertView.layer.cornerRadius=10;
        alertView.layer.masksToBounds=YES;
        [self addSubview:alertView];
        
        if(self.wkWebView==nil){
            WKWebView *wkWebView=[[WKWebView alloc]init];
            self.wkWebView=wkWebView;
            NSString *path = [[self bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"] pathForResource:@"loading" ofType:@"gif"];
            NSData *gifData = [NSData dataWithContentsOfFile:path];
            [wkWebView loadData:gifData MIMEType:@"image/gif" characterEncodingName:nil baseURL:nil];
            
        }
        //加载活动指示器
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
        self.activityIndicator=activityIndicator;
    
        CGAffineTransform transform = CGAffineTransformMakeScale(1.4, 1.4);    // 变大变小调这里即可
    
        activityIndicator.transform = transform;
        [self.alertView addSubview:activityIndicator];
//
        activityIndicator.color = [UIColor whiteColor]; // 改变圈圈的颜色为红色； iOS5引入
        [activityIndicator startAnimating]; // 开始旋转
        [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    
    
    
        self.wkWebView.hidden=NO;
        self.activityIndicator.hidden=YES;
        [alertView addSubview:self.wkWebView];
        self.wkWebView.backgroundColor = [UIColor clearColor];
        self.wkWebView.opaque = NO;
        CGFloat padding=10;//间距
        
        self.backgroundColor=[UIColor clearColor];
        
        CGFloat wkWebView_width=48;
        if ([message isEqualToString:@""]||message==nil) {
            CGFloat alertView_with=95;
            [self.wkWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(alertView);
                make.size.mas_equalTo(CGSizeMake(wkWebView_width, wkWebView_width));
            }];
            [activityIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(alertView);
            }];
            if(isShade){
                //显示遮罩
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(self.fatherWindow);
                    make.center.equalTo(self.fatherWindow);
                }];
                [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(alertView_with, alertView_with));
                }];
            }else{
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(alertView_with, alertView_with));
                    make.center.equalTo(self.fatherWindow);
                }];
                [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                    make.size.equalTo(self);
                }];
            }
            
        }else{
            CGFloat alertView_with=140;
            //有文字
            UILabel *titleLab=[[UILabel alloc]init];
            self.contentLab=titleLab;
            titleLab.textColor=[UIColor whiteColor];
            titleLab.font=[UIFont systemFontOfSize:15];
            titleLab.numberOfLines=0;
            titleLab.text=message;
            titleLab.textAlignment=NSTextAlignmentCenter;
            [alertView addSubview:titleLab];
            
            [self.wkWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(alertView).offset(24);
                make.centerX.equalTo(alertView);
                make.size.mas_equalTo(CGSizeMake(wkWebView_width, wkWebView_width));
            }];
            
            [activityIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(alertView).offset(24);
                make.centerX.equalTo(alertView);
            }];
            
            [titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.wkWebView.mas_bottom).offset(padding).priorityHigh();
                make.left.equalTo(alertView).offset(padding/2);
                make.right.equalTo(alertView).offset(-padding/2);
            }];
            
            if(isShade){
                //显示遮罩
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(self.fatherWindow);
                    make.center.equalTo(self.fatherWindow);
                }];
               
                [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                    make.width.mas_equalTo(alertView_with);
                    make.bottom.equalTo(titleLab.mas_bottom).offset(padding);
                }];
                
            }else{
                
                [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                    make.width.mas_equalTo(alertView_with);
                    make.bottom.equalTo(titleLab).offset(padding);
                }];
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.fatherWindow);
                    make.size.equalTo(alertView);
                }];
            }
        }
        //显示
        [self animationWithIsShow:YES];
    
    
//    }];
    
}

//设置loading样式
+(void)setLoadingWithStyle:(TRLoadingStyle)style{
    [self sharedView].wkWebView.hidden= style ==TRLoadingStyleActivityIndicator;
    [self sharedView].activityIndicator.hidden=![self sharedView].wkWebView.hidden;
}

-(NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName{
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

//loading无文字
+(void)showLoading{
    [[self sharedView] createLoadingWithMessage:nil isShade:NO];
}
//显示遮罩层
+(void)showShadeLoading{
     [[self sharedView] createLoadingWithMessage:nil isShade:YES];
}
//loading有文字
+(void)showLoadingWithMessage:(NSString *)message{
    [[self sharedView] createLoadingWithMessage:message isShade:NO];
}

+(void)showShadeLoadingWithMessage:(NSString *)message{
    [[self sharedView] createLoadingWithMessage:message isShade:YES];
}


#pragma mark 【第四种】加载进度
-(void)createProgressWithTitle:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle complete:(complete)completeBlock{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, TR_SCREEN_WIDTH*0.7-40, 37)];
    
    UIProgressView *prgView=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 10)];
    prgView.progressTintColor=[self colorWithHexString:MainColor];
    self.progressView=prgView;
    [view addSubview:prgView];
    
    CGFloat lab_width=50;
    UILabel *prgLab=[[UILabel alloc]initWithFrame:CGRectMake((view.bounds.size.width-lab_width)/2, CGRectGetMaxY(prgView.frame), lab_width, 40)];
    self.progressLab=prgLab;
    prgLab.text=@"0%";
    prgLab.textAlignment=NSTextAlignmentCenter;
    prgLab.font=[UIFont systemFontOfSize:14];
    [view addSubview:prgLab];
    
    NSArray *array=@[@"确定"];
    if (buttonTitle==nil||[buttonTitle isEqualToString:@""]) {
        array=@[];
    }else{
        array=@[buttonTitle];
    }
    [self creatAlertViewWithButtonTitleArray:array image:nil title:title isFull:NO content:content innerView:view complete:^(NSInteger index, NSString *title) {
        if (completeBlock!=nil) {
            completeBlock(index,title);
        }
    }];
}

-(void)setProgress:(CGFloat)progress{
    _progress=progress;
    self.progressLab.text=[NSString stringWithFormat:@"%ld%%",(long)[[NSNumber numberWithFloat:progress*100] integerValue]];
    self.progressView.progress=progress;
}


+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content{
    [self sharedView].alertType=AlertTypeCustom;
    [[self sharedView] createProgressWithTitle:title  content:content buttonTitle:nil complete:nil];
    return [self sharedView];
}


+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [self sharedView].alertType=AlertTypeCustom;
    [[self sharedView] createProgressWithTitle:title content:content buttonTitle:@"确定" complete:^(NSInteger index, NSString *title) {
        if (completeBlock!=nil) {
            completeBlock(index,title);
        }
    }];
    return [self sharedView];
}


+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle complete:(complete)completeBlock{
    [self sharedView].alertType=AlertTypeCustom;
    [[self sharedView] createProgressWithTitle:title content:content buttonTitle:buttonTitle complete:^(NSInteger index, NSString *title) {
        if (completeBlock!=nil) {
            completeBlock(index,title);
        }
    }];
    [TRCustomAlert setButtonColor:[[self sharedView] colorWithHexString:MainColor]];
    return [self sharedView];
}

//自定义中间视图
+(instancetype)showCustomeViewWithButtonTitleArray:(NSArray<NSString *> *)buttonTitleArray innerView:(UIView *)innerView title:(NSString *)title content:(NSString *)content  complete:(customComplete)completeBlock{
    [self sharedView].alertType=AlertTypeCustom;
    [[self sharedView] creatAlertViewWithButtonTitleArray:buttonTitleArray image:nil title:title isFull:NO content:content innerView:innerView complete:^(NSInteger index, NSString *title) {
        if (completeBlock!=nil) {
            completeBlock(innerView,index,title);
        }
    }];
    return [self sharedView];
}

@end
