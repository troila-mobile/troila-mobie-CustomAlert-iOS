//
//  TRCustomAlert.m
//  AlertTroila
//
//  Created by Admin on 2018/9/20.
//  Copyright © 2018年 马银伟. All rights reserved.
//

#import "TRCustomAlert.h"
#import <WebKit/WebKit.h>
//屏幕宽高
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//当前界面的样式
typedef NS_ENUM(NSInteger, AlertType) {
    AlertTypeSimple,//简单样式
    AlertTypeButton,//按钮样式
    AlertTypeLoading//loading样式
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
@property(nonatomic,strong)NSTimer *time;
@end
@implementation TRCustomAlert
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
    }
    return self;
}

#pragma mark 创建基础界面
-(void)createCustomViewWithMessage:(NSString *)message image:(UIImage *)image isShade:(BOOL)isShade{
    
    __weak TRCustomAlert *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakSelf.alertType=AlertTypeSimple;
        
        [weakSelf dissmis];
        weakSelf.isShade=isShade;
        
        UIView *alertView=[[UIView alloc]init];
        weakSelf.alertView=alertView;
        alertView.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.7];
        alertView.layer.cornerRadius=10;
        alertView.layer.masksToBounds=YES;
        [weakSelf addSubview:alertView];
        
        //提示图片
        UIImageView *titleImgView=[[UIImageView alloc]initWithImage:image];
        [alertView addSubview:titleImgView];
        
        //提示文字
        UILabel *titleLab=[[UILabel alloc]init];
        titleLab.textColor=[UIColor whiteColor];
        weakSelf.contentLab=titleLab;
        titleLab.font=[UIFont systemFontOfSize:15];
        titleLab.numberOfLines=0;
        titleLab.text=message;
        titleLab.textAlignment=NSTextAlignmentCenter;
        [alertView addSubview:titleLab];
        
        //设置尺寸
        CGFloat padding=15;
        CGFloat alertView_with=SCREEN_WIDTH*0.5;
        CGFloat titleLab_height=[weakSelf heightForString:message Width:alertView_with-padding*2 font:titleLab.font];
        if (image!=nil) {
            titleImgView.frame=CGRectMake((alertView_with-35)/2, padding*2, 35, 35);
            titleLab.frame= CGRectMake(padding, CGRectGetMaxY(titleImgView.frame)+padding, alertView_with-padding*2, titleLab_height );
        }else{
            titleLab.frame= CGRectMake(padding, padding, alertView_with-padding*2, titleLab_height );
        }
        
        
        CGFloat alertView_x=(SCREEN_WIDTH-alertView_with)/2;
        CGFloat alertView_height=CGRectGetMaxY(titleLab.frame)+padding;
        CGFloat alertView_y=(SCREEN_HEIGHT-alertView_height)/2;
        
        
        //父视图和子视图同样尺寸
        if (isShade) {
            //显示遮罩层
            weakSelf.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            alertView.frame=CGRectMake(alertView_x, alertView_y, alertView_with,alertView_height);
            weakSelf.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
        }else{
            weakSelf.backgroundColor=[UIColor clearColor];
            weakSelf.frame=CGRectMake(alertView_x, alertView_y, alertView_with, alertView_height);
            alertView.frame=CGRectMake(0, 0, alertView_with,alertView_height);
        }
        
        
        //添加到视图上
        [[weakSelf frontWindow] addSubview:weakSelf];
        //动画显示
        [weakSelf animationWithIsShow:YES];
        
        NSTimer *time=[NSTimer scheduledTimerWithTimeInterval:3.0 target:weakSelf selector:@selector(dissmis) userInfo:nil repeats:NO];
        weakSelf.time=time;
        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    }];
    
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

/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @result float 返回的高度
 */
- (CGFloat) heightForString:(NSString *)value Width:(float)width font:(UIFont *)font{
    CGSize size = CGSizeMake(width, MAXFLOAT);//最大范围
    NSDictionary *tdic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    CGSize textSize = [value boundingRectWithSize:size
                       
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                       
                                       attributes:tdic
                       
                                          context:nil].size;
    
    CGFloat height = textSize.height+ 1;
    
    return height;
}


//成功简单提示
+(void)showSuccessWithMessage:(NSString *)message{
    //    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
    //                            stringByAppendingPathComponent:@"/CustomAlertImage.bundle"];
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"success" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:NO];
}

//失败简单提示
+(void)showErrorWithMessage:(NSString *)message{
    //    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
    //                            stringByAppendingPathComponent:@"/CustomAlertImage.bundle"];
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"success" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:NO];
}

