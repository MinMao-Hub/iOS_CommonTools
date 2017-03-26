### 银行卡号简单的格式化显示处理（支付宝、微信绑定卡列表显示卡号）



### 概述

观察发现支付宝和微信中不管是多少位的银行卡号，均被格式化为16位;类似于`**** **** **** 1111`这种格式，就是前面12位`*`加上卡号四位尾号，然后再每四位用空格隔开。我这里会有两种格式化方法：

第一种是跟支付宝微信一样的处理方式。

第二种是对卡号中间做符号（用`*`或者任意自己想用的符号）处理，类似于`622848********12345`,可以具体的定义替换符号以及替换几个数字。

如果对代码有任何问题或者有异议，或者有好的建议，请在下面评论，或者联系笔者（Q:1286090267）；在下感激不尽。

[源码下载](https://github.com/MinMao-Hub/iOS_CommonTools/tree/master/bankCardNoFormat)

### API

#### 1. 类似于支付宝和微信绑定银行卡列表中卡号显示格式化方法

```
/**
 类似于支付宝和微信绑定银行卡列表中卡号显示格式化方法
 format str  eg.   transform "6012890986899099333"  to "**** **** **** 9333"


 @param bcstr 银行卡号
 @return mask之后的卡号
 */
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
```


#### 2. 对银行卡号做`*`处理

```
/**
 *  format str  eg.   transform "6012890986899099333"  to "601289******9333"
 *
 *  @param bcstr   银行卡号
 *  @param maskStr 格式字符（* 或者 # 等等），默认为 *
 *  @param counts  替换的字符个数
 *
 *  @return 替换后的字符串
 */

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
```


### Usage

[下载源码](https://github.com/MinMao-Hub/iOS_CommonTools/tree/master/bankCardNoFormat) 然后将文件`MMBankCardNoMask.{h,m}`拷贝到项目中，导入`#import "MMBankCardNoMask.h"`

调用方法如下:

![调用代码方法](http://img.blog.csdn.net/20170326162047178?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMjk4ODU5MQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

打印结果如下：

![这里写图片描述](http://img.blog.csdn.net/20170326162354929?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMjk4ODU5MQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)



### 关于

1. [个人github](https://github.com/MinMao-Hub)
2. [CDSN博客首页](http://blog.csdn.net/u012988591)
3. Q:1286090267

