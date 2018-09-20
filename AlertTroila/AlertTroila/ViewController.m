//
//  ViewController.m
//  AlertTroila
//
//  Created by Admin on 2018/9/13.
//  Copyright © 2018年 马银伟. All rights reserved.
//

#import "ViewController.h"
#import "CustomAlert.h"
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
//        [CustomAlert dissmis];
//        [SVProgressHUD showSuccessWithStatus:@"简单成功提示"];
        [CustomAlert showSuccessWithMessage:@"简单成功提示"];
    }else if (indexPath.row==1) {
        [CustomAlert showErrorWithMessage:@"简单失败提示"];
    }else if (indexPath.row==2) {
        [CustomAlert showShadeSuccessWithMessage:@"遮罩-简单成功提示"];
    }else if (indexPath.row==3) {
        [CustomAlert showShadeErrorWithMessage:@"遮罩-简单失败提示"];
    }else if (indexPath.row==4) {
        [CustomAlert showShadeWithMessage:@"遮罩-简单成功提示【自定义图片】"  image:[UIImage imageNamed:@"success"]];
    }else if (indexPath.row==5) {
        //对话框类型
        [CustomAlert showAlertFullWithStyle:CustomAlertStyleWarning title:@"警告" content:@"alert-警告提示【默认双按钮】-带默认图" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
    }else if (indexPath.row==6) {
        [CustomAlert showAlertFinishWithImage:[UIImage imageNamed:@"my_icon"] title:@"成功" content:@"alert-成功提示【默认单按钮】-自定义图" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
    }else if (indexPath.row==7) {
        [CustomAlert showAlertWithButtonTitleArray:@[@"取消",@"进入"] style:CustomAlertStyleNone title:@"请跳入" content:@"alert-提示【自定义按钮】-不带图" complete:^(NSInteger index, NSString *title) {
            [CustomAlert dissmis];
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
    }else if (indexPath.row==8) {
        [CustomAlert showAlertFullWithStyle:CustomAlertStyleSuccess title:nil content:@"alert-成功提示【默认双按钮】-无标题" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
    }else if (indexPath.row==9) {
        //样式控制
        [CustomAlert showSuccessWithMessage:@"设置背景色-橘黄色"];
        [CustomAlert setBackgroundColor:[UIColor orangeColor]];
    }else if (indexPath.row==10) {
        [CustomAlert showAlertWithButtonTitleArray:@[@"取消",@"注意"] style:CustomAlertStyleNone title:@"样式颜色" content:@"设置alert-模式的底部按钮颜色" complete:^(NSInteger index, NSString *title) {
            [CustomAlert dissmis];
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
        [CustomAlert setButtonColor:[UIColor redColor] index:1];
    }else if (indexPath.row==11) {
        //
        [CustomAlert showAlertWithButtonTitleArray:@[@"取消",@"字号"] style:CustomAlertStyleNone title:@"样式按钮字号" content:@"设置alert-模式的底部按钮字号" complete:^(NSInteger index, NSString *title) {
            [CustomAlert dissmis];
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
        [CustomAlert setButtonFont:[UIFont systemFontOfSize:18] index:1];
    }else if (indexPath.row==12) {
        [CustomAlert showErrorWithMessage:@"设置简单框字体大小"];
        [CustomAlert setFont:[UIFont systemFontOfSize:20]];
    }else if (indexPath.row==13) {
        [CustomAlert showAlertFullWithStyle:CustomAlertStyleWarning title:nil content:@"设置提示框字体大小设置提示框字体大小设置提示框字体大小设置提示框字体大小" complete:^(NSInteger index, NSString *title) {
            NSLog(@"点击回调 按钮位置-index=%ld  按钮标题-title=%@",(long)index,title);
        }];
        [CustomAlert setFont:[UIFont systemFontOfSize:20]];
    }else if (indexPath.row==14) {
        //加载等待
        [CustomAlert showLoading];
    }else if (indexPath.row==15) {
        //加载等待
        [CustomAlert showLoadingWithMessage:@"loading-有文字loading-有文字loading-有文字loading-有文字loading-有文字"];
         [CustomAlert setFont:[UIFont systemFontOfSize:20]];
    }else{
        [CustomAlert showMessage:@"无图片的简单提醒" image:nil];
    }
}
- (IBAction)closeLoading:(id)sender {
    [CustomAlert dissmis];
}

@end
