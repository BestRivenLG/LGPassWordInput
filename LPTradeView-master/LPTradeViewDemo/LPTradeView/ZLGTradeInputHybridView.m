//
//  ZLGTradeInputHybridView.m
//  LPTradeViewDemo
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#define LPTradeInputViewNumCount 6

// 快速生成颜色
#define LPColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

typedef enum {
    ZLGTradeInputViewButtonTypeWithCancle = 10000,
    ZLGTradeInputViewButtonTypeWithOk = 20000,
}LPTradeInputViewButtonType;

#import "ZLGTradeInputHybridView.h"
//#import "LPTradeKeyboard.h"
#import "NSString+Extension.h"


@interface ZLGTradeInputHybridView()<UITextFieldDelegate>

/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancleBtn;
/** 输入框 */
@property (nonatomic,weak) UITextField *textField;

@property (nonatomic,weak) UITextField *keyTextField;

/** 密码框点击按钮 */
@property (nonatomic,weak) UIButton *fieldBtn;

@end

@implementation ZLGTradeInputHybridView

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 添加子控件 */
        [self setupSubViews];

    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews
{
    /** 确定按钮 */
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:okBtn];
    self.okBtn = okBtn;
    okBtn.enabled = NO;
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_up"] forState:UIControlStateNormal];
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_down"] forState:UIControlStateHighlighted];
    [self.okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn.tag = ZLGTradeInputViewButtonTypeWithOk;
    
    /** 取消按钮 */
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_up"] forState:UIControlStateNormal];
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_down"] forState:UIControlStateHighlighted];
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn.tag = ZLGTradeInputViewButtonTypeWithCancle;
    
    /** 输入框 */
    UITextField *textField = [[UITextField alloc] init];
    self.textField = textField;
    textField.delegate = self;
    textField.backgroundColor = [UIColor whiteColor];
//    textField.font = [UIFont systemFontOfSize:22];
    textField.font = [UIFont systemFontOfSize:LPScreenWidth * 0.053125];
    textField.secureTextEntry = YES;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"交易密码";
    [self addSubview:textField];
    
    UITextField *keyTextField = [[UITextField alloc] init];
    self.keyTextField = keyTextField;
    keyTextField.delegate = self;
    keyTextField.backgroundColor = [UIColor whiteColor];
//    keyTextField.font = [UIFont systemFontOfSize:22];
    keyTextField.font = [UIFont systemFontOfSize:LPScreenWidth * 0.053125];

    keyTextField.secureTextEntry = YES;
    keyTextField.textAlignment = NSTextAlignmentCenter;
    keyTextField.borderStyle = UITextBorderStyleRoundedRect;
    keyTextField.placeholder = @"约定密钥";

    [self addSubview:keyTextField];
    
    
    
}
#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 取消按钮 */
    self.cancleBtn.width = LPScreenWidth * 0.409375;
    self.cancleBtn.height = LPScreenWidth * 0.128125;
    self.cancleBtn.x = LPScreenWidth * 0.05;
    self.cancleBtn.y = self.height - (LPScreenWidth * 0.05 + self.cancleBtn.height);
    
    /** 确定按钮 */
    self.okBtn.y = self.cancleBtn.y;
    self.okBtn.width = self.cancleBtn.width;
    self.okBtn.height = self.cancleBtn.height;
    self.okBtn.x = CGRectGetMaxX(self.cancleBtn.frame) + LPScreenWidth * 0.025;
    
    /** 输入框 */
//    CGFloat x = LPScreenWidth * 0.096875 * 0.5;
//    CGFloat y = LPScreenWidth * 0.40625 * 0.5 + 50;
//    CGFloat w = LPScreenWidth * 0.846875;
//    CGFloat h = LPScreenWidth * 0.121875;
//    self.textField.frame = CGRectMake(x,y,w,h);
//    [self.textField becomeFirstResponder];
    
    CGFloat x = LPScreenWidth * 0.096875 * 0.5;
    CGFloat y = LPScreenWidth * 0.40625 * 0.5 + 25;
    CGFloat w = LPScreenWidth * 0.846875;
    //    CGFloat h = LPScreenWidth * 0.121875;
    CGFloat h = LPScreenWidth * 0.1;
    
    self.textField.frame = CGRectMake(x,y,w,h);
    [self.textField becomeFirstResponder];
    
    CGFloat x1 = LPScreenWidth * 0.096875 * 0.5;
    CGFloat y1 = y + h + 10;
    CGFloat w1 = LPScreenWidth * 0.846875;
    //    CGFloat h = LPScreenWidth * 0.121875;
    CGFloat h1 = LPScreenWidth * 0.1;
    
    self.keyTextField.frame = CGRectMake(x1,y1,w1,h1);
    [self.keyTextField becomeFirstResponder];

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *pwd = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (pwd.length > 5) {
        
        self.okBtn.enabled = YES;
    }else{
        self.okBtn.enabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}


