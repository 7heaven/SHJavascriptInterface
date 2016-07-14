//
//  JavascriptInterface.h
//  JavascriptInterface
//
//  Created by 7heaven on 16/7/14.
//  Copyright © 2016年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebView.h"
#import "InterfaceProvider.h"

@interface JavascriptInterface : NSObject

@property (weak, nonatomic) id<IWebView> webView;
@property (weak, nonatomic) id<InterfaceProvider> interfaceProvider;

/**
 * @brief javascriptinterface名称，JS端调用的时候格式为{interfaceName}.{方法名}\n 例如:当前interfaceName为"nativeCommon", 方法为"callNative", 则JS的调用方式为nativeCommon.callNative();
 *
 */
@property (strong, nonatomic) NSString *interfaceName;

/**
 * @brief 注入JS方法，对应的原生方法和原生方法的JS端名称由InterfaceProvider提供
 *
 */
- (void) injectJSMethod;

/**
 * @brief 检查当前的URL是否为注入的JS方法的实际调用形式
 *
 * @param url 需要验证的url
 *
 * @return YES表示当前URL的格式符合JS方法对原生的实际调用
 */
- (BOOL) checkUpcomingRequestURL:(NSURL *) url;

/**
 * @brief 处理当前的URL并执行对应的原生方法
 *
 * @param url 传入的url
 *
 * @return YES表示当前url被作为JS对原生的调用处理，NO表示当前url格式不符合JS对原生调用或者未找到原生对应的方法
 */
- (BOOL) handleInjectedJSMethod:(NSURL *) url;

@end
