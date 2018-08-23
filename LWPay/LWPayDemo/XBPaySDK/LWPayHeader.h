//
//  LWPayHeader.h
//
//
//  Created by weiyuxiang on 2018/8/23.
//  Copyright © 2018年 luwei. All rights reserved.
//

#ifndef LWPayHeader_h
#define LWPayHeader_h

#import "WechatOpenSDK/WechatSDK1.8.2/WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LWPayManager.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Extension.h"

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* LWPayHeader_h */
