//
//  StringUtil.m
//  JavascriptInterface
//
//  Created by 7heaven on 16/7/14.
//  Copyright © 2016年 7heaven. All rights reserved.
//

#import "StringUtil.h"
#include <map>
#include <string>

NSArray * allRangesOfString(NSString *substring, NSString *string){
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    NSRange searchRange = NSMakeRange(0,string.length);
    NSRange foundRange;
    while (searchRange.location < string.length) {
        searchRange.length = string.length-searchRange.location;
        foundRange = [string rangeOfString:substring options:0 range:searchRange];
        if (foundRange.location != NSNotFound) {
            [ranges addObject:[NSValue valueWithRange:foundRange]];
            // found an occurrence of the substring! do stuff here
            searchRange.location = foundRange.location+foundRange.length;
        } else {
            // no more substring to find
            break;
        }
    }
    
    return ranges;
}

NSDictionary * getUrlParams(NSString * url){
    
    //获取url中最外层的引号
    std::map<int, int> pairs;
    
    const unsigned long urlLength = [url length];
    unsigned char * got = (unsigned char *)malloc(urlLength * sizeof(unsigned char));
    int * gotIndex = (int *) malloc(urlLength * sizeof(int));
    memset(got, 0, sizeof(unsigned char) * urlLength);
    memset(gotIndex, 0, sizeof(int) * urlLength);
    int gotCursor = 0;
    //遍历url找到所有单引号和双引号的pair，并放入pairs map内(这个过程会忽略引号嵌套，只取最外层)
    for(int i = 0; i < urlLength; i++){
        const unsigned char c = [url characterAtIndex:i];
        if(c == '\'' || c == '\"'){
            if(got[gotCursor - 1] == c){
                gotCursor--;
                
                //gotCursor为零则表示已经找到最外层引号的pair,存入pairs中
                if(gotCursor == 0){
                    pairs[gotIndex[gotCursor]] = i + 1;
                }
            }else{
                got[gotCursor] = c;
                gotIndex[gotCursor] = i;
                
                gotCursor++;
            }
        }
    }
    
    free(got);
    free(gotIndex);
    
    //把引号内容替换掉，以方便做参数的拆分
    NSMutableString *replacedUrl = [url mutableCopy];
    for (auto it = pairs.crbegin(); it != pairs.crend(); ++it) {
        char *replaceChars =  (char *) malloc(it->second - it->first + 1);
        memset(replaceChars, '0', sizeof(char) * it->second - it->first);
        replaceChars[it->second - it->first] = '\0';
        [replacedUrl replaceCharactersInRange:NSMakeRange(it->first, it->second - it->first) withString:[NSString stringWithCString:replaceChars encoding:NSUTF8StringEncoding]];
    }
    
    NSRange rangeOfQuestionMark = [replacedUrl rangeOfString:@"?" options:NSBackwardsSearch];
    
    //根据替换后的url查找需要拆分的位置，并对原始url进行拆分
    if(rangeOfQuestionMark.location != NSNotFound){
        NSString *replacedQuery = [replacedUrl substringFromIndex:rangeOfQuestionMark.location + 1];
        NSString *query = [url substringFromIndex:rangeOfQuestionMark.location + 1];
        
        NSArray *allRangesOfAndMark = allRangesOfString(@"&", replacedQuery);
        if(allRangesOfAndMark && allRangesOfAndMark.count > 0){
            NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
            
            for(int i = 0; i <= allRangesOfAndMark.count; i++){
                if(i < allRangesOfAndMark.count){
                    NSRange range = [allRangesOfAndMark[i] rangeValue];
                    NSString *replacedPair = [replacedQuery substringToIndex:range.location];
                    NSString *pair = [query substringToIndex:range.location];
                    NSRange equalMarkRange = [replacedPair rangeOfString:@"="];
                    
                    if(equalMarkRange.location != NSNotFound){
                        [result setObject:[pair substringFromIndex:equalMarkRange.location + 1] forKey:[pair substringToIndex:equalMarkRange.location]];
                    }
                }else{
                    NSRange range = [allRangesOfAndMark[allRangesOfAndMark.count - 1] rangeValue];
                    NSString *replacedPair = [replacedQuery substringFromIndex:range.location + 1];
                    NSString *pair = [query substringFromIndex:range.location + 1];
                    NSRange equalMarkRange = [replacedPair rangeOfString:@"="];
                    
                    if(equalMarkRange.location != NSNotFound){
                        [result setObject:[pair substringFromIndex:equalMarkRange.location + 1] forKey:[pair substringToIndex:equalMarkRange.location]];
                    }
                }
            }
            
            return result;
        }else{
            NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
            NSRange equalMarkRange = [replacedQuery rangeOfString:@"="];
            
            if(equalMarkRange.location != NSNotFound){
                [result setObject:[query substringFromIndex:equalMarkRange.location + 1] forKey:[query substringToIndex:equalMarkRange.location]];
            }
            
            return result;
        }
    }
    
    return nil;
}

@implementation StringUtil

+ (NSDictionary *) getUrlParams:(NSString *) urlString{
    return getUrlParams(urlString);
}

@end
