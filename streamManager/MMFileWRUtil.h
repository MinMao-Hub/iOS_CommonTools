//
//  MMFileWRUtil.h
//  DDWeexDemo
//
//  Created by 郭永红 on 2016/12/28.
//  Copyright © 2016年 郭永红. All rights reserved.
//
//  FileWriteReadUtil
//  文件读写

#import <Foundation/Foundation.h>

@interface MMFileWRUtil : NSObject


/**
 *    普通的写入方式大家都应该用过，就是用集合对象直接调用系统提供的方法来写入文件
 *      eg：[object writeToFile:@"filepath" atomically:YES];
 *         ps: 该方法中object中的参数值不能为null，否则一定会写入失败
 *
 *    这里我们使用`NSInputStream`和`NSOutputStream`两个输入输出流对象来处理写入与读取
 */


/**
 将json对象写入到Documents文件夹下面的某个文件中

 @param jsonObject json对象
 @param fileName 文件名
 */
+ (void)writeJsonObject:(id)jsonObject IntoDocumentsFile:(NSString *)fileName;

/**
 将json对象写入到文件中
 
 @param object json对象
 @param filePath 文件绝对路径
 */
+ (void)writeJsonObject:(id)object intoFile:(NSString *)filePath;


/**
 *  从json文件中读出 json对象
 *
 *  @param filePath 文件路径
 *
 *  @return json对象
 */
+ (id)readObjectFromFile:(NSString *)filePath;


/**
 从json文件中读出 NSString

 @param filePath 文件路径
 @return NSString对象
 */
+ (NSString *)readStringFromFilePath:(NSString *)filePath;


/**
 *  从json文件中读出 NSArray
 *
 *  @param filePath 文件路径
 *
 *  @return NSArray对象
 */
+ (NSArray *)readArrayFromFilePath:(NSString *)filePath;

/**
 *  从json文件中读出 NSDictionary
 *
 *  @param filePath 文件路径
 *
 *  @return NSDictionary对象
 */
+ (NSDictionary *)readDictionaryFromFilePath:(NSString *)filePath;

@end
