//
//  LPTradeView.m
//  sfb
//
//  Created by lr_lp on 15/8/20.
//  Copyright (c) 2015年 lr_lp. All rights reserved.
//

// 自定义Log
#ifdef DEBUG // 调试状态, 打开LOG功能
#define LPLog(...) NSLog(__VA_ARGS__)
#define LPFunc LPLog(@"%s", __func__);
#else // 发布状态, 关闭LOG功能
#define LPLog(...)
#define LPFunc
#endif

// 设备判断
/**
 iOS设备宽高比
 4\4s {320, 480}  5s\5c {320, 568}  6 {375, 667}  6+ {414, 736}
 0.66             0.56              0.56          0.56
 */
#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define ios8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define ios6 ([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
#define ios5 ([[UIDevice currentDevice].systemVersion doubleValue] < 6.0)
#define iphone5  ([UIScreen mainScreen].bounds.size.height == 568)
#define iphone6  ([UIScreen mainScreen].bounds.size.height == 667)
#define iphone6Plus  ([UIScreen mainScreen].bounds.size.height == 736)
#define iphone4  ([UIScreen mainScreen].bounds.size.height == 480)
#define ipadMini2  ([UIScreen mainScreen].bounds.size.height == 1024)

#import "LPTradeView.h"
#import "LPTradeKeyboard.h"
#import "LPTradeInputNumberView.h"
#import "LPTradeInputHybridView.h"
#import "UIAlertView+Quick.h"

#import "ZLGTradeInputHybridView.h"


@interface LPTradeView () <UIAlertViewDelegate,LPTradeInputNumberViewDelegate,LPTradeInputHybridViewDelegate,ZLGTradeInputHybridViewDelegate>
/** 键盘 */
@property (nonatomic, weak) LPTradeKeyboard *keyboard;
/** 输入框 数字键盘*/
@property (nonatomic, weak) LPTradeInputNumberView *inputView;
/** 输入框 系统键盘*/
@property (nonatomic,weak) LPTradeInputHybridView *inputHybridView;

@property (nonatomic,weak) ZLGTradeInputHybridView *inputPkHybridView;
/** 蒙板 */
@property (nonatomic, weak) UIButton *cover;
/** 响应者 */
@property (nonatomic, weak) UITextField *responsder;
/** 键盘状态 */
@property (nonatomic, assign, getter=isKeyboardShow) BOOL keyboardShow;
/** 返回密码 */
@property (nonatomic, copy) NSString *passWord;
/** 金额 */
@property (nonatomic,copy) NSString *money;

/** 完成的回调block */
@property (nonatomic, copy) void (^finish) (NSString *passWord);

@property (nonatomic, copy) void (^end)(NSString *passWord,NSString *key);
@end

@implementation LPTradeView

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:LPScreenBounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        /** 蒙板 */
        [self setupCover];
        /** 响应者 */
        [self setupResponsder];
        
        [self addNSNotificationCenter];
    }
    return self;
}

/** 蒙板 */
- (void)setupCover
{
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor blackColor]];
    self.cover.alpha = 0.4;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
}

/** 输入框 */
- (void)setupInputNumberView
{
    LPTradeInputNumberView *inputView = [[LPTradeInputNumberView alloc] init];
    inputView.delegate = self;
    inputView.money = self.money;
    [self addSubview:inputView];
    self.inputView = inputView;
    
    [self setupkeyboard];
}

