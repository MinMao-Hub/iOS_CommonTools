### UIColor转换以及简单扩展


概述
------

`UIColor`也是我们开发中必然会用到的内容，这里简单的归类了一些常用功能:

* `hexString`转到`UIColor`
* 从`PatternImage`获取`UIColor `
* `UIColor`转换成图片

这里创建了分类`UIColor+MMAddition.{h,m}`来简单的总结上述几个点


[文件代码UIColor+MMAddition.{h,m}下载直接使用](https://github.com/MinMao-Hub/iOS_CommonTools/tree/master/colorExtension)

下面也是全部代码的介绍,可以Ctrl+C使用

API
------


#### 1、***+ (UIColor *)colorWithHexString:(NSString *)hexString***

通过16进制hexString色值直接获取`UIColor`对象

```

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    return [self colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return nil;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return nil;
    
    NSString *rString = [cString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [cString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [cString substringWithRange:NSMakeRange(4, 2)];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    UIColor *hexColor = [UIColor colorWithRed:((float) r / 255.0f)
                                        green:((float) g / 255.0f)
                                         blue:((float) b / 255.0f)
                                        alpha:alpha];
    
    return hexColor;
}

```


#### 2、***+ (UIColor *)colorWithUIImage:(UIImage *)image***

从一张纯色图获取颜色

```
+ (UIColor *)colorWithUIImage:(UIImage *)image {
    return [self colorWithPatternImage:image];
}


```


#### 3、***+ (UIImage *)imageWithColor:(UIColor *)color***

由`UIColor`颜色获取`UIImage`对象

```
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

```


#### 4、***+ (UIImage *)imageWithHexString:(NSString *)hexString***


由16进制`HexString`颜色获取`UIImage`对象

```
+ (UIImage *)imageWithHexString:(NSString *)hexString {
    return [self imageWithColor:[self colorWithHexString:hexString]];
}


```


***PS:以上部分代码需要配套使用***