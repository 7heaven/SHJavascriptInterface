//
//  UIWebView+JavascriptInterface.h
//  JavascriptInterface
//
//  Created by 7heaven on 16/7/14.
//  Copyright © 2016年 7heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceProvider.h"
#import "JavascriptInterface.h"
#import "IWebView.h"

@interface UIWebView (JavascriptInterface) <UIWebViewDelegate, IWebView>

/**
 * @brief 添加javascriptInterface
 *
 * @param target 提供js方法调用的对象
 *
 * @param name javascriptInterface名称
 */
- (void) addJavascriptInterface:(id<InterfaceProvider>) target forName:(NSString *) name;

@end
