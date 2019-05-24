//
//  ViewController.m
//  AlertTroila
//
//  Created by Admin on 2018/9/13.
//  Copyright © 2018年 马银伟. All rights reserved.
//

#import "ViewController.h"
#import "TRCustomAlert.h"
#import "Masonry.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSMutableArray *arrayData;//总数据源
@property(nonatomic,copy)NSMutableArray *arrayTitleData;//section标题
@property (nonatomic, strong)TRCustomAlert *pg;
@property (nonatomic, strong)NSTimer *time;
@end

@implementation ViewController

-(NSMutableArray *)arrayData
{
    if (_arrayData==nil) {
        _arrayData=[NSMutableArray array];
    }
    return _arrayData;
}

-(NSMutableArray *)arrayTitleData
{
    if (_arrayTitleData==nil) {
        _arrayTitleData=[NSMutableArray array];
    }
    return _arrayTitleData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"示例";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UITableView *tableView=[[UITableView alloc]init];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    [self.arrayTitleData addObjectsFromArray:@[@"简单提示",@"对话框",@"Loading",@"自定义视图"]];
    //【1】简单提示框
    [self.arrayData addObject:@[@"简单成功提示",@"简单失败提示",@"遮罩-简单成功提示",@"遮罩-简单失败提示",@"遮罩-简单成功提示【自定义图片】",@"设置背景色-橘黄色",@"底部固定宽度纯文字",@"底部自适应纯文字提示框",@"设置简单框字体大小",@"无图片的简单提醒"]];
    //【2】对话框
    [self.arrayData addObject:@[@"alert-警告提示【默认双按钮】-带默认图",@"alert-成功提示【默认单按钮】-自定义图",@"alert-提示【自定义按钮】-不带图",@"alert-成功提示【默认双按钮】-无标题",@"设置alert-模式的底部按钮颜色",@"alert-提示底部无按钮",@"设置alert-模式的内容字号",@"对话框没有图",@"修改对话框按钮背景颜色",@"按钮对话框，按钮点击颜色"]];
  
    //【3】加载等待
    [self.arrayData addObject:@[@"loading",@"loading-有文字",@"显示遮罩的loading（透明遮罩）",@"设置loading中心样式",]];
    
    //【4】自定义视图
    [self.arrayData addObject:@[@"进度条",@"带按钮的进度条",@"自定义按钮名称的进度条",@"自定义中间视图"]];
    [tableView reloadData];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.arrayTitleData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array=self.arrayData[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
    }
    NSArray *array=self.arrayData[indexPath.section];
    cell.textLabel.text=array[indexPath.row];
    cell.textLabel.textColor=[UIColor blueColor];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.arrayTitleData[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    if(indexPath.section==0){
        if (indexPath.row==0) {
            [TRCustomAlert showSuccessWithMessage:@"简单成功提示"];
        }else if (indexPath.row==1) {
            [TRCustomAlert showErrorWithMessage:@"简单失败提示"];
        }else if (indexPath.row==2) {
            [TRCustomAlert showShadeSuccessWithMessage:@"遮罩-简单成功提示"];
        }else if (indexPath.row==3) {
            [TRCustomAlert showShadeErrorWithMessage:@"遮罩-简单失败提示"];
        }else if (indexPath.row==4) {
            [TRCustomAlert showShadeWithMessage:@"遮罩-简单成功提示【自定义图片】"  image:[UIImage imageNamed:@"success"]];
        }else if (indexPath.row==5) {
            [TRCustomAlert showSuccessWithMessage:@"设置背景色-橘黄色"];
            [TRCustomAlert setBackgroundColor:[UIColor orangeColor]];
        }else if (indexPath.row==6) {
            [TRCustomAlert showBottomMessage:@"底部纯文字底部纯文字底1aaaaaaa"];
        }else if (indexPath.row==7) {
            [TRCustomAlert showFitBottomMessage:@"底部自适应弹框"];
        }else if (indexPath.row==8) {
            [TRCustomAlert showErrorWithMessage:@"设置简单框字体大小"];
            [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
        }else if (indexPath.row==9) {
             [TRCustomAlert showMessage:@"无图片的简单提醒" image:nil];
        }
    }else if(indexPath.section==1){
        
        if (indexPath.row==0) {
            [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleWarning title:@"警告" content:@"alert-警告提示【默认双按钮】-带默认图" complete:^(NSInteger index, NSString *title) {
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
        }else if (indexPath.row==1) {
            [TRCustomAlert showAlertFinishWithImage:[UIImage imageNamed:@"my_icon"] title:@"成功" content:@"alert-成功提示【默认单按钮】-自定义图" complete:^(NSInteger index, NSString *title) {
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
        }else if (indexPath.row==2) {
            [TRCustomAlert showAlertWithButtonTitleArray:@[@"取消",@"进入"] style:TRCustomAlertStyleNone title:@"请跳入" content:@"alert-提示【自定义按钮】-不带图" complete:^(NSInteger index, NSString *title) {
                [TRCustomAlert dissmis];
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
        }else if (indexPath.row==3) {
            [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleSuccess title:nil content:@"alert-成功提示【默认双按钮】-无标题" complete:^(NSInteger index, NSString *title) {
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
        }else if (indexPath.row==4) {
            [TRCustomAlert showAlertWithButtonTitleArray:@[@"取消",@"注意"] style:TRCustomAlertStyleNone title:@"样式颜色" content:@"设置alert-模式的底部按钮颜色" complete:^(NSInteger index, NSString *title) {
                [TRCustomAlert dissmis];
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
            [TRCustomAlert setButtonColor:[UIColor redColor] index:1];
        }else if (indexPath.row==5) {
            [TRCustomAlert showAlertWithButtonTitleArray:@[] style:TRCustomAlertStyleSuccess title:@"提示" content:@"alert-提示底部无按钮" complete:^(NSInteger index, NSString *title) {
                
            }];
        }else if (indexPath.row==6) {
            [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleWarning title:nil content:@"设置提示框字体大小设置提示框字体大小设置提示框字体大小设置提示框字体大小" complete:^(NSInteger index, NSString *title) {
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
            [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
        }else if (indexPath.row==7) {
            [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleNone title:@"标题" content:@"对话框没有图" complete:^(NSInteger index, NSString *title) {
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
        }else if (indexPath.row==8) {
            [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleNone title:@"警告" content:@"对话框按钮背景色" complete:^(NSInteger index, NSString *title) {
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
            [TRCustomAlert setButtonColor:[UIColor whiteColor] index:1];
            [TRCustomAlert setButtonBackgroundColor:[self colorWithHexString:@"#586BFB"] index:1];
        }else if (indexPath.row==9) {
            [TRCustomAlert showAlertWithButtonTitleArray:@[@"取消",@"注意"] style:TRCustomAlertStyleNone title:@"点击颜色" content:@"点击按钮改变背景色" complete:^(NSInteger index, NSString *title) {
                [TRCustomAlert dissmis];
                NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
            }];
            [TRCustomAlert setAlertBtnClickBackgroundColorWithColor:[self colorWithHexString:@"#586BFB"] index:1];
        }
    }else if(indexPath.section==2){
        
        if (indexPath.row==0) {
            [TRCustomAlert showLoading];
        }else if (indexPath.row==1) {
            [TRCustomAlert showLoadingWithMessage:@"loading-有文字"];
        }else if (indexPath.row==2) {
            [TRCustomAlert showShadeLoadingWithMessage:@"显示遮罩的loading（透明遮罩）"];
        }else if (indexPath.row==3) {
            [TRCustomAlert showLoadingWithMessage:@"设置loading中心样式"];
            [TRCustomAlert setLoadingWithStyle:TRLoadingStyleActivityIndicator];
        }
    }else if(indexPath.section==3){
        [self.arrayData addObject:@[@"进度条",@"带按钮的进度条",@"自定义按钮名称的进度条",@"自定义中间视图"]];
        if (indexPath.row==0) {
            TRCustomAlert *pg= [TRCustomAlert showProgressWithTitle:@"提示" content:@"正在链接服务器"];
            self.pg=pg;
            NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delayMethods) userInfo:nil repeats:YES];
            self.time=timer;
        }else if (indexPath.row==1) {
            TRCustomAlert *pg= [TRCustomAlert showProgressWithTitle:@"提示" content:@"正在链接服务器" complete:^(NSInteger index, NSString *title) {
                [self.time invalidate];
                self.time=nil;
            }];
            self.pg=pg;
            NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delayMethods) userInfo:nil repeats:YES];
            self.time=timer;
        }else if (indexPath.row==2) {
            TRCustomAlert *pg= [TRCustomAlert showProgressWithTitle:@"提示" content:@"正在链接服务器" buttonTitle:@"断开" complete:^(NSInteger index, NSString *title) {
                [self.time invalidate];
                self.time=nil;
            }];
            [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
            self.pg=pg;
            NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delayMethods) userInfo:nil repeats:YES];
            self.time=timer;
        }else if (indexPath.row==3) {
            UIDatePicker *datePicker = [UIDatePicker new];
            datePicker.datePickerMode = UIDatePickerModeTime;
            datePicker.frame = CGRectMake(0.0, 0.0, datePicker.frame.size.width, 160.0);
            
            [TRCustomAlert showCustomeViewWithButtonTitleArray:@[@"关闭",@"确定"] innerView:datePicker title:@"自定义视图" content:@"自定义视图-请选择时间" complete:^(UIView *innerView, NSInteger index, NSString *title) {
                NSDate *select_data=((UIDatePicker *)innerView).date;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *strDate = [dateFormatter stringFromDate:select_data];
                NSLog(@"选择的时间为:%@",strDate);
            }];
        }
    }
    
    
    
    
    
    
//
//    if (indexPath.row==11) {
//        //
//        [TRCustomAlert showAlertWithButtonTitleArray:@[@"取消",@"字号"] style:TRCustomAlertStyleNone title:@"样式按钮字号" content:@"设置alert-模式的底部按钮字号" complete:^(NSInteger index, NSString *title) {
//            [TRCustomAlert dissmis];
//            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
//        }];
//        [TRCustomAlert setButtonColor:[UIColor redColor] index:0];
//        [TRCustomAlert setButtonFont:[UIFont systemFontOfSize:20] index:0];
//
//    } if(indexPath.row==21){
//
//    }else if(indexPath.row==22){
//
//    }else if(indexPath.row==23){
//
//    }else if(indexPath.row==24){
//
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




-(void)delayMethods{
    self.pg.progress+=0.01;
    if (self.pg.progress>=1.0) {
        [self.time invalidate];
        self.time=nil;
        [TRCustomAlert dissmis];
    }
}
- (IBAction)closeLoading:(id)sender {
    [TRCustomAlert dissmis];
}

@end
