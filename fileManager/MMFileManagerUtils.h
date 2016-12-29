//
//  FileManagerUtils.h
//  DDWeexDemo
//
//  Created by 郭永红 on 2016/12/27.
//  Copyright © 2016年 郭永红. All rights reserved.
//

/**
 *    * 一. 文件相关
 *    *
 *      1.1 在Documents文件夹下面创建一个文件(只需要传入文件名即可)
 *      1.2 在Documents文件夹下面创建一个有内容的文件（支持写入: NSData、NSDictionary、NSArray、NSString）
 *      1.3 创建一个全路径文件（需要传入文件全路径）
 *      1.4 创建一个有内容的全路径文件（支持写入: NSData、NSDictionary、NSArray、NSString）
 *      1.5 删除Documents文件夹下面的文件
 *      1.6 删除类似于上述创建的文件
 *      1.7 文件重命名
 *    *
 *    * 二. 文件夹相关
 *    *
 *      2.1 在Documents文件夹下面创建一个文件夹
 *      2.2 创建一个全路径的文件夹
 *      2.3 删除Documents文件夹下面的文件夹
 *      2.4 删除类似于上述创建的全路径文件夹
 *      2.5 文件夹重命名
 *    *
 *    * 三. other
 *    *
 *      3.1 获取Documents文件夹路径
 *      3.2 获取Cache文件夹路径
 *      3.3 获取Library文件夹路径
 *      3.4 打印Documents文件夹下面的所有文件列表
 *      3.5 打印某个文件夹下面的所有文件列表
 *      3.6 判断Documents文件夹下面是否存在某个文件
 *      3.7 判断某个文件是否存在
 *    *
 */





#import <Foundation/Foundation.h>

@interface MMFileManagerUtils : NSObject



/**
 *   一. 文件相关
 */


/**
 1.1 在Documents文件夹下面创建一个文件

 @param filename 文件名   ps：如果有后缀名的话需要带后缀名
 @param complete 创建结束回调  isCreated: 创建成功与否， error: 失败时的错误信息
 */
+ (void)createFileAtDocuments:(NSString *)filename  completed:(void (^)(BOOL isCreated, NSError *error))complete;


/**
 1.2 在Documents文件夹下面创建一个有内容的文件

 @param filename 文件名   ps：如果有后缀名的话需要带后缀名
 @param dataObject 需要写入文件的内容（支持写入: NSData、NSDictionary、NSArray、NSString）, 若该值为空，创建一个空文件
 @param complete 创建结束回调  isCreated: 创建成功与否， error: 失败时的错误信息
 */
+ (void)createFileAtDocuments:(NSString *)filename withObject:(id)dataObject  completed:(void (^)(BOOL isCreated, NSError *error))complete;


/**
 1.3 创建一个指定文件（需要输入全路径）
 
 @param filepath 文件绝对路径
 @param complete 创建结束回调  isCreated: 创建成功与否， error: 失败时的错误信息
 */
+ (void)createFile:(NSString *)filepath completed:(void (^)(BOOL isCreated, NSError *error))complete;



/**
 1.4 创建一个有内容的指定文件（需要输入全路径）

 @param filepath 文件绝对路径
 @param dataObject 需要写入文件的内容（支持写入: NSData、NSDictionary、NSArray、NSString）, 若该值为空，创建一个空文件
 @param complete 创建结束回调  isCreated: 创建成功与否， error: 失败时的错误信息
 */
+ (void)createFile:(NSString *)filepath withObject:(id)dataObject completed:(void (^)(BOOL isCreated, NSError *error))complete;


/**
 1.5 删除Documents文件夹下面的某个指定文件

 @param filename 文件名
 @param complete 删除结束回调  isRemoved: 创建成功与否， error: 失败时的错误信息
 */
+ (void)removeFileAtDocuments:(NSString *)filename completed:(void (^)(BOOL isRemoved, NSError *error))complete;


/**
 1.6 删除一个指定文件

 @param filepath 文件绝对路径
 @param complete 删除结束回调  isRemoved: 创建成功与否， error: 失败时的错误信息
 */
+ (void)removeFile:(NSString *)filepath completed:(void (^)(BOOL isRemoved, NSError *error))complete;



/**
 1.7 文件重命名

 @param filePath 文件全路径
 @param newFileName 新文件名(只需要文件名，不需要全路径)
 @param complete 重命名结束回调  isRenamed: 重命名成功与否， error: 失败时的错误信息
 */
+ (void)renameFile:(NSString *)filePath toNewFileName:(NSString *)newFileName completed:(void (^)(BOOL isRenamed, NSError *error))complete;


/**
 *   二. 文件夹相关
 */






/**
 2.1 在Documents文件夹下面创建一个文件夹

 @param foldername 文件夹名
 @param complete 创建结束回调  isCreated: 创建成功与否， error: 失败时的错误信息
 */
+ (void)createFolderAtDocuments:(NSString *)foldername completed:(void (^)(BOOL isCreated, NSError *error))complete;


/**
 2.2 创建一个指定文件夹（需要输入全路径）
 
 @param folderpath 文件夹绝对路径
 @param complete 创建结束回调  isCreated: 创建成功与否， error: 失败时的错误信息
 */
+ (void)createFolder:(NSString *)folderpath completed:(void (^)(BOOL isCreated, NSError *error))complete;


/**
 2.3 删除Documents文件夹下面的某个指定文件夹
 
 @param foldername 文件夹名
 @param complete 删除结束回调  isRemoved: 创建成功与否， error: 失败时的错误信息
 */
+ (void)removeFolderAtDocuments:(NSString *)foldername completed:(void (^)(BOOL isRemoved, NSError *error))complete;


/**
 2.4 删除一个指定文件夹
 
 @param folderpath 文件夹绝对路径
 @param complete 删除结束回调  isRemoved: 创建成功与否， error: 失败时的错误信息
 */
+ (void)removeFolder:(NSString *)folderpath completed:(void (^)(BOOL isRemoved, NSError *error))complete;


/**
 2.5 文件夹重命名
 
 @param folderPath 文件夹全路径
 @param newFolderName 新文件夹名(只需要文件夹名，不需要全路径)
 @param complete 重命名结束回调  isRenamed: 重命名成功与否， error: 失败时的错误信息
 */
+ (void)renameFolder:(NSString *)folderPath toNewFolderName:(NSString *)newFolderName completed:(void (^)(BOOL isRenamed, NSError *error))complete;


/*
 *     三 . other
 */



/**
 3.1 获取Documents文件夹路径
 
 @return Documents绝对路径
 */
+ (NSString *)appDocumentsPath;


/**
 3.2 获取沙盒中的缓存路径

 @return cache绝对路径
 */
+ (NSString *)appCachePath;


/**
 3.3 获取library路径

 @return library绝对路径
 */
+ (NSString *)appLibraryPath;

/**
 3.4 打印Documents文件夹下面的文件列表
 */
+ (void)printFileListWithDocuments;

/**
 3.5 打印某个指定文件夹下面的文件列表
 */
+ (void)printFileListWithFolderPath:(NSString *)path;

/**
 3.6 判断一个文件或者文件夹是否存在于Documents文件夹下面
 
 @param filename 文件名（有后缀名的需要带后缀名）
 @return 是否存在
 */
+ (BOOL)fileExistAtDocuments:(NSString *)filename;


/**
 3.7 判断一个文件或者文件夹是否存在
 
 @param filepath 文件绝对路径
 @return 是否存在
 */
+ (BOOL)fileExist:(NSString *)filepath;

@end
