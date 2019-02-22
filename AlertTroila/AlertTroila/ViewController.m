//
//  ViewController.m
//  AlertTroila
//
//  Created by Admin on 2018/9/13.
//  Copyright © 2018年 马银伟. All rights reserved.
//

#import "ViewController.h"
#import "TRCustomAlert.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSMutableArray *arrayData;//总数据源

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"示例";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.dataSource=self;
    tableView.delegate=self;
    [self.view addSubview:tableView];
   
    [self.arrayData addObjectsFromArray:@[@"简单成功提示",@"简单失败提示",@"遮罩-简单成功提示",@"遮罩-简单失败提示",@"遮罩-简单成功提示【自定义图片】"]];
    [self.arrayData addObjectsFromArray:@[@"alert-警告提示【默认双按钮】-带默认图",@"alert-成功提示【默认单按钮】-自定义图",@"alert-提示【自定义按钮】-不带图",@"alert-成功提示【默认双按钮】-无标题"]];
    //自定义样式
    [self.arrayData addObjectsFromArray:@[@"设置背景色-橘黄色",@"设置alert-模式的底部按钮颜色",@"设置alert-模式的底部按钮字号",@"设置简单框字体大小",@"设置提示框字体大小"]];
    //加载等待
    [self.arrayData addObjectsFromArray:@[@"loading",@"loading-有文字",@"无图片的简单提醒",@"显示遮罩的loading（透明遮罩）"]];
    
    [self.arrayData addObjectsFromArray:@[@"底部纯文字",@"显示警告简单提示框",@"alert-提示底部无按钮"]];
    
    [self.arrayData addObjectsFromArray:@[@"进度条",@"带按钮的进度条",@"自定义按钮名称的进度条",@"自定义中间视图"]];
    [self.arrayData addObjectsFromArray:@[@"对话框没有图"]];
    [self.arrayData addObjectsFromArray:@[@"显示自适应底部提示框"]];
    [tableView reloadData];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
    }
    cell.textLabel.text=self.arrayData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        //对话框类型
        [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleWarning title:@"警告" content:@"alert-警告提示【默认双按钮】-带默认图" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
    }else if (indexPath.row==6) {
        [TRCustomAlert showAlertFinishWithImage:[UIImage imageNamed:@"my_icon"] title:@"成功" content:@"alert-成功提示【默认单按钮】-自定义图" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
    }else if (indexPath.row==7) {
        [TRCustomAlert showAlertWithButtonTitleArray:@[@"取消",@"进入"] style:TRCustomAlertStyleNone title:@"请跳入" content:@"alert-提示【自定义按钮】-不带图" complete:^(NSInteger index, NSString *title) {
            [TRCustomAlert dissmis];
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
    }else if (indexPath.row==8) {
        [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleSuccess title:nil content:@"alert-成功提示【默认双按钮】-无标题" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
    }else if (indexPath.row==9) {
        //样式控制
        [TRCustomAlert showSuccessWithMessage:@"设置背景色-橘黄色"];
        [TRCustomAlert setBackgroundColor:[UIColor orangeColor]];
    }else if (indexPath.row==10) {
        [TRCustomAlert showAlertWithButtonTitleArray:@[@"取消",@"注意"] style:TRCustomAlertStyleNone title:@"样式颜色" content:@"设置alert-模式的底部按钮颜色" complete:^(NSInteger index, NSString *title) {
            [TRCustomAlert dissmis];
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
        [TRCustomAlert setButtonColor:[UIColor redColor] index:1];
    }else if (indexPath.row==11) {
        //
        [TRCustomAlert showAlertWithButtonTitleArray:@[@"取消",@"字号"] style:TRCustomAlertStyleNone title:@"样式按钮字号" content:@"设置alert-模式的底部按钮字号" complete:^(NSInteger index, NSString *title) {
            [TRCustomAlert dissmis];
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
//        [TRCustomAlert setButtonFont:[UIFont systemFontOfSize:18] index:1];
        [TRCustomAlert setButtonColor:[UIColor redColor] index:0];
        [TRCustomAlert setButtonFont:[UIFont systemFontOfSize:20] index:0];
        
    }else if (indexPath.row==12) {
        [TRCustomAlert showErrorWithMessage:@"设置简单框字体大小"];
        [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
    }else if (indexPath.row==13) {
        [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleWarning title:nil content:@"设置提示框字体大小设置提示框字体大小设置提示框字体大小设置提示框字体大小" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
        [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
    }else if (indexPath.row==14) {
        //加载等待
        [TRCustomAlert showLoading];
    }else if (indexPath.row==15) {
        //加载等待
        [TRCustomAlert showLoadingWithMessage:@"loading-有文字loading-有文字loading-有文字loading-有文字loading-有文字"];
//         [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
    }else if (indexPath.row==16){
        [TRCustomAlert showMessage:@"无图片的简单提醒" image:nil];
    }else if (indexPath.row==17){
        [TRCustomAlert showShadeLoadingWithMessage:@"显示遮罩的loading（透明遮罩）"];
        [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
    }else if (indexPath.row==18){
        [TRCustomAlert showBottomMessage:@"底部纯文字底部纯文字底1aaaaaaa"];
//         [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
       
    }else if(indexPath.row==19){
        [TRCustomAlert showWarningWithMessage:@"显示警告简单提示框"];
    } else if(indexPath.row==20){
        [TRCustomAlert showAlertWithButtonTitleArray:@[] style:TRCustomAlertStyleSuccess title:@"提示" content:@"alert-提示底部无按钮" complete:^(NSInteger index, NSString *title) {
            
        }];
    }else if(indexPath.row==21){
       TRCustomAlert *pg= [TRCustomAlert showProgressWithTitle:@"提示" content:@"正在链接服务器"];
        self.pg=pg;
        NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delayMethods) userInfo:nil repeats:YES];
        self.time=timer;
    }else if(indexPath.row==22){
        TRCustomAlert *pg= [TRCustomAlert showProgressWithTitle:@"提示" content:@"正在链接服务器" complete:^(NSInteger index, NSString *title) {
            [self.time invalidate];
            self.time=nil;
        }];
        self.pg=pg;
        NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delayMethods) userInfo:nil repeats:YES];
        self.time=timer;
    }else if(indexPath.row==23){
        TRCustomAlert *pg= [TRCustomAlert showProgressWithTitle:@"提示" content:@"正在链接服务器" buttonTitle:@"断开" complete:^(NSInteger index, NSString *title) {
            [self.time invalidate];
            self.time=nil;
        }];
        [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
        self.pg=pg;
        NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delayMethods) userInfo:nil repeats:YES];
        self.time=timer;
    }else if(indexPath.row==24){
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
        
    }else if(indexPath.row==25){
        [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleNone title:@"标题" content:@"对话框没有对话框" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];[TRCustomAlert showFitBottomMessage:@"ddddddddddddddd12313213214"];
    }else if(indexPath.row==26){
        [TRCustomAlert showFitBottomMessage:@"底部自适应弹框"];
    }
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
