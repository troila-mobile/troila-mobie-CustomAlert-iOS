# TRCustomAlert V0.0.8

![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TRCustomAlert.svg)
![Pod Platform](https://img.shields.io/cocoapods/p/TRCustomAlert.svg?style=flat)
![Pod License](http://img.shields.io/cocoapods/l/TRCustomAlert.svg?style=flat)

项目集成 `pod 'TRCustomAlert'`

导入头文件 `#import "TRCustomAlert.h"`

>前言：该框架api调用均为类方法，在设置样式时，需创建弹框实体在设置样式
### 项目API组成
##### api总共分为四个部分
* 简单提示框类型
* 带按钮强提示框类型
* 加载等待（loading)提示框类型
* 弹框属性设置

### 1、简单提示框样式
>简单提示框，默认消失时间为2秒

| 方法名 | 说明 | 
| - | - | 
|`+(void)showSuccessWithMessage:(NSString *)message`| 显示简单成功提示框|
| `+(void)showErrorWithMessage:(NSString *)message` | 显示简单错误提示框 |
| `+(void)showWarningWithMessage:(NSString *)message` | 显示简单警告提示框 |
|`+(void)showShadeSuccessWithMessage:(NSString *)message`| 显示有遮罩简单成功提示框 |
|`+(void)showShadeErrorWithMessage:(NSString *)message`|显示有遮罩错误提示框 |
|`+(void)showShadeWarningWithMessage:(NSString *)message`|显示有遮罩警告提示框 |
|`+(void)showMessage:(NSString *)message image:(UIImage *)image`|显示自定义顶部图标简单提示框，(参数传nil可以，不显示图片) |
|`+(void)showShadeWithMessage:(NSString *)message image:(UIImage *)image`|显示有遮罩自定义顶部图标简单提示框，(参数传nil可以，不显示图片) |
|`+(void)showBottomMessage:(NSString *)message`|显示在底部的纯文字提示框|


### 2、带按钮的强提示框
>参数中`CustomAlertStyle`标识该弹框的类型分为以下三个类型，分别对应三种默认图片
```
    CustomAlertStyleSuccess,//默认成功图片
    CustomAlertStyleError,//默认错误图片
    CustomAlertStyleWarning,//默认警告图片
    CustomAlertStyleNone  //没有图片
```


| 方法名 | 说明 | 
| - | - | 
|`+(void)showAlertFullWithStyle:(CustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock`| 自带确定和取消，默认图片样式|
| `+(void)showAlertFullWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock` | 自带确定和取消，自定义图片样式 |
|`+(void)showAlertFinishWithStyle:(CustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock`|只有一个确定按钮样式，默认图片 |
|`+(void)showAlertFinishWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock`|只有一个确定按钮样式，自定义图片|
|`+(void)showAlertWithButtonTitleArray:(NSArray<NSString *> *)titleArray style:(CustomAlertStyle)style title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock`| 自定义按钮（`titleArray`参数传递按钮显示字符即可），默认图片样式|
|`+(void)showAlertWithButtonTitleArray:(NSArray<NSString *> *)titleArray image:(UIImage *)image title:(NSString *)title content:(NSString *)content complete:(complete)completeBlock`|自定义按钮（`titleArray`参数传递按钮显示字符即可），自定义图片样式 |

### 3、加载（loading）等待样式
| 方法名 | 说明 | 
| - | - | 
|`+(void)showLoading`| 不带文字的加载等待|
|`+(void)showShadeLoading`| 不带文字的有遮罩的加载等待|
| `+(void)showLoadingWithMessage:(NSString *)message` | 带文字的加载等待 |
| `+(void)showShadeLoadingWithMessage:(NSString *)message` | 带文字和遮罩的加载等待 |

### 4、隐藏以上窗体方法
`+(void)dissmis;//隐藏`

### 5、进度条和自定义视图
进度条进度设置通过 `@property(nonatomic,assign)CGFloat progress;//进度 0~1` 属性控制

| 方法名 | 说明 | 
| - | - | 
|`+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content`| 根据标题和内容创建进度条|
| `+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content complete:(complete)completeBlock` | 根据标题和内容创建带按钮的进度条 |
|`+(instancetype)showProgressWithTitle:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle complete:(complete)completeBlock`| 根据用户自定义按钮创建进度条|
|`+(instancetype)showCustomeViewWithButtonTitleArray:(NSArray<NSString *> *)buttonTitleArray innerView:(UIView *)innerView title:(NSString *)title content:(NSString *)content  complete:(customComplete)completeBlock`|根据用户自定义按钮和中间视图，创建弹框 |



### 6、样式设置

| 方法名 | 说明 | 
| - | - | 
|`+(void)setBackgroundColor:(UIColor *)color`| 设置背景色|
| `+(void)setFontColor:(UIColor *)color;` | 设置文字字体颜色（简单框文字，按钮框的内容，loading框文字） |
|`+(void)setFont:(UIFont *)font`| 设置文字字体字体（简单框文字，按钮框的内容，loading框文字）|
|`+(void)setTitleColor:(UIColor *)color`|设置按钮框标题颜色 |
|`+(void)setTitleFont:(UIFont *)font`|设置按钮框标题字体 |
|`+(void)setButtonColor:(UIColor *)color`|设置按钮弹框底部所有按钮颜色 |
|`+(void)setButtonFont:(UIFont *)font`|设置按钮弹框底部所有按钮字体 |
|`+(void)setButtonFont:(UIFont *)font color:(UIColor *)color`|设置按钮弹框底部所有按钮字体和颜色 |
|`+(void)setButtonColor:(UIColor *)color index:(NSInteger)index`|设置按钮弹框底部按钮index位置的颜色（这个位置和`titleArray`传递的顺序一致） |
|`+(void)setButtonFont:(UIFont *)font index:(NSInteger)index`|设置按钮弹框底部按钮index位置的字体（这个位置和`titleArray`传递的顺序一致） |
|`+(void)setButtonFont:(UIFont *)font color:(UIColor *)color index:(NSInteger)index`|设置按钮弹框底部按钮index位置的字体和颜色（这个位置和`titleArray`传递的顺序一致）|
|`+(void)setAlertCornerRadius:(CGFloat)value`|设置弹框的圆角 |
|`+(void)setConfirmImageColor:(UIColor *)color;`|设置确认框图片颜色 |

### 7、部分效果图

<img src="https://upload-images.jianshu.io/upload_images/1785506-c3c9e5fdb0d5799b.gif?imageMogr2/auto-orient/strip" width="214"/>  <img src="https://upload-images.jianshu.io/upload_images/1785506-c47a79a0dfd90b33.gif?imageMogr2/auto-orient/strip" width="214"/>   <img src="https://upload-images.jianshu.io/upload_images/1785506-aff85327b4a17c1a.gif?imageMogr2/auto-orient/strip" width="214"/>



<img src="https://upload-images.jianshu.io/upload_images/1785506-2661adc29b7d5661.gif?imageMogr2/auto-orient/strip" width="214"/>  <img src="https://upload-images.jianshu.io/upload_images/1785506-151e05c3526c9b33.gif?imageMogr2/auto-orient/strip" width="214"/>   <img src="https://upload-images.jianshu.io/upload_images/1785506-c7711b4c9a1d6681.gif?imageMogr2/auto-orient/strip" width="214"/>


<img src="https://upload-images.jianshu.io/upload_images/1785506-0842d64b28778603.gif?imageMogr2/auto-orient/strip" width="214"/> <img src="https://upload-images.jianshu.io/upload_images/1785506-c2434a6526ba561f.gif?imageMogr2/auto-orient/strip" width="214"/>   <img src="https://upload-images.jianshu.io/upload_images/1785506-1b3dc949924b9afc.gif?imageMogr2/auto-orient/strip" width="214"/> 



<img src="https://upload-images.jianshu.io/upload_images/1785506-23547873377d7a59.gif?imageMogr2/auto-orient/strip" width="214"/> <img src="https://upload-images.jianshu.io/upload_images/1785506-ab7d81139dd9090c.gif?imageMogr2/auto-orient/strip" width="214"/>   <img src="https://upload-images.jianshu.io/upload_images/1785506-e2ebae1516a57546.gif?imageMogr2/auto-orient/strip" width="214"/>


<img src="https://upload-images.jianshu.io/upload_images/1785506-40795b1e5add6df2.gif?imageMogr2/auto-orient/strip" width="214"/> <img src="https://upload-images.jianshu.io/upload_images/1785506-c9fa6ed36bd4466d.gif?imageMogr2/auto-orient/strip" width="214"/>
