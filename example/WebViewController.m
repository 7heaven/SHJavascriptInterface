//
//  WebViewController.m
//  WebViewInjectTest
//
//  Created by 7heaven on 16/7/22.
//  Copyright © 2016年 7heaven. All rights reserved.
//

#import "WebViewController.h"
#import "UIWebView+JavascriptInterface.h"
#import "InterfaceProvider.h"

@interface WebViewController () <InterfaceProvider, UIWebViewDelegate>

@end

@implementation WebViewController{
    UIWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height)];
    _webView.delegate = self;
    
    //给webView增加javascriptInterface，javascriptInterface提供JS需要调用的对应方法
    //这边的javascriptInterface名称会在JS里面生成相同名称的对象,在JS里面调用原生的时候就可以写成"nativeCommon.xxxx()"
    //注意这边javascriptInterface提供的方法都必须是以javascriptInterface为target能调用到的方法
    [_webView addJavascriptInterface:self forName:@"nativeCommon"];
    
    [self.view addSubview:_webView];
    
    [_webView loadHTMLString:@"<html><head>"
     "<script type=\"text/javascript\">"
     "function call(input){"
     "    var result = nativeCommon.callNative(input);"
     "    if(result){"
     "        alert(result);"
     "    }else{"
     "        alert('no return value');"
     "    }"
     "}"
     "</script>"
     "</head><body><input type=\"button\" value=\"click\" onclick=\"call('js-call');\"/></body></html>" baseURL:[NSURL URLWithString:@"http://www.zhihu.com"]];
    
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"webView original:%s", __FUNCTION__);
    
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"webView:%@, error:%@", webView, error);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *) nativeCaller:(NSString *) input{
    return [input stringByAppendingString:@"-modified-by-native"];
}

//所有需要提供给JS调用的方法都在这边定义，前面的名称为js直接调用的方法名，后面是对应的原生的selector
//例如webView addJavascriptInterface方法用的名称是nativeCommon,那在JS里面就可以使用"nativeCommon.callNative();"来调用对应的原生的方法nativeCaller:
- (NSDictionary<NSString *, NSValue *> *) javascriptInterfaces{
    return @{
             @"callNative" : [NSValue valueWithPointer:@selector(nativeCaller:)]
             };
}

@end
