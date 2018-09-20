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
    [self.arrayData addObjectsFromArray:@[@"loading",@"loading-有文字",@"无图片的简单提醒"]];
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
//        [TRCustomAlert dissmis];
//        [SVProgressHUD showSuccessWithStatus:@"简单成功提示"];
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
        [TRCustomAlert setButtonFont:[UIFont systemFontOfSize:18] index:1];
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
         [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
    }else{
        [TRCustomAlert showMessage:@"无图片的简单提醒" image:nil];
    }
}
- (IBAction)closeLoading:(id)sender {
    [TRCustomAlert dissmis];
}

@end
