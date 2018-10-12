//
//  ShowKeyBoardViewController.m
//  AlertTroila
//
//  Created by Admin on 2018/10/12.
//  Copyright © 2018 马银伟. All rights reserved.
//

#import "ShowKeyBoardViewController.h"
#import "TRCustomAlert.h"
@interface ShowKeyBoardViewController ()

@end

@implementation ShowKeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)closeAlert:(id)sender {
    [TRCustomAlert dissmis];
}



- (IBAction)showSimpAlert:(id)sender {
    
     [TRCustomAlert showSuccessWithMessage:@"测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘"];
    

//    [TRCustomAlert setFont:[UIFont systemFontOfSize:20]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}


- (IBAction)showBottomAlert:(id)sender {
    [TRCustomAlert showBottomMessage:@"测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘"];
}
- (IBAction)showButtonAlert:(id)sender {
    
    [TRCustomAlert showAlertFullWithStyle:TRCustomAlertStyleSuccess title:@"ceshi" content:@"测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试" complete:^(NSInteger index, NSString *title) {
        
    }];

}
- (IBAction)showLoadingAlert:(id)sender {
    [TRCustomAlert showLoadingWithMessage:@"测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘测试键盘"];
}
- (IBAction)showCustomAlert:(id)sender {
    
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.frame = CGRectMake(0.0, 0.0, datePicker.frame.size.width, 260.0);
    
    [TRCustomAlert showCustomeViewWithButtonTitleArray:@[@"关闭",@"确定"] innerView:datePicker title:@"自定义视图" content:@"自定义视图-请选择时间" complete:^(UIView *innerView, NSInteger index, NSString *title) {
        NSDate *select_data=((UIDatePicker *)innerView).date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:select_data];
        NSLog(@"选择的时间为:%@",strDate);
    }];
}


@end