/** 输入框 */
- (void)setupInputHybridView
{
    
    LPTradeInputHybridView *inputHybridView = [[LPTradeInputHybridView alloc] init];
    self.inputHybridView = inputHybridView;
    inputHybridView.delegate = self;
    inputHybridView.money = self.money;
    self.inputHybridView.height = LPScreenWidth * 0.71875;
    self.inputHybridView.y = (self.height - LPScreenWidth * 0.71875) * 0.5;
    self.inputHybridView.width = LPScreenWidth * 0.94375;
    self.inputHybridView.x = (LPScreenWidth - LPScreenWidth * 0.94375) * 0.5;
    [self addSubview:inputHybridView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    // 动画
    [self showHybridKeyboard];
}

/** 密码 约定密钥 输入框 */
- (void)setupPassWordAndKeyInputHybridView
{
    ZLGTradeInputHybridView *inputPkHybridView = [[ZLGTradeInputHybridView alloc] init];
    self.inputPkHybridView = inputPkHybridView;
    inputPkHybridView.delegate = self;
    inputPkHybridView.money = self.money;
    self.inputPkHybridView.height = LPScreenWidth * 0.71875;
    self.inputPkHybridView.y = (self.height - LPScreenWidth * 0.71875) * 0.5;
    self.inputPkHybridView.width = LPScreenWidth * 0.94375;
    self.inputPkHybridView.x = (LPScreenWidth - LPScreenWidth * 0.94375) * 0.5;
    [self addSubview:inputPkHybridView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

//
//    // 动画
////    [self showHybridKeyboard];
//    
    [self showKpHybridKeyboard];
    
    
//    LPTradeInputHybridView *inputHybridView = [[LPTradeInputHybridView alloc] init];
//    self.inputHybridView = inputHybridView;
//    inputHybridView.delegate = self;
//    inputHybridView.money = self.money;
//    self.inputHybridView.height = LPScreenWidth * 0.71875;
//    self.inputHybridView.y = (self.height - LPScreenWidth * 0.71875) * 0.5;
//    self.inputHybridView.width = LPScreenWidth * 0.94375;
//    self.inputHybridView.x = (LPScreenWidth - LPScreenWidth * 0.94375) * 0.5;
//    [self addSubview:inputHybridView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    // 动画
//    [self showHybridKeyboard];
    
    
}


- (void)tradeInputNumberView:(LPTradeInputNumberView *)tradeInputView inputBtnClick:(UIButton *)inputBtn
{
    if(!self.keyboardShow)
    {
        [self showKeyboard];
    }
}


/** 响应者 */
- (void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc] init];
    [self addSubview:responsder];
    self.responsder = responsder;
}

/** 键盘 */
- (void)setupkeyboard
{
    LPTradeKeyboard *keyboard = [[LPTradeKeyboard alloc] init];
    [self addSubview:keyboard];
    self.keyboard = keyboard;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 蒙板 */
    self.cover.frame = self.bounds;
}

#pragma mark - Private

- (void)coverClick
{
    if (self.isKeyboardShow) {  // 键盘是弹出状态
        [self hidenKeyboard:nil];
    } else {  // 键盘是隐藏状态
        [self showKeyboard];
    }
}

/** 键盘弹出 */
- (void)showKeyboard
{
    self.keyboardShow = YES;
    
    CGFloat marginTop;
    if (iphone4) {
        marginTop = 42;
    } else if (iphone5) {
        marginTop = 100;
    } else if (iphone6) {
        marginTop = 120;
    } else {
        marginTop = 140;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -self.keyboard.height);
        self.inputView.transform = CGAffineTransformMakeTranslation(0, marginTop - self.inputView.y);
        
    } completion:^(BOOL finished) {
        
    }];
}

/** 输入框弹出 动画*/
- (void)showHybridKeyboard
{
    CGFloat marginTop;
    if (iphone4) {
        marginTop = 42;
    } else if (iphone5) {
        marginTop = 100;
    } else if (iphone6) {
        marginTop = 120;
    } else {
        marginTop = 140;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputHybridView.transform = CGAffineTransformMakeTranslation(0, marginTop - self.inputHybridView.y );
        
    } completion:^(BOOL finished) {
        
    }];
}

/** 输入框弹出 动画*/
- (void)showKpHybridKeyboard
{
    CGFloat marginTop;
    if (iphone4) {
        marginTop = 42;
    } else if (iphone5) {
        marginTop = 100;
    } else if (iphone6) {
        marginTop = 120;
    } else {
        marginTop = 140;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputPkHybridView.transform = CGAffineTransformMakeTranslation(0, marginTop-self.inputPkHybridView.y );
        
    } completion:^(BOOL finished) {
        
    }];
}

/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion
{
    self.keyboardShow = NO;
    
    if (!completion) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.keyboard.transform = CGAffineTransformIdentity;
            self.inputView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //        self.keyboard.transform = CGAffineTransformIdentity;   // 输入框结束动画
            //        self.inputView.transform = CGAffineTransformIdentity;  // 键盘结束动画
            
            self.inputView.alpha = 0;
            self.keyboard.alpha = 0;
            
            self.cover.alpha = 0;
            
            
        } completion:completion];
    }
}