//带遮罩层成功提示
+(void)showShadeSuccessWithMessage:(NSString *)message{
    //    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
    //                            stringByAppendingPathComponent:@"/CustomAlertImage.bundle"];
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"success" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:YES];
}

//带遮罩层失败提示
+(void)showShadeErrorWithMessage:(NSString *)message{
    //    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
    //                            stringByAppendingPathComponent:@"/CustomAlertImage.bundle"];
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] createCustomViewWithMessage:message image:[UIImage imageNamed:@"success" inBundle:resource_bundle
                                                       compatibleWithTraitCollection:nil] isShade:YES];
}

//自定义图片，简单按钮
+(void)showMessage:(NSString *)message image:(UIImage *)image{
    [[self sharedView] createCustomViewWithMessage:message image:image isShade:NO];
}

//带遮罩层成功提示
+(void)showShadeWithMessage:(NSString *)message image:(UIImage *)image{
    [[self sharedView] createCustomViewWithMessage:message image:image isShade:YES];
}


//加载等待



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
    
    [self clearTime];
}

+(void)dissmis{
    [[self sharedView] dissmis];
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

//显示和隐藏动画
-(void)animationWithIsShow:(BOOL)isShow{
    if (isShow) {
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
    //    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
    //                            stringByAppendingPathComponent:@"/CustomAlertImage.bundle"];
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] creatAlertViewWithButtonTitleArray:titleArray image:[UIImage imageNamed:imageName inBundle:resource_bundle
                                                                 compatibleWithTraitCollection:nil] title:title isFull:NO content:content complete:completeBlock];
    
}

//自定义图标
+(void)showAlertWithButtonTitleArray:(NSArray<NSString *> *)titleArray image:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [[self sharedView] creatAlertViewWithButtonTitleArray:titleArray image:image title:title isFull:NO content:content complete:completeBlock];
}


//自带确定和取消，默认图片样式
+(void)showAlertFullWithStyle:(TRCustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    NSString *imageName=@"";
    if (style==TRCustomAlertStyleSuccess) {
        imageName=@"success_blue";
    }else if (style==TRCustomAlertStyleError){
        imageName=@"error_blue";
    }else if (style==TRCustomAlertStyleWarning){
        imageName=@"warning_blue";
    }
    //    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
    //                            stringByAppendingPathComponent:@"/CustomAlertImage.bundle"];
    NSBundle *resource_bundle = [[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] creatAlertViewWithButtonTitleArray:@[@"取消",@"确定"] image:[UIImage imageNamed:imageName inBundle:resource_bundle
                                                                     compatibleWithTraitCollection:nil] title:title isFull:YES content:content complete:completeBlock];
}

//自带确定和取消，自定义图片
+(void)showAlertFullWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [[self sharedView] creatAlertViewWithButtonTitleArray:@[@"取消",@"确定"] image:image title:title isFull:YES content:content complete:completeBlock];
}

