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
    
    NSString *url = request.URL.absoluteString;
    
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

- (NSDictionary<NSString *, NSValue *> *) javascriptInterfaces{
    return @{
             @"callNative" : [NSValue valueWithPointer:@selector(nativeCaller:)]
             };
}

@end
