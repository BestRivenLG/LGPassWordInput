//
//  ZLGTradeInputHybridView.h
//  LPTradeViewDemo
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@class ZLGTradeInputHybridView;

@protocol ZLGTradeInputHybridViewDelegate <NSObject>

@optional
/** 确定按钮点击 */
//- (void)tradeInputKpHybridView:(ZLGTradeInputHybridView *)tradeInputView okBtnClick:(NSString *)password;
- (void)tradeInputKpHybridView:(ZLGTradeInputHybridView *)tradeInputView okBtnClick:(NSString *)password key:(NSString *)key;


/** 取消按钮点击 */
- (void)tradeInputKpHybridView:(ZLGTradeInputHybridView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn;

@end
@interface ZLGTradeInputHybridView : UIView
// 金额
@property (nonatomic,copy) NSString *money;

@property (nonatomic, weak) id<ZLGTradeInputHybridViewDelegate> delegate;
@end
