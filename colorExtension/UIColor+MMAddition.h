//
//  UIColor+MMAddition.h
//  Pods
//
//  Created by 郭永红 on 2017/2/22.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (MMAddition)


/**
 通过哈希值获取UIcolor颜色
 
 @param hexString hex值字符串
 @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;



/**
 通过哈希值获取UIcolor颜色
 
 @param hexString hex值字符串
 @param alpha 透明度
 @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;



/**
 从一张单色滤镜图片上面获取颜色
 
 @param image UIImage对象
 @return UIColor对象
 */
+ (UIColor *)colorWithUIImage:(UIImage *)image;



/**
 用UIColor颜色生成一张纯色图片
 
 @param color UIColor颜色对象
 @return UIImage对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color;



/**
 用哈希值获取一张纯色图片
 
 @param hexString hex值字符串
 @return UIImage对象
 */
+ (UIImage *)imageWithHexString:(NSString *)hexString;



@end
