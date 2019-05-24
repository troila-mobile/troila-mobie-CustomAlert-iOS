//
//  TRCustomAlert.h
//  AlertTroila
//
//  Created by Admin on 2018/9/20.
//  Copyright © 2018年 马银伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TRCustomAlertStyle) {
    TRCustomAlertStyleSuccess,//默认成功图片
    TRCustomAlertStyleError,//默认错误图片
    TRCustomAlertStyleWarning,//默认警告图片
    TRCustomAlertStyleNone  //没有图片
};

typedef NS_ENUM(NSInteger, TRLoadingStyle) {
    TRLoadingStyleNormal,//默认蓝色gif图片
    TRLoadingStyleActivityIndicator //系统loading
};

typedef void (^complete)(NSInteger index,NSString *title);//回调block

typedef void (^customComplete)(UIView *innerView,NSInteger index,NSString *title);//自定义视图回调block

@interface TRCustomAlert : UIView


/*设置样式*/

+(void)setBackgroundColor:(UIColor *)color;//设置背景色

+(void)setFontColor:(UIColor *)color;//设置简单框样式文字样色和对话框内容颜色,loading 文字

+(void)setFont:(UIFont *)font;//设置简单框样式文字字号和对话框内容字号,loading 文字


+(void)setTitleColor:(UIColor *)color;//设置对话框标题颜色  默认为#0C71FF

+(void)setTitleFont:(UIFont *)font;//设置对话框标题字号  默认为18

+(void)setButtonColor:(UIColor *)color;//设置对话框底部按钮颜色

+(void)setButtonBackgroundColor:(UIColor *)color index:(NSInteger)index;//设置对话框底部按钮背景颜色

+(void)setButtonFont:(UIFont *)font;//设置对话框底部按钮字号大小

+(void)setButtonFont:(UIFont *)font color:(UIColor *)color;//设置对话框底部按钮颜色和字号大小

+(void)setButtonColor:(UIColor *)color index:(NSInteger)index;//设置对话框底部按钮颜色，index:按钮位置

+(void)setButtonFont:(UIFont *)font index:(NSInteger)index;//设置对话框底部按钮字号大小，index:按钮位置

+(void)setButtonFont:(UIFont *)font color:(UIColor *)color index:(NSInteger)index;//设置对话框底部按钮颜色和字号大小 index:按钮位置

+(void)setAlertCornerRadius:(CGFloat)value;//设置显示框的圆角  默认为10

//设置确认框图片颜色
+(void)setConfirmImageColor:(UIColor *)color;


/*初始化方法*/

//显示成功提示
+(void)showSuccessWithMessage:(NSString *)message;

//显示错误提示
+(void)showErrorWithMessage:(NSString *)message;

//显示警告提示
+(void)showWarningWithMessage:(NSString *)message;

//带遮罩层成功提示
+(void)showShadeSuccessWithMessage:(NSString *)message;

//带遮罩层失败提示
+(void)showShadeErrorWithMessage:(NSString *)message;

//带遮罩层警告提示
+(void)showShadeWarningWithMessage:(NSString *)message;

//自定义图片，简单按钮
+(void)showMessage:(NSString *)message image:(UIImage *)image;

//带遮罩层成功提示
+(void)showShadeWithMessage:(NSString *)message image:(UIImage *)image;

//显示在底部的纯文字，简单框
+(void)showBottomMessage:(NSString *)message;

//显示底部自适应纯文字，简单框
+(void)showFitBottomMessage:(NSString *)message;

//自定义按钮，默认图片样式
+(void)showAlertWithButtonTitleArray:(NSArray<NSString *> *)titleArray style:(TRCustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock;


//自定义按钮，自定义图片
+(void)showAlertWithButtonTitleArray:(NSArray<NSString *> *)titleArray image:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock;


//自带确定和取消，默认图片样式
+(void)showAlertFullWithStyle:(TRCustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock;


//自带确定和取消，自定义图片样式
+(void)showAlertFullWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock;

//自带确定按钮,
+(void)showAlertFinishWithStyle:(TRCustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock;

//确定按钮，自定义图片样式
+(void)showAlertFinishWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock;


/**
 设置对话框按钮点击状态背景色,默认没有

 @param color 颜色
 @param index 按钮位置
 */
+(void)setAlertBtnClickBackgroundColorWithColor:(UIColor *)color index:(NSInteger)index;

//加载等待
+(void)showLoading;
+(void)showShadeLoading;//显示遮罩层

+(void)showLoadingWithMessage:(NSString *)message;
+(void)showShadeLoadingWithMessage:(NSString *)message;//显示遮罩层

//设置loading样式
+(void)setLoadingWithStyle:(TRLoadingStyle)style;
+(void)dissmis;//隐藏


//加载进度
+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content;

//带按钮的进度条
+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content complete:(complete)completeBlock;

//自定义按钮名称的进度条
+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle complete:(complete)completeBlock;

//自定义中间视图
+(instancetype)showCustomeViewWithButtonTitleArray:(NSArray<NSString *> *)buttonTitleArray innerView:(UIView *)innerView title:(NSString *)title content:(NSString *)content  complete:(customComplete)completeBlock;


@property(nonatomic,assign)CGFloat progress;//进度 0~1
@property (nonatomic, strong)UIView *innerView;//自定义视图
@end