//确定样式
+(void)showAlertFinishWithStyle:(TRCustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    NSString *imageName=@"";
    if (style==TRCustomAlertStyleSuccess) {
        imageName=@"success_blue";
    }else if (style==TRCustomAlertStyleError){
        imageName=@"error_blue";
    }else if (style==TRCustomAlertStyleWarning){
        imageName=@"warning_blue";
    }
    //    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
    //                            stringByAppendingPathComponent:@"/CustomAlertImage.bundle"];
    NSBundle *resource_bundle =[[self sharedView] bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"];
    [[self sharedView] creatAlertViewWithButtonTitleArray:@[@"确定"] image:[UIImage imageNamed:imageName inBundle:resource_bundle
                                                               compatibleWithTraitCollection:nil]  title:title isFull:YES content:content complete:completeBlock];
}

//确定按钮，自定义图片
+(void)showAlertFinishWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock{
    [[self sharedView] creatAlertViewWithButtonTitleArray:@[@"确定"] image:image title:title isFull:YES content:content complete:completeBlock];
}

#pragma mark 创建对话框样式
-(void)creatAlertViewWithButtonTitleArray:(NSArray<NSString *> *)titleArray image:(UIImage *)image title:(NSString *)title isFull:(BOOL)isFull content:(NSString *)content complete:(complete)completeBlock{
    __weak TRCustomAlert *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakSelf.alertType=AlertTypeButton;
        [weakSelf dissmis];
        weakSelf.isFull=isFull;
        weakSelf.completeBlock=completeBlock;//保存代码快
        UIView *alertView=[[UIView alloc]init];
        weakSelf.alertView=alertView;
        alertView.backgroundColor=[UIColor whiteColor];
        alertView.layer.cornerRadius=10;
        alertView.layer.masksToBounds=YES;
        [weakSelf addSubview:alertView];
        
        CGFloat padding=5;
        CGFloat alertView_with=SCREEN_WIDTH*0.7;
        
        //提示图片
        UIImageView *titleImgView=nil;
        if (image!=nil) {
            titleImgView=[[UIImageView alloc]initWithImage:image];
            [alertView addSubview:titleImgView];
            titleImgView.frame=CGRectMake((alertView_with-35)/2,20, 35, 35);
        }
        
        
        //标题文字
        UILabel *titleLab=[[UILabel alloc]init];
        weakSelf.titleLab=titleLab;
        titleLab.font=[UIFont systemFontOfSize:18];
        titleLab.textColor=[weakSelf colorWithHexString:@"#0C71FF"];//
        titleLab.text=title;
        titleLab.textAlignment=NSTextAlignmentCenter;
        [alertView addSubview:titleLab];
        
        //内容文字
        UILabel *contentLab=[[UILabel alloc]init];
        weakSelf.contentLab=contentLab;
        contentLab.lineBreakMode=NSLineBreakByWordWrapping;
        contentLab.font=[UIFont systemFontOfSize:14];
        contentLab.numberOfLines=0;
        contentLab.text=content;
        contentLab.textColor=[weakSelf colorWithHexString:@"#333333"];
        contentLab.textAlignment=NSTextAlignmentCenter;
        [alertView addSubview:contentLab];
        
        //显示遮罩层
        
        
        CGFloat alertView_x=(SCREEN_WIDTH-alertView_with)/2;
        
        weakSelf.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        weakSelf.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        if (image!=nil) {
            titleLab.frame=CGRectMake(padding, CGRectGetMaxY(titleImgView.frame)+padding, alertView_with-padding*2, 30);
        }else{
            titleLab.frame=CGRectMake(padding, padding+10, alertView_with-padding*2, 30);
        }
        //如果没有传递标题，默认尺寸
        if ([title isEqualToString:@""]||title==nil) {
            titleLab.frame=CGRectMake(0, titleLab.frame.origin.y, alertView_with-padding*2, 1);
        }
        CGFloat contentLab_height=[weakSelf heightForString:content Width:alertView_with-40 font:contentLab.font];
        contentLab.frame=CGRectMake(20, CGRectGetMaxY(titleLab.frame)+padding, alertView_with-40, contentLab_height);
        
        //创建按钮
        if (titleArray.count>0) {
            //分割线
            CGFloat button_height=40;//按钮高度
            UIView *cutView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLab.frame)+padding+5, alertView_with, 1)];
            cutView.tag=101;
            cutView.backgroundColor=[weakSelf colorWithHexString:@"#e2e2e2"];//
            [alertView addSubview:cutView];
            
            for (int i=0;i<titleArray.count;i++) {
                NSString *title=titleArray[i];
                if ([title isKindOfClass:[NSString class]]) {
                    //这里只创建两个按钮
                    if (i==2) {
                        break;
                    }
                    UIButton *button=[UIButton buttonWithType:0];
                    [weakSelf.buttonArray addObject:button];
                    [button setTitle:title forState:0];
                    //默认颜色
                    if (i==1) {
                        [button setTitleColor:[weakSelf colorWithHexString:@"#0C71FF"] forState:0];
                        
                    }else{
                        if ([title isEqualToString:@"确定"]) {
                            [button setTitleColor:[weakSelf colorWithHexString:@"#0C71FF"] forState:0];
                        }else{
                            [button setTitleColor:[weakSelf colorWithHexString:@"#666666"] forState:0];
                        }
                    }
                    button.tag=i;
                    button.titleLabel.font=[UIFont systemFontOfSize:14];
                    [button addTarget:weakSelf action:@selector(completeClick:) forControlEvents:UIControlEventTouchUpInside];
                    [alertView addSubview:button];
                    CGFloat button_width=alertView_with;//按钮宽度
                    if (titleArray.count>1) {
                        button_width=alertView_with/2;
                    }
                    button.frame=CGRectMake(i*button_width, CGRectGetMaxY(cutView.frame), button_width, 40);
                }
            }
            //添加中间装饰线
            if(titleArray.count>1){
                UIView *cutView_mid=[[UIView alloc]initWithFrame:CGRectMake(alertView_with/2, CGRectGetMaxY(cutView.frame)+10, 1, 20)];
                cutView_mid.backgroundColor=cutView.backgroundColor;
                cutView_mid.tag=102;
                [alertView addSubview:cutView_mid];
            }
            
            
            CGFloat alertView_height=CGRectGetMaxY(cutView.frame)+button_height;
            CGFloat alertView_y=(SCREEN_HEIGHT-alertView_height)/2;
            weakSelf.alertView.frame=CGRectMake(alertView_x, alertView_y, alertView_with,alertView_height);
        }else{
            //没有按钮
            CGFloat alertView_height=CGRectGetMaxY(contentLab.frame)+padding;
            CGFloat alertView_y=(SCREEN_HEIGHT-alertView_height)/2;
            weakSelf.alertView.frame=CGRectMake(alertView_x, alertView_y, alertView_with,alertView_height);
        }
        //添加到视图上
        [[weakSelf frontWindow] addSubview:weakSelf];
        
        //显示
        [weakSelf animationWithIsShow:YES];
        
    }];
    
}

