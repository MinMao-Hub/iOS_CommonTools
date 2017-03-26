//
//  MMBankCardNoMask.h
//  jfpal3
//
//  Created by 郭永红 on 2017/3/26.
//  Copyright © 2017年 JFPAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMBankCardNoMask : NSObject



/**
 类似于支付宝和微信绑定银行卡列表中卡号显示格式化方法
 format str  eg.   transform "6012890986899099333"  to "**** **** **** 9333"


 @param bcstr 银行卡号
 @return mask之后的卡号
 */
+ (NSString *) maskBankCardStr:(NSString *) bcstr;


/**
 *  format str  eg.   transform "6012890986899099333"  to "601289******9333"
 *
 *  @param bcstr   银行卡号
 *  @param maskStr 格式字符（* 或者 # 等等），默认为 *
 *  @param counts  替换的字符个数
 *
 *  @return 替换后的字符串
 */
+ (NSString *) maskBankCardStr:(NSString *)bcstr withString:(NSString *)maskStr andReplaceCounts:(NSInteger)counts;

@end
