### `UIImage`图片存储以及各种转换

概述
------
图片操作是我们开发中必然会用到的一块内容，图片的各种转换（NSData、Base64String、UIColor等转换），本地存储、相册保存等。

这里简单的创建了一个分类(`UIImage (MMAddition)`)来总结了部分图片相关的存储于转换相关的内容。

[文件代码UIImage+MMAddition.{h,m}下载直接使用](https://github.com/MinMao-Hub/iOS_CommonTools/tree/master/imageExtension)



下面也是全部代码的介绍

API
------


#### 1、 `UIImage`图片存储到沙盒Documents文件夹下面

```
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    //获取沙盒Documents路径
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //定义图片存储路径
    NSString *imageFullPath = [DocumentsPath stringByAppendingPathComponent:imageName];
    
    //将图片数据写入文件
    [imageData writeToFile:imageFullPath atomically:NO];
}

```

#### 2、 `UIImage`图片转换为Base64String

```
+ (NSString *)base64StringFromImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    return [UIImage base64forData:imageData];
}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

```


#### 3、 从Base64String生成图片

```
+ (UIImage *)imageWithBase64String:(NSString *)base64Str
{
    NSString *str = [NSString string];
    if ([base64Str hasPrefix:@"data:image/jpg;base64,"]) {
        str = base64Str;
    }else{
        str = [NSString stringWithFormat:@"%@%@", @"data:image/jpg;base64,", base64Str];
    }
    
    NSURL *url = [NSURL URLWithString:str];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    return [UIImage imageWithImgData:imageData];
}

+ (UIImage *)imageWithImgData:(NSData *)imgData
{
    return [UIImage imageWithData:imgData scale:[UIScreen mainScreen].scale];
}

```

#### 4、用`UIColor`生成一张纯色图片

```
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
```

