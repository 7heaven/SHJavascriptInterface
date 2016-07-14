//
//  InterfaceProvider.h
//  JavascriptInterface
//
//  Created by 7heaven on 16/7/14.
//  Copyright © 2016年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InterfaceProvider <NSObject>

/**
 * @brief 提供原生方法和JS调用的方法列表，格式为@{
 
                                            \@"{JS调用方法名}" : [NSValue valueWithPointer:\@selector({对应的原生方法})]
 
                                           }
 
   js方法的参数和原生方法的参数按顺序一一对应
 *
 * @return 返回包含对应JS方法名和原生Selector的字典
 */
- (NSDictionary<NSString *, NSValue *> *) javascriptInterfaces;

@end