- (void)tradeInputNumberView:(LPTradeInputNumberView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn
{
    [self cancle];
}

- (void)tradeInputNumberView:(LPTradeInputNumberView *)tradeInputView okBtnClick:(NSString *)password
{
    [self OK:password];
}

- (void)tradeInputHybridView:(LPTradeInputHybridView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn
{
    [self cancle];
}

- (void)tradeInputHybridView:(LPTradeInputNumberView *)tradeInputView okBtnClick:(NSString *)password
{
    [self OK:password];
}

/** 确定按钮点击 */
- (void)tradeInputKpHybridView:(ZLGTradeInputHybridView *)tradeInputView okBtnClick:(NSString *)password key:(NSString *)key
{
    [self OKforPassword:password andKey:key];
}


/** 取消按钮点击 */
- (void)tradeInputKpHybridView:(ZLGTradeInputHybridView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn
{
    [self cancle];
//    [self.inputPkHybridView removeFromSuperview];
//    [self removeFromSuperview];
}


/** 输入框的取消按钮点击 */
- (void)cancle
{
    [self removeFromSuperview];
}

/** 输入框的确定按钮点击 */
- (void)OK:(NSString *)password
{
    // 回调block\传递密码
    if (self.finish) {
        self.finish(password);
    }
    
    // 移除自己
    [self removeFromSuperview];
    
}

/** 输入框的确定按钮点击 */
- (void)OKforPassword:(NSString *)password andKey:(NSString *)key
{
    // 回调block\传递密码
    if (self.end) {
        self.end(password,key);
    }
    
//    [self.inputPkHybridView removeFromSuperview];
    // 移除自己
    [self removeFromSuperview];
    
}

#pragma mark - Public Interface

/** 快速创建6位数字的密码 带Block回调密码*/
+ (instancetype)tradeViewNumberKeyboardWithMoney:(NSString *)money password:(void (^) (NSString *password))password
{
    LPTradeView *view = [[LPTradeView alloc] init];
    
    view.finish = password;
    
    view.money = money;
    
    [view show];
    
    return view;
}

/** 快速创建多位的混合密码 带Block回调密码*/
+ (instancetype)tradeViewHybridKeyboardWithMoney:(NSString *)money password:(void (^) (NSString *password))password
{
    LPTradeView *view = [[LPTradeView alloc] init];
    
    view.finish = password;
    
    view.money = money;
    
    [view showHybrid];
    
    return view; 
}

/** 快速创建多位的混合密码 带Block回调密码 和约定密钥 带系统组合键盘 不限制输入 */
+ (instancetype)tradeViewKpHybridKeyboardWithMoney:(NSString *)money passwordAndKey:(void (^) (NSString *password,NSString *key))password
{
    LPTradeView *view = [[LPTradeView alloc] init];
    
    view.end = password;

    view.money = money;
    
    [view showKpHybrid];
    
    return view;
}



/** 弹出 有自定义键盘 */
- (void)show
{
    [self setupInputNumberView];
    [self showInView:[UIApplication sharedApplication].keyWindow];
    
}

//* 弹出 是系统键盘
- (void)showHybrid
{
    [self setupInputHybridView];
    
}

/** 弹出 是系统键盘*/
- (void)showKpHybrid
{
    [self setupPassWordAndKeyInputHybridView];
    
}


- (void)showInView:(UIView *)view
{
    // 浮现
    [view addSubview:self];
    
    /** 输入框起始frame */
    self.inputView.height = LPScreenWidth * 0.71875;
    self.inputView.y = (self.height - self.inputView.height) * 0.5;
    self.inputView.width = LPScreenWidth * 0.94375;
    self.inputView.x = (LPScreenWidth - self.inputView.width) * 0.5;
    
    /** 键盘起始frame */
    self.keyboard.x = 0;
    self.keyboard.y = LPScreenHeight;
    self.keyboard.width = LPScreenWidth;
    self.keyboard.height = LPScreenWidth * 0.65;
    
    /** 弹出键盘 */
    [self showKeyboard];
}

- (void)addNSNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(execute:)
                                                 name:LPTradeKeyboardOkButtonClick
                                               object:nil];
}
- (void)execute:(NSNotification *)notification {
    
    [self coverClick];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end