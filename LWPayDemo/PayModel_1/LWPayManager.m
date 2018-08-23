//
//  AppDelegate+LWPayAppDelegate.m
//
//
//  Created by weiyuxiang on 2018/8/22.
//  Copyright © 2018年 luwei. All rights reserved.
//

#import "LWPayManager.h"


@interface LWPayManager ()

{
    NSString *_alipayKey;
    NSString *_wxKey;
    NSString *_paypalProductKey;
    NSString *_paypalReleseKey;
}

@end

@implementation LWPayManager

+ (instancetype)shared{
    static LWPayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LWPayManager alloc] init];
    });
    return manager;
}

/** 添加各种支付的appkey */
- (void)addAlipayKey:(NSString *)alipayKey wxKey:(NSString *)wxKey paypalProductKey:(NSString *)paypalProductKey paypalReleseKey:(NSString *)paypalReleseKey{
    
    _alipayKey = alipayKey;
    _wxKey = wxKey;
    _paypalProductKey = paypalProductKey;
    _paypalReleseKey = paypalReleseKey;
    
    //注册微信
    if (_wxKey.length>0) {
        [WXApi registerApp:_wxKey];
    }
    
    
}
/*******************支付宝***************************/
//添加监听
- (void)addAliPayObSever{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipay:) name:@"AlipayNotification_LWPay" object:nil];
    //判断是否有appkey
    if (_alipayKey.length==0) {
        [MBProgressHUD showError:@"你还没有添加 alipayKey~"];
    }
}
//接收
- (void)alipay:(NSNotification *)noti{
    NSString *code = noti.object;
    if (_alipayHandle) {
        _alipayHandle(code);
    }
    
}

//调起支付宝支付
- (void)submitAlipayOrder:(NSString *)payOrder{
    
    [[AlipaySDK defaultService] payOrder:payOrder fromScheme:_alipayKey callback:^(NSDictionary *resultDic) {
        
    }];
    
}

/*******************微信***************************/
//调起微信支付
- (void)submitWxReq:(PayReq *)request{
    
    if ([WXApi isWXAppInstalled]) {
        
        [WXApi sendReq:request];
    }else{
        /**未安装微信*/
        [MBProgressHUD showError:@"您未安装微信"];
    }
    
}
//添加监听
- (void)addWxObSever{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpay:) name:@"WxNotification_LWPay" object:nil];
    //判断是否有appkey
    if (_wxKey.length==0) {
        [MBProgressHUD showError:@"你还没有添加 wxKey~"];
    }
}

//接收
- (void)wxpay:(NSNotification *)noti{
    NSString *code = noti.object;
    if (_wxPayHandle) {
        _wxPayHandle(code);
    }
    
}

- (NSString *)wxkey{
    return _wxKey;
}

@end