//按钮点击事件
-(void)completeClick:(UIButton *)sender{
    NSInteger index=sender.tag;
    NSString *title=sender.titleLabel.text;
    if (self.completeBlock!=nil) {
        self.completeBlock(index, title);
    }
    if (self.isFull&&index==0) {
        [self dissmis];
    }
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
-(void)setButtonColor:(UIColor *)color fontSize:(UIFont *)fontSize isAll:(BOOL)isAll index:(NSInteger)index{
    for (int i=0;i<self.buttonArray.count;i++) {
        UIButton *btn =self.buttonArray[i];
        if (isAll) {
            if(color!=nil){
                [btn setTitleColor:color forState:0];
            }
            if(fontSize!=nil){
                btn.titleLabel.font=fontSize;
            }
        }else{
            if (index==i) {
                if(color!=nil){
                    [btn setTitleColor:color forState:0];
                }
                if(fontSize!=nil){
                    btn.titleLabel.font=fontSize;
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
    [[self sharedView] setButtonColor:color fontSize:nil isAll:YES index:0];
}

+(void)setButtonFont:(UIFont *)font{
    [[self sharedView] setButtonColor:nil fontSize:font isAll:YES index:0];
}

+(void)setButtonFont:(UIFont *)font color:(UIColor *)color{
    [[self sharedView] setButtonColor:color fontSize:font isAll:YES index:0];
}

+(void)setButtonColor:(UIColor *)color index:(NSInteger)index{
    [[self sharedView] setButtonColor:color fontSize:nil isAll:NO index:index];
}

+(void)setButtonFont:(UIFont *)font index:(NSInteger)index{
    [[self sharedView] setButtonColor:nil fontSize:font isAll:NO index:index];
}

+(void)setButtonFont:(UIFont *)font color:(UIColor *)color index:(NSInteger)index{
    [[self sharedView] setButtonColor:color fontSize:font isAll:NO index:index];
}

+(void)setAlertCornerRadius:(CGFloat)value{
    [self sharedView].alertView.layer.cornerRadius=value;
    [self sharedView].alertView.layer.masksToBounds=YES;
}

+(void)setFontColor:(UIColor *)color{
    [self sharedView].contentLab.textColor=color;
}

+(void)setFont:(UIFont *)font{
    
    UIView *alertView=[self sharedView].alertView;
    UILabel *lab=[self sharedView].contentLab;
    lab.font=font;
    CGRect frame=lab.frame;
    CGRect alertViewFrame=alertView.frame;
    if([self sharedView].alertType==AlertTypeSimple){
        //简单提示框
        CGRect viewFrame=[self sharedView].frame;
        CGFloat alertView_with=SCREEN_WIDTH*0.5;
        CGFloat newHeight=[[self sharedView] heightForString:lab.text Width:alertView_with-15*2 font:font];
        frame.size.height=newHeight;
        alertViewFrame.size.height=CGRectGetMaxY(frame)+40;
        if (![self sharedView].isShade) {
            //没有遮罩层
            viewFrame.size.height=CGRectGetMaxY(frame)+15;
            CGFloat viewFrame_y=(SCREEN_HEIGHT-viewFrame.size.height)/2;
            viewFrame.origin.y=viewFrame_y;
        }else{
            CGFloat alertViewFrame_y=(SCREEN_HEIGHT-alertViewFrame.size.height)/2;
            alertViewFrame.origin.y=alertViewFrame_y;
        }
        lab.frame=frame;
        [self sharedView].frame=viewFrame;
        alertView.frame=alertViewFrame;
        
    }else if([self sharedView].alertType==AlertTypeButton||[self sharedView].alertType==AlertTypeLoading){
        //提示框,loading
        [alertView.layer removeAllAnimations];//移除所有动画
        alertView.hidden=YES;//隐藏控件
        NSTimer *time=  [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(showAlert:) userInfo:@{@"font":font} repeats:NO];
        [self sharedView].time=time;;
        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    }
    
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
    }else{
        //对话框
        CGFloat alertView_with=SCREEN_WIDTH*0.7;
        CGFloat newHeight=[[self sharedView] heightForString:lab.text Width:alertView_with-20*2 font:font];
        frame.size.height=newHeight;
        lab.frame=frame;
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
            cutView_Horizontal_Frame.origin.y=CGRectGetMaxY(frame)+10;
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
        alertViewFrame.origin.y=(SCREEN_HEIGHT-alertViewFrame.size.height)/2;
        alertView.frame=alertViewFrame;
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

#pragma mark 加载等待

//创建加载等待
-(void)createLoadingWithMessage:(NSString *)message{
    __weak TRCustomAlert *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        weakSelf.alertType=AlertTypeLoading;
        [weakSelf dissmis];
        UIView *alertView=[[UIView alloc]init];
        weakSelf.alertView=alertView;
        alertView.backgroundColor= [UIColor colorWithWhite:0.1 alpha:0.7];
        alertView.layer.cornerRadius=10;
        alertView.layer.masksToBounds=YES;
        [weakSelf addSubview:alertView];
        
        if(weakSelf.wkWebView==nil){
            WKWebView *wkWebView=[[WKWebView alloc]init];
            weakSelf.wkWebView=wkWebView;
            NSString *path = [[weakSelf bundleWithBundleName:@"CustomAlertImage" podName:@"CustomAlert"] pathForResource:@"loading" ofType:@"gif"];
            NSData *gifData = [NSData dataWithContentsOfFile:path];
            [wkWebView loadData:gifData MIMEType:@"image/gif" characterEncodingName:nil baseURL:nil];
            
        }
        [alertView addSubview:weakSelf.wkWebView];
        weakSelf.wkWebView.backgroundColor = [UIColor clearColor];
        weakSelf.wkWebView.opaque = NO;
        CGFloat padding=10;//间距
        
        weakSelf.backgroundColor=[UIColor clearColor];
        
        CGFloat wkWebView_width=73;
        if ([message isEqualToString:@""]||message==nil) {
            CGFloat alertView_with=88;
            CGFloat alertView_x=(SCREEN_WIDTH-alertView_with)/2;
            CGFloat alertView_y=(SCREEN_HEIGHT-alertView_with)/2;
            weakSelf.frame=CGRectMake(alertView_x, alertView_y, alertView_with, alertView_with);
            alertView.frame=CGRectMake(0, 0, alertView_with, alertView_with);
            weakSelf.wkWebView.frame=CGRectMake((alertView_with-wkWebView_width)/2, (alertView_with-wkWebView_width)/2,wkWebView_width,wkWebView_width);
        }else{
            CGFloat alertView_with=150;
            //有文字
            UILabel *titleLab=[[UILabel alloc]init];
            weakSelf.contentLab=titleLab;
            titleLab.textColor=[UIColor whiteColor];
            titleLab.font=[UIFont systemFontOfSize:15];
            titleLab.numberOfLines=0;
            titleLab.text=message;
            titleLab.textAlignment=NSTextAlignmentCenter;
            [alertView addSubview:titleLab];
            CGFloat titleLab_height=[weakSelf heightForString:message Width:alertView_with-padding font:titleLab.font];
            weakSelf.wkWebView.frame=CGRectMake((alertView_with-wkWebView_width)/2, 0,wkWebView_width,wkWebView_width);
            titleLab.frame=CGRectMake(padding/2, CGRectGetMaxY(weakSelf.wkWebView.frame)-padding, alertView_with-padding, titleLab_height);
            
            alertView.frame=CGRectMake(0, 0, alertView_with, CGRectGetMaxY(titleLab.frame)+padding+5);
            CGFloat alertView_height=CGRectGetMaxY(alertView.frame);
            CGFloat alertView_x=(SCREEN_WIDTH-alertView_with)/2;
            CGFloat alertView_y=(SCREEN_HEIGHT-alertView_height)/2;
            weakSelf.frame=CGRectMake(alertView_x, alertView_y, alertView_with, CGRectGetMaxY(titleLab.frame)+padding+5);
        }
        
        //添加到视图上
        [[weakSelf frontWindow] addSubview:weakSelf];
        //显示
        [weakSelf animationWithIsShow:YES];
    }];
    
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
    [[self sharedView] createLoadingWithMessage:nil];
}
//loading有文字
+(void)showLoadingWithMessage:(NSString *)message{
    [[self sharedView] createLoadingWithMessage:message];
}

@end