// 按钮点击
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == ZLGTradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputKpHybridView:cancleBtnClick:)]) {
            [self.delegate tradeInputKpHybridView:self cancleBtnClick:btn];
        }
    } else if (btn.tag == ZLGTradeInputViewButtonTypeWithOk) {  // 确定按钮点击
//        if ([self.delegate respondsToSelector:@selector(tradeInputKpHybridView:okBtnClick:)]) {
//            [self.delegate tradeInputKpHybridView:self okBtnClick:self.textField.text];
//        }
        if ([self.delegate respondsToSelector:@selector(tradeInputKpHybridView:okBtnClick:key:)]) {
            [self.delegate tradeInputKpHybridView:self okBtnClick:self.textField.text key:self.keyTextField.text];
        }
        
    }
}


- (void)drawRect:(CGRect)rect
{
    // 画图
    UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    
    [bg drawInRect:rect];
    
    // 画Title
    NSString *title = @"请输入支付密码";
    //LPScreenWidth * 0.053125
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:LPScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (self.width - titleW) * 0.5;
    CGFloat titleY = LPScreenWidth * 0.065;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:LPScreenWidth * 0.053125];
    attr[NSForegroundColorAttributeName] = LPColor(102, 102, 102);
    
    [title drawInRect:titleRect withAttributes:attr];
    
    // 画金额
    NSString *money = [NSString stringWithFormat:@"金额: %@",[self setMoneyComma:self.money isAndDecimal:YES]];
    
    CGSize moneySize = [money sizeWithFont:[UIFont systemFontOfSize:LPScreenWidth * 0.042667] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat moneyW = moneySize.width;
    CGFloat moneyH = moneySize.height;
    CGFloat moneyX = (self.width - moneyW) * 0.5;
    
    CGFloat moneyY = LPScreenWidth * 0.2;
    
    if (LPScreenWidth == 375) {
        
        moneyY = LPScreenWidth * 0.2 - 4;
        
    }else if (LPScreenWidth == 414){
        
        moneyY = LPScreenWidth * 0.2 - 7;
    }
    
    CGRect moneyRect = CGRectMake(moneyX, moneyY, moneyW, moneyH);
    
    NSMutableDictionary *moneyAttr = [NSMutableDictionary dictionary];
    moneyAttr[NSFontAttributeName] = [UIFont systemFontOfSize:LPScreenWidth * 0.042667];
    moneyAttr[NSForegroundColorAttributeName] = LPColor(209, 47, 27);
    
    [money drawInRect:moneyRect withAttributes:moneyAttr];
    
}

// 给钱千位分隔符,是否精确到小数点后2位  带￥
- (NSString *)setMoneyComma:(NSString *)money isAndDecimal:(BOOL)isBool
{
    if([money doubleValue] == 0 || money == nil) return @"¥0.00";
    
    NSRange rang = [money rangeOfString:@"."];
    
    NSString *newStr = @"";
    
    if (rang.length) {
        
        newStr = [money substringWithRange:NSMakeRange(0, rang.location)];
    }else{
        
        newStr = money;
    }
    
    NSUInteger q = newStr.length % 3;
    
    NSString *okStr = [[NSString alloc] init];
    
    for (NSUInteger i = 0; i<newStr.length; i++) {
        
        NSString *tempStr = [newStr substringWithRange:NSMakeRange(i, 1)];
        
        if (((i - q) % 3) == 0 && i != 0 && (i - q) != -1){
            
            okStr = [okStr stringByAppendingString:@","];
        }
        
        okStr = [okStr stringByAppendingString:tempStr];
    }
    
    if (isBool) {
        
        if (rang.length) {
            
            okStr = [NSString stringWithFormat:@"¥%@%@",okStr,[money substringFromIndex:rang.location]];
        }else{
            
            okStr = [NSString stringWithFormat:@"¥%@",okStr];
        }
        
        //        NSLog(@"%@ %@",okStr,[LPTool setMoneyType:okStr]);
        
        return [self setMoneyType:okStr];
        
    }else{
        
        return [NSString stringWithFormat:@"¥%@",okStr];
    }
    
}

- (NSString *)setMoneyType:(NSString *)money
{
    //    money = [NSString stringWithFormat:@"¥%@",money];
    
    NSRange range = [money rangeOfString:@"."];
    
    if (range.location != NSNotFound) {
        
        money = [money stringByAppendingString:@"00"];
        
        return [money substringToIndex:(range.length + range.location + 2)];
        
    }else{
        
        return [money stringByAppendingString:@".00"];
    }
}

@end
