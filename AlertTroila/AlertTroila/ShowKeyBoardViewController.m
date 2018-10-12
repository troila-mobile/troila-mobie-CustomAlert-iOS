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


@end
