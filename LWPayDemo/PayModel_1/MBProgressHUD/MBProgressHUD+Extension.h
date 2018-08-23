//
//  MBProgressHUD+Extension.h
//  QiongLiao
//
//  Created by appleKaiFa on 15/9/17.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)
/***成功提示*/
+ (void)showSuccess:(NSString *)success;
/***错误提示*/
+ (void)showError:(NSString *)error;
/***自定义按钮提示*/
+ (void)showMessage:(NSString *)message icon:(NSString *)icon;
+ (void)showSuccessWithTop:(NSString *)success;
/***消息提示*/
+ (void)showMessage:(NSString *)message;
/** 显示进度指示器 */
+ (void)showActivityIndicator;
/** 显示进度指示器  带文字*/
+ (void)showActivityIndicatorWithMessage:(NSString *)message;
/** 隐藏进度指示器 */
+ (void)hideActivityIndicator;
/** 显示加载动画，控制可否点击背景 */
+ (void)showActivityIndicatorWithUserInteractionEnabled:(BOOL)enabled;

@end
