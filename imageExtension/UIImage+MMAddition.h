//
//  UIImage+MMAddition.h
//  Pods
//
//  Created by 郭永红 on 2017/2/21.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (MMAddition)



/**
 保存图片到沙盒
 
 @param currentImage image对象
 @param imageName 图片命名
 */
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;


/**
 将图片转换成Base64String
 
 @param image `UIImage`对象
 @return Base64String
 */
+ (NSString *)base64StringFromImage:(UIImage *)image;



/**
 将NSData转换为Base64String

 @param theData NSData数据
 @return Base64String
 */
+ (NSString*)base64forData:(NSData*)theData;


/**
 将Base64String转换成`UIImage`对象
 
 @param base64Str base64Str
 @return `UIImage`对象
 */
+ (UIImage *)imageWithBase64String:(NSString *)base64Str;


/**
 将NSData转换成`UIImage`对象
 
 @param imgData NSData数据对象
 @return `UIImage`对象
 */
+ (UIImage *)imageWithData:(NSData *)imgData;



/**
 用一种颜色创建一张图片
 
 @param color `UIColor`对象
 @return `UIImage`对象
 */
+ (UIImage *)imageWithUIcolor:(UIColor *)color;

/**
 用一种颜色创建一张图片
 
 @param color `UIColor`对象
 @param size  创建图片大小
 @return `UIImage`对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
