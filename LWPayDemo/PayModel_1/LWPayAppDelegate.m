//
//  AppDelegate+LWPayAppDelegate.m
//
//
//  Created by weiyuxiang on 2018/8/22.
//  Copyright © 2018年 luwei. All rights reserved.
//

#import "LWPayAppDelegate.h"
#import "MRAppDelegateComponents.h"

#import "LWPayHeader.h"

@interface LWPayAppDelegate () <UIApplicationDelegate, MRApplicationDelegateInjectionProtocol,WXApiDelegate>

@end
@implementation LWPayAppDelegate
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SEL sel = @selector(application:didFinishLaunchingWithOptions:);
    if (__MRSuperImplatationCurrentCMD__(sel)) {
        MRPrepareSendSuper(BOOL, id, id);
        MRSendSuperSelector(sel, application, launchOptions);
    }
    NSLog(@"LWPayAppDelegate handle");
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    SEL sel = @selector(application:openURL:options:);
    if (__MRSuperImplatationCurrentCMD__(sel)) {
        MRPrepareSendSuper(BOOL,id,id,id);
        MRSendSuperSelector(sel,app,url,options);
    }
    
    
    if([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay",[LWPayManager shared].wxkey]].location == 0)//微信
        
        return [WXApi handleOpenURL:url delegate:self];
    
    else if([url.host isEqualToString:@"safepay"]){//支付宝
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AlipayNotification_LWPay" object:resultDic[@"resultStatus"] userInfo:nil]];
            
        }];
        return YES;
    }
    
    else
        
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    SEL sel = @selector(application:openURL:options:);
    if (__MRSuperImplatationCurrentCMD__(sel)) {
        MRPrepareSendSuper(BOOL,id,id);
        MRSendSuperSelector(sel,application,url);
    }
    
    if([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay",[LWPayManager shared].wxkey]].location == 0)
        
        return [WXApi handleOpenURL:url delegate:self];
    
    else if([url.host isEqualToString:@"safepay"]){//支付宝
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AlipayNotification" object:resultDic[@"resultStatus"] userInfo:nil]];
        }];
        return YES;
    }
    
    
    else
        
        return YES;
}

/** 与微信支付的交互 */
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                NSLog(@"支付成功，retcode=%d",resp.errCode);
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"WxNotification_LWPay" object:@"1" userInfo:nil]];
                break;
            default:
                //支付失败
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"WxNotification_LWPay" object:@"0" userInfo:nil]];
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                
                break;
        }
    }
}


@end
