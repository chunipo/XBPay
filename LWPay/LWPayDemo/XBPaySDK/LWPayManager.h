//
//  LWPayManager.h
//  QianTuMei
//
//  Created by weiyuxiang on 2018/8/22.
//  Copyright © 2018年 luwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWPayHeader.h"

@interface LWPayManager : NSObject
/***************微信appkey，只读******************/
@property (nonatomic ,strong, readonly) NSString *wxkey;
/** 初始化 */
+ (instancetype)shared;
/** 添加各种支付的appkey */
- (void)addAlipayKey:(NSString *)alipayKey wxKey:(NSString *)wxKey paypalProductKey:(NSString *)paypalProductKey paypalSandboxKey:(NSString *)paypalSandboxKey;

/****************支付宝******************/
/* 调起支付宝支付 */
- (void)submitAlipayOrder:(NSString *)payOrder;
/** 支付回调block */
@property (nonatomic, copy) void (^alipayHandle)(NSString *code);


/****************微信******************/
//调起微信支付
- (void)submitWxReq:(PayReq *)request;
/** 支付回调block */
@property (nonatomic, copy) void (^wxPayHandle)(NSString *code);

/****************paypal******************/
/* 提交订单,并调起paypal */
- (void)submitPaypal:(PayPalPayment *)payment Sanbox:(BOOL)isSanbox;

/** 支付回调block */
@property (nonatomic, copy) void (^paypalHandle)(PayPalPayment *payment);

@end
