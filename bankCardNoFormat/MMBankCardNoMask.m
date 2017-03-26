//
//  MMBankCardNoMask.m
//  jfpal3
//
//  Created by 郭永红 on 2017/3/26.
//  Copyright © 2017年 JFPAL. All rights reserved.
//

#import "MMBankCardNoMask.h"

@implementation MMBankCardNoMask

+ (NSString *) maskBankCardStr:(NSString *) bcstr {
    
    NSString *tmpStr = [bcstr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *returnStr = @"";
    if([tmpStr length]>=10){
        
        NSRange sufRange = NSMakeRange([tmpStr length]-4, 4);
        NSString *sufString = [tmpStr substringWithRange:sufRange];
        
        NSString *tmpStr = @"";
        for (int i = 0; i < 12; i++) {
            tmpStr = [tmpStr stringByAppendingString:@"*"];
        }
        
        returnStr = [tmpStr stringByAppendingString:sufString];
        
        NSInteger rStrLength = returnStr.length;
        NSString *formatStr = @"";
        NSString *subStr = @"";
        
        for (NSUInteger i = 0; i < rStrLength; i+=4){
            
            if(i<rStrLength-5){
                
                NSRange range = NSMakeRange(i, 4);
                
                subStr = [returnStr substringWithRange:range];
                formatStr = [formatStr stringByAppendingString:subStr];
                formatStr = [formatStr stringByAppendingString:@" "];
                
            }else{
                
                NSRange range = NSMakeRange(i, rStrLength - i);
                
                subStr = [returnStr substringWithRange:range];
                formatStr = [formatStr stringByAppendingString:subStr];
                
                returnStr = formatStr;
                break;
                
            }
            
        }
        
    }else{
        returnStr = tmpStr;
    }
    
    return returnStr;
}


+ (NSString *) maskBankCardStr:(NSString *)bcstr withString:(NSString *)maskStr andReplaceCounts:(NSInteger)counts
{
    if (maskStr == nil) {
        maskStr = @"*";
    }
    if (counts > 12) {
        counts = 12;
    }
    NSString *returnStr = @"";
    NSString *maskStrings = @"";
    if([bcstr length]>=4 && counts <=12){
        
        for (int i = 0; i < counts; i++) {
            maskStrings = [maskStrings stringByAppendingString:maskStr];
        }
        
        NSRange perRange = NSMakeRange(0, 12-counts);//前几位
        NSRange sufRange = NSMakeRange([bcstr length]-4, 4);//后4位
        
        NSString *perString = [bcstr substringWithRange:perRange];
        NSString *sufString = [bcstr substringWithRange:sufRange];
        
        returnStr = [[perString stringByAppendingString:maskStrings] stringByAppendingString:sufString];//拼接后显示出来
        
    }else if (counts >12 && counts <= bcstr.length) {
        for (int i = 0; i < counts; i++) {
            maskStrings = [maskStrings stringByAppendingString:maskStr];
        }
        
        NSRange perRange = NSMakeRange(0, maskStrings.length);
        
        returnStr = [bcstr stringByReplacingOccurrencesOfString:[bcstr substringWithRange:perRange] withString:maskStrings];
    }else{
        returnStr = bcstr;
    }
    
    
    return returnStr;
}


@end
