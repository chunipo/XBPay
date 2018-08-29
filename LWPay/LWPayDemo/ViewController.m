//
//  ViewController.m
//  LWPayDemo
//
//  Created by weiyuxiang on 2018/8/23.
//  Copyright © 2018年 weiyuxiang. All rights reserved.
//

#import "ViewController.h"
#import "LWPayManager.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //调起支付宝
    //[self alipay];
    //调起微信
    //[self wxpay];
//    //调起paypal
//    [self paypal];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 200, 200)];
    [btn setTitle:@"111" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor greenColor];
     [self.view addSubview:btn];
}
- (void)click{
    //调起paypal
    [self paypal];
}

- (void)alipay{
    LWPayManager *manager = [LWPayManager shared];
    
    //保存订单id，支付成功返回给服务器
    //_manager.out_order_no = model.out_order_no;
    PayReq *request = [[PayReq alloc] init];
    /** 商家向财付通申请的商家id */
    request.partnerId = @"1491420092";
    /** 预支付订单 */
    request.prepayId= @"wx291119543390286ff61c22b62255506586";
    /** 商家根据财付通文档填写的数据和签名 */
    request.package = @"Sign=WXPay";
    /** 随机串，防重发 */
    request.nonceStr= @"wIKxV9TLsb4ZTKaj";
    /** 时间戳，防重发 */
    request.timeStamp = [@"1535512794" intValue];
    /** 商家根据微信开放平台文档对数据做的签名 */
    request.sign = @"BE7DF09E38415567327E0F126964B9FF";
    
    
    [manager submitWxReq:request];
    
    manager.wxPayHandle = ^(NSString *code) {
        NSLog(@"嘿嘿嘿%@",code);
    };
}

- (void)wxpay{
    LWPayManager *manager = [LWPayManager shared];
    [manager submitAlipayOrder:@"alipay_sdk=alipay-sdk-java-dynamicVersionNo&app_id=2017102809577086&biz_content=%7B%22goods_type%22%3A%221%22%2C%22out_trade_no%22%3A%221006151650226261%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%E6%94%AF%E4%BB%98%E5%AE%9D%E6%94%AF%E4%BB%98%22%2C%22timeout_express%22%3A%2290m%22%2C%22total_amount%22%3A%2240.8%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fqiantumei-web.qtm6.com%2Fapi%2Fmodule%2Fpay%2Falipay%2Fnotify&sign=Fcxrj77F9iOsMAWdQ8rCkAUN%2BCYZ72II8clh%2FkS2v1Y2a%2Fq6GlJ3roCvp2Nxd4Shb6QLRoOx6qILCJG%2BWbohk9aPtdE2oHoE4LZv%2Fzr2%2BcNDQFh3BOgX4ZPBwaTXGjRjPgkUXJuaccSyF2RnhlEds67serm5Ul2DA9ZT1lz1BHhDjhc1XQV6a19%2BohETnfvaxlmnVVQufmLy18ATmrnj55tLH7lb4tmHnsgBFrwFgSef5zRCVOPnHyXm6TzoKRUF4YaW9uDorrx3L%2FlCwM1KhgaBPOYJj0PnSbCouJjtJt7aKj9PyBQkIFQkScCmXLpmQuThFPBp9%2BoDBTALMSZUaA%3D%3D&sign_type=RSA2&timestamp=2018-08-29+10%3A51%3A37&version=1.0"];
    
    manager.alipayHandle = ^(NSString *code) {
        NSLog(@"嘿嘿嘿%@",code);
    };
}

- (void)paypal{
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"0.01"];//金额
    payment.currencyCode = @"USD";//货币类型
    payment.shortDescription = @"Awesome saws";
    payment.intent = PayPalPaymentIntentSale;
    //传入订单ID  后台生成
    
    PayPalItem *palltem = [PayPalItem itemWithName:@"12" withQuantity:1 withPrice:payment.amount withCurrency:@"USD" withSku:@"12"];
    NSArray *array = [NSArray arrayWithObjects:palltem, nil];
    payment.items = array;
    payment.shippingAddress = nil;//收货地址
    //检查付款是否可行
    if (!payment.processable) {
        //不能发起支付
    }

    LWPayManager *manager = [LWPayManager shared];
    [manager submitPaypal:payment Sanbox:YES];
    
    manager.paypalHandle = ^(PayPalPayment *payment) {
        NSLog(@"paypal 支付完成");
    };
}






@end
