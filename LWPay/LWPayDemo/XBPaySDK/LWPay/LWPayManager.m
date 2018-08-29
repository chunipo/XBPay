//
//  AppDelegate+LWPayAppDelegate.m
//
//
//  Created by weiyuxiang on 2018/8/22.
//  Copyright © 2018年 luwei. All rights reserved.
//

#import "LWPayManager.h"
@interface LWPayManager ()<PayPalPaymentDelegate>

{
    NSString *_alipayKey;
    NSString *_wxKey;
    NSString *_paypalProductKey;
    NSString *_paypalSandboxKey;
}

/** 增加支付宝支付监听 */
- (void)addAliPayObSever;
/* 微信监听 */
- (void)addWxObSever;

/***paypal 支付对象***/
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
/**PayPal预支付订单ID*/
@property (nonatomic, strong)NSString *paypalOrderId;
/**PayPal支付成功返回的订单ID*/
@property (nonatomic, strong)NSString *paymentId;

@property (nonatomic, strong) UIViewController *viewController;

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
- (void)addAlipayKey:(NSString *)alipayKey wxKey:(NSString *)wxKey paypalProductKey:(NSString *)paypalProductKey paypalSandboxKey:(NSString *)paypalSandboxKey{
    
    _alipayKey = alipayKey;
    _wxKey = wxKey;
    _paypalProductKey = paypalProductKey;
    _paypalSandboxKey = paypalSandboxKey;
    
    //支付宝
    if (_alipayKey.length>0){
        [self addAliPayObSever];
    }
    
    //注册微信
    if (_wxKey.length>0) {
        //加 enableMTA 防止出现 [__NSArrayM enqueue:]: unrecognized selector sent to instance 的错误
        [WXApi registerApp:_wxKey enableMTA:NO];
        [self addWxObSever];
    }
    
    //注册paypal
    if(_paypalSandboxKey.length>0 && _paypalProductKey.length>0){
        
        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : paypalProductKey,PayPalEnvironmentSandbox : paypalSandboxKey}];
        
        
    }
    
    
}
/*******************支付宝***************************/
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

//添加监听
- (void)addAliPayObSever{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipay:) name:@"AlipayNotification_LWPay" object:nil];
    //判断是否有appkey
    if (_alipayKey.length==0) {
        [MBProgressHUD showError:@"你还没有添加 alipayKey~"];
    }
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

//接收
- (void)wxpay:(NSNotification *)noti{
    NSString *code = noti.object;
    if (_wxPayHandle) {
        _wxPayHandle(code);
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

/*******************paypal***************************/
//提交订单,并调起paypal
- (void)submitPaypal:(PayPalPayment *)payment Sanbox:(BOOL)isSanbox{
    
    self.payPalConfiguration = [[PayPalConfiguration alloc] init];
    //是否使用信用卡
    self.payPalConfiguration.acceptCreditCards = NO;
     self.payPalConfiguration.merchantName = @"luwei公司";
    self.payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    //配置语言环境
    self.payPalConfiguration.languageOrLocale = [NSLocale preferredLanguages][0];
    
    if(isSanbox == YES){
        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    }{
        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfiguration delegate:self];
    [[self getCurrentVC] presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - get
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    return  (UIViewController *)nextResponder;
}

#pragma mark - PayPalPaymentDelegate

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    //付款成功
    _paypalHandle(completedPayment);
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    //付款已取消
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy load
- (NSString *)wxkey{
    return _wxKey;
}


@end
