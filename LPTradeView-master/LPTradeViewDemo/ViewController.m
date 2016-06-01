//
//  ViewController.m
//  LPTradeViewDemo
//
//  Created by 黎培 on 15/11/26.
//  Copyright © 2015年 LP. All rights reserved.
//

#import "ViewController.h"
#import "LPTradeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 纯数字密码
- (IBAction)btn1:(id)sender {
    
    [LPTradeView tradeViewNumberKeyboardWithMoney:@"88.25" password:^(NSString *password) {
        
        NSLog(@"密码是:%@",password);
        
    }];
    
    
}


// 混合密码
- (IBAction)btn2:(id)sender {
    
    [LPTradeView tradeViewHybridKeyboardWithMoney:@"88.28" password:^(NSString *password) {
        
        NSLog(@"密码是:%@",password);
        
    }];
}
- (IBAction)btn3:(id)sender {
    
    [LPTradeView tradeViewKpHybridKeyboardWithMoney:@"88.28" passwordAndKey:^(NSString *password, NSString *key) {
        NSLog(@"密码是:%@",password);
        NSLog(@"约定密钥是:%@",key);
    }];

}

@end
