//
//  MMCheckTool.m
//  nextPay
//
//  Created by 郭永红 on 2017/2/23.
//  Copyright © 2017年 jfpal. All rights reserved.
//

#import "MMCheckTool.h"

@implementation MMCheckTool

+ (BOOL) checkEmpty:(UITextField *) textField {
    return [MMCheckTool checkEmptyString:textField.text];
}

+ (BOOL) checkEmptyString:(NSString *) string {
    
    if (string == nil) return string == nil;
    
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [newStr isEqualToString:@""];
}


+ (BOOL) checkMobileNo:(UITextField *)textField {
    
    return [MMCheckTool isVaildMobileNo:textField.text];
}

+ (BOOL) isVaildMobileNo:(NSString *)mobileNo
{
    if ([MMCheckTool checkEmptyString:mobileNo]) return NO;
    
    NSString *phoneRegex = @"^((1[34578]))\\d{9}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobileNo];
}

+ (BOOL) checkEmail:(UITextField *)textField {
    
    return [MMCheckTool isValidEmail:textField.text];
}

+ (BOOL)isValidEmail:(NSString *)checkString
{
    if ([MMCheckTool checkEmptyString:checkString]) return NO;
    
    NSString *emailRegex = @"^(([a-zA-Z0-9_-]+)|([a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)))@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL) checkBankCard: (UITextField *)textField {
    
    return [MMCheckTool isVaildBankCard:textField.text];
}

+ (BOOL) isVaildBankCard:(NSString *)bankCardNo {
    
    if ([MMCheckTool checkEmptyString:bankCardNo]) return NO;
    
    NSString *judgeStr = [bankCardNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [judgeStr length] >= 12 && [judgeStr length] <= 19;     //银行卡号一定是大于等于12位小于等于19位的数字
}


// 身份证号码校验 （仅允许  数字 ||  Xx）
+ (BOOL)checkIDCardNum:(UITextField *)textField
{
    return [MMCheckTool isVaildIDCardNo:textField.text];
}

// 身份证号码校验 （仅允许  数字 ||  Xx）
+ (BOOL)isVaildIDCardNo:(NSString *)idCardNo
{
    if ([MMCheckTool checkEmptyString:idCardNo]) return NO;
        
    NSString *regxStr = @"^[1-9][0-9]{5}[1-9][0-9]{3}((0[0-9])|(1[0-2]))(([0|1|2][0-9])|3[0-1])[0-9]{3}([0-9]|X|x)$";
    
    NSPredicate *idcardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regxStr];
    return [idcardTest evaluateWithObject:idCardNo];
}


+ (BOOL)checkRealName:(UITextField *)textField
{
    return [MMCheckTool isVaildRealName:textField.text];
}

// 姓名校验 2~8个中文字,不允许拼音,数字
+ (BOOL)isVaildRealName:(NSString *)realName
{
    if ([MMCheckTool checkEmptyString:realName]) return NO;
    
    NSRange range1 = [realName rangeOfString:@"·"];
    NSRange range2 = [realName rangeOfString:@"•"];
    if(range1.location != NSNotFound ||   // 中文 ·
       range2.location != NSNotFound )    // 英文 •
    {
        //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 15)
        {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
    else
    {
        //一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 8) {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
}


@end
