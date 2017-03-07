//
//  MMCheckTool.h
//  nextPay
//
//  Created by 郭永红 on 2017/2/23.
//  Copyright © 2017年 jfpal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMCheckTool : NSObject



/**
 判断`UITextField`里面的字符串是否为空

 @param textField 文本输入框
 @return 返回结果同下面的`checkEmptyString`方法
 */
+ (BOOL) checkEmpty:(UITextField *)textField;

/**
 判断字符串是否为空

 @param string 字符串
 @return 如果为空返回`YES`  不为空返回`NO`    若果传入这些字符(nil @"" @" "  @"   ")，结果为`YES`
 */
+ (BOOL) checkEmptyString:(NSString *)string;



/**
 判断输入框内的文本是否是手机号

 @param textField 文本输入框
 @return 返回结果同下面的`isVaildMobileNo`方法
 */
+ (BOOL) checkMobileNo:(UITextField *)textField;

/**
 判断是否是有效的手机号

 @param mobileNo 手机号码
 @return 如果是有效的手机号，返回`YES`  否则返回`NO`
 */
+ (BOOL) isVaildMobileNo:(NSString *)mobileNo;



/**
 判断输入框内的文本是否是有效的邮箱

 @param textField 文本输入框
 @return 返回结果同下面的`isValidEmail`方法
 */
+ (BOOL) checkEmail:(UITextField *)textField;

/**
 判断是否是有效的邮箱

 @param checkString 邮箱字符串
 @return 如果是有效的邮箱，返回`YES`  否则返回`NO`
 */
+ (BOOL)isValidEmail:(NSString *)checkString;



+ (BOOL) checkBankCard: (UITextField *) textField;


/**
 判断是否是有效的银行卡号

 @param bankCardNo 银行卡号字符串
 @return 如果是有效的，返回`YES`  否则返回`NO`
 这里的规则是： 银行卡号大于等于12位 小于等于19位，比较粗路的判断
    12位的卡号是比较老的卡种，目前很少见到，  普遍是19位的，少部分16位的
 */
+ (BOOL) isVaildBankCard:(NSString *) bankCardNo;



/**
 判断输入框内的文本是否是有效的身份证号码

 @param textField 文本输入框
 @return 返回结果同下面的`isVaildIDCardNo`方法
 */
+ (BOOL)checkIDCardNum:(UITextField *)textField;


/**
 判断是否是有效的身份证号码

 @param idCardNo 身份证号字符串
 @return 如果是有效的身份证号，返回`YES`, 否则返回`NO`
 
 仅允许  数字 && 最后一位是{数字 || Xx}）
 */
+ (BOOL)isVaildIDCardNo:(NSString *)idCardNo;



/**
 判断输入框内的人名是否是有效的中文名

 @param textField 文本输入框
 @return 返回结果同下面的`isVaildUserRealName`方法
 */
+ (BOOL)checkRealName:(UITextField *)textField;

/**
 判断是否是有效的中文名
 
 @param realName 名字
 @return 如果是在如下规则下符合的中文名则返回`YES`，否则返回`NO`
 限制规则： 
    1. 首先是名字要大于两个汉字
    2. 如果是中间带`{•|·}`的名字，则限制长度15位（新疆人的名字有15位左右的），如果有更长的，请自行修改长度限制
    3. 如果是不带小点的正常名字，限制长度为8位，若果觉得不适，请自行修改位数限制
 *PS: `•`或`·`具体是那个点具体处理需要注意*
 */
+ (BOOL)isVaildRealName:(NSString *)realName;

@end
