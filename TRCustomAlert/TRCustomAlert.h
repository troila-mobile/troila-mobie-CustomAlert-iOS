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

typedef void (^complete)(NSInteger index,NSString *title);//回调block

@interface TRCustomAlert : UIView


/*设置样式*/


+(void)setBackgroundColor:(UIColor *)color;//设置背景色

+(void)setFontColor:(UIColor *)color;//设置简单框样式文字样色和对话框内容颜色,loading 文字

+(void)setFont:(UIFont *)font;//设置简单框样式文字样色和对话框内容字号,loading 文字


+(void)setTitleColor:(UIColor *)color;//设置对话框标题颜色  默认为#0C71FF

+(void)setTitleFont:(UIFont *)font;//设置对话框标题字号  默认为18

+(void)setButtonColor:(UIColor *)color;//设置对话框底部按钮颜色

+(void)setButtonFont:(UIFont *)font;//设置对话框底部按钮字号大小

+(void)setButtonFont:(UIFont *)font color:(UIColor *)color;//设置对话框底部按钮颜色和字号大小

+(void)setButtonColor:(UIColor *)color index:(NSInteger)index;//设置对话框底部按钮颜色，index:按钮位置

+(void)setButtonFont:(UIFont *)font index:(NSInteger)index;//设置对话框底部按钮字号大小，index:按钮位置

+(void)setButtonFont:(UIFont *)font color:(UIColor *)color index:(NSInteger)index;//设置对话框底部按钮颜色和字号大小 index:按钮位置

+(void)setAlertCornerRadius:(CGFloat)value;//设置显示框的圆角  默认为10

/*初始化方法*/

//显示成功提示
+(void)showSuccessWithMessage:(NSString *)message;

//显示错误提示
+(void)showErrorWithMessage:(NSString *)message;

//带遮罩层成功提示
+(void)showShadeSuccessWithMessage:(NSString *)message;

//带遮罩层失败提示
+(void)showShadeErrorWithMessage:(NSString *)message;

//自定义图片，简单按钮
+(void)showMessage:(NSString *)message image:(UIImage *)image;

//带遮罩层成功提示
+(void)showShadeWithMessage:(NSString *)message image:(UIImage *)image;




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

//加载等待
+(void)showLoading;

+(void)showLoadingWithMessage:(NSString *)message;
+(void)dissmis;//隐藏


@end


