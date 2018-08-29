//
//  MBProgressHUD+Extension.m
//  QiongLiao
//
//  Created by appleKaiFa on 15/9/17.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import "LWPayHeader.h"

@interface MBProgressHUD ()

@end

@implementation MBProgressHUD (Extension)

static MBProgressHUD *HUD;


#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon
{
    UIView  *view = ![self getCurrentVC].view? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentVC].view;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.color = UIColorFromRGB(0x3B3E40);
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

#pragma mark 显示信息 图层最上方
+ (void)showTopWithView:(NSString *)text icon:(NSString *)icon
{
    UIView  *view = (UIView*)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.color = UIColorFromRGB(0x3B3E40);
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

#pragma mark 显示错误、成功信息
+ (void)showError:(NSString *)error{
    [self show:error icon:[NSString stringWithFormat:@"MBProgressHUD.bundle/error.png"]];
}

+ (void)showSuccess:(NSString *)success
{
    [self show:success icon:[NSString stringWithFormat:@"MBProgressHUD.bundle/success.png"]];
}
/** 返回上一级还存在 */
+ (void)showSuccessWithTop:(NSString *)success
{
    [self showTopWithView:success icon:[NSString stringWithFormat:@"MBProgressHUD.bundle/success.png"]];
}

+ (void)showMessage:(NSString *)message icon:(NSString *)icon
{
    [self show:message icon:icon];
}

+ (void)showMessage:(NSString *)message{
    
    UIView  *view = ![self getCurrentVC].view? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentVC].view;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
}

+ (void)showActivityIndicator {
    [self showActivityIndicatorWithMessage:nil];
}

+ (void)showActivityIndicatorWithUserInteractionEnabled:(BOOL)enabled
{
    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = enabled;
    [HUD show:YES];
}

+(void)showActivityIndicatorWithMessage:(NSString *)message
{
    UIView  *view = ![self getCurrentVC].view? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentVC].view;
    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [view addSubview:HUD];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = NO;
    if (message) {
         HUD.detailsLabelText=message;
    }
   
    [HUD show:YES];
}

+ (void)hideActivityIndicator {
    [HUD hide:YES];
}


+ (UIViewController*)getCurrentVC
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

}



+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    } else if (rootViewController.presentedViewController) {
        
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        
        return [self topViewControllerWithRootViewController:presentedViewController];
        
    } else {
        
        return rootViewController;
        
    }
}

@end
