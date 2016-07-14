//
//  IWebView.h
//  JavascriptInterface
//
//  Created by 7heaven on 16/7/14.
//  Copyright © 2016年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IWebView <NSObject>

- (NSString *) evaluatingJavascript:(NSString *) script;

@end
