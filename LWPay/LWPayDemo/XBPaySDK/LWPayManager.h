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

+ (instancetype)shared;
/***************微信appkey******************/
@property (nonatomic ,strong, readonly) NSString *wxkey;

/****************支付宝******************/
/** 添加各种支付的appkey */
- (void)addAlipayKey:(NSString *)alipayKey wxKey:(NSString *)wxKey paypalProductKey:(NSString *)paypalProductKey paypalReleseKey:(NSString *)paypalReleseKey;

/* 调起支付宝支付 */
- (void)submitAlipayOrder:(NSString *)payOrder;
/** 增加支付宝支付监听 */
- (void)addAliPayObSever;

/** 支付回调block */
@property (nonatomic, copy) void (^alipayHandle)(NSString *code);

/****************微信******************/
//调起微信支付
- (void)submitWxReq:(PayReq *)request;

/* 微信监听 */
- (void)addWxObSever;
/* 接收通知 */
- (void)wxpay:(NSNotification *)noti;
/** 支付回调block */
@property (nonatomic, copy) void (^wxPayHandle)(NSString *code);

@end
