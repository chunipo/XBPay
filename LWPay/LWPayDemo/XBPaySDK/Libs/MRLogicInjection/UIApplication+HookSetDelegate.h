//
//  UIApplication+HookSetDelegate.h
//  
//
//  Created by weiyuxiang on 2018/8/23.
//

#import <UIKit/UIKit.h>


/**
 Swzzing了UIApplication设置delegate的方法，当设置delegate的时候将会对delegate进行逻辑扩展。扩展的逻辑来自所有实现了MRApplicationDelegateInjectionProtocol的类。
 */
@interface UIApplication (HookSetDelegate)
@end
