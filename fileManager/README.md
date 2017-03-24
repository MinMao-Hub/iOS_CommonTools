### `MMFileManagerUtils`

### 概述

在我们平常的开发中，文件的操作相对来说可能会比较少，但是这个东西也是需要去学习、去了解的；因为这个东西也是iOS开发中必不可少的一部分。有的时候当你对一个不是很了解的东西或者内容了解透彻的时候，内心就会有很大的满足感，亦或者是喜悦感吧，总想分享出自己的喜悦给大家。

所以我这里简单的总结了一下文件存储可能会常用到的那块内容。有任何不足或者需要加强的地方，希望多多提意见，在下感激不尽...

1. [个人github](https://github.com/MinMao-Hub)
2. [CDSN博客首页](http://blog.csdn.net/u012988591)

### <center>大致目录如下
---
```

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
 *      3.1 获取Cache文件夹路径
 *      3.1 获取Library文件夹路径
 *      3.2 打印Documents文件夹下面的所有文件列表
 *      3.3 打印某个文件夹下面的所有文件列表
 *      3.4 判断Documents文件夹下面是否存在某个文件
 *      3.5 判断某个文件是否存在
 *    *
 */
 
```

[全部源码直接下载使用-github](https://github.com/MinMao-Hub/iOS_CommonTools/tree/master/fileManager)


在这里创建了一个类 MMFileManagerUtils,下面代码每一个方法中都会有一个回调的block用来处理增、删、改文件是否成功，以及错误信息的返回。

##核心功能代码：

只列举上述目录中的部分功能点！！！详细的请查看源码。

### 1. 创建文件

```objective-c

+ (void)createFile:(NSString *)filepath completed:(void (^)(BOOL isCreated, NSError *error))complete {
    
    NSAssert(filepath != nil || filepath.length >= 0, @"filepath isn't to nil");
    
    BOOL create = NO;
    NSError *cError;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        create =  [[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
        if (create) {
            NSLog(@"file create success at: ##-%@-##",filepath);
            cError = nil;
        }else{
            NSLog(@"file create failed at: %@",filepath);
            cError = [NSError errorWithDomain:@"NSErrorDomain" code:0 userInfo:@{@"info":[NSString stringWithFormat:@"file create failed at: %@",filepath]}];
        }
    }else{
        NSLog(@"file create failed at: %@",filepath);
        cError = [NSError errorWithDomain:@"NSErrorDomain" code:0 userInfo:@{@"info":[NSString stringWithFormat:@"file already exist at: %@",filepath]}];
    }
    
    if (complete) {
        complete(create,cError);
    }
}

```

 这个是创建文件的主要代码，可直接拷贝使用，Documents下面的创建文件的方法`+ (void)createFileAtDocuments:(NSString *)filename  completed:(void (^)(BOOL isCreated, NSError *error))complete`衍生自上述这个方法，详细见源码[github](https://github.com/MinMao-Hub/iOS_CommonTools/tree/master/fileManager),

 还有一种就是在创建文件的时候写入一些数据，这个方法`+ (void)createFile:(NSString *)filepath withObject:(id)dataObject completed:(void (^)(BOOL isCreated, NSError *error))complete`也可以自行查阅代码

***PS：需要注意的一点是，该方法需要传入全路径，Documents下面只需要传入文件名即可*** 

### 2. 删除文件

```objective-c

+ (void)removeFile:(NSString *)filepath completed:(void (^)(BOOL isRemoved, NSError *error))complete {
    
    NSAssert(filepath != nil || filepath.length >= 0, @"filepath isn't to nil");
    
    NSError *error;
    BOOL remove = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        remove = [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
    }else{
        remove = NO;
        error = [NSError errorWithDomain:@"NSErrorDomain" code:0 userInfo:@{@"info":[NSString stringWithFormat:@"file ‘%@' don't exist at  the Folder",filepath]}];
    }
    
    NSLog(@"file remove %@ at: ##-%@-##",remove ? @"Success" : @"Failed" ,filepath);
    if (complete) {
        complete(remove, error);
    }
}

```

删除文件方法如上。可以和删除文件夹的方法`+ (void)removeFolder:(NSString *)folderpath completed:(void (^)(BOOL isRemoved, NSError *error))complete`通用

从Documents下面删除文件的方法`+ (void)removeFileAtDocuments:(NSString *)filename completed:(void (^)(BOOL isRemoved, NSError *error))complete`也一样，只是我这边简单的拼接了一下Documents文件夹路径。

### 3. 重命名文件

```objective-c

+ (void)renameFile:(NSString *)filePath toNewFileName:(NSString *)newFileName completed:(void (^)(BOOL isRenamed, NSError *error))complete {
    
    NSAssert(filePath != nil || filePath.length >= 0 || newFileName, @"filepath isn't to nil or new fileName isn't to nil");
    
    NSString *foldername = [filePath stringByDeletingLastPathComponent];
    
    NSString *tmpFilepath = newFileName;
    if ([tmpFilepath hasPrefix:foldername] || [tmpFilepath componentsSeparatedByString:@"/"].count > 1) {
        tmpFilepath = newFileName;
    }else{
        tmpFilepath = [foldername stringByAppendingPathComponent:newFileName];
    }
    
    NSError *error;
    BOOL rename = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        rename =  [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:tmpFilepath error:&error];
    }else{
        rename = NO;
        error = [NSError errorWithDomain:@"NSErrorDomain" code:0 userInfo:@{@"info":[NSString stringWithFormat:@"file ‘%@' rename failed to %@,because the file isn't exist",filePath, newFileName]}];
    }
    
    NSLog(@"file %@ rename to %@ : %@",filePath.lastPathComponent ,newFileName, rename?@"success" : @"Failed");
    if (complete) {
        complete(rename, error);
    }
    
}

```

重命名文件，事实上是做了一个移动的操作，将一个文件移动到一个新文件中。

其中`filePath`必须为文件全路径，`newFileName； `可以为新文件的名字，也可以是新文件的全路径。

### 4. 创建文件夹

```objective-c

+ (void)createFolder:(NSString *)folderpath completed:(void (^)(BOOL isCreated, NSError *error))complete {
    
    NSAssert(folderpath != nil || folderpath.length >= 0, @"文件夹路径不能为空");

    NSError *error;
    BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:YES attributes:nil error:&error];
    if (create) {
        NSLog(@"folder create success at: ##-%@-##",folderpath);
        
    }else{
        NSLog(@"folder create failed at: %@",folderpath);
    }
    
    if (complete) {
        complete(create, error);
    }
}

```

如上，便是创建文件夹的主要代码，可以直接使用，在Documents文件加下面创建问价夹的方法`+ (void)createFolderAtDocuments:(NSString *)foldername completed:(void (^)(BOOL isCreated, NSError *error))complete`也是在其上面简单的扩展，详细见源码[github](http://www.baidu.com/index.html)

### 5. 删除文件夹

```objective-c

+ (void)removeFolder:(NSString *)folderpath completed:(void (^)(BOOL isRemoved, NSError *error))complete {
    
    NSAssert(folderpath != nil || folderpath.length >= 0, @"filepath isn't to nil");
    
    NSError *error;
    BOOL remove = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderpath]) {
        remove = [[NSFileManager defaultManager] removeItemAtPath:folderpath error:&error];
    }else{
        remove = NO;
        error = [NSError errorWithDomain:@"NSErrorDomain" code:0 userInfo:@{@"info":[NSString stringWithFormat:@"Folder ‘%@' removed failed from the dir, because the folder isn't exist",folderpath]}];
    }
    
    if (complete) {
        complete(remove, error);
    }
}

```

删除文件夹的这个方法事实上跟删除文件的方法是一样的，可以互相通用的，这里是方便大家区分处理，以便于更清晰的使用。

Documents文件夹下面删除文件夹的方法`+ (void)removeFolderAtDocuments:(NSString *)foldername completed:(void (^)(BOOL isRemoved, NSError *error))complete`，同理。

### 6. 各种沙盒内目录路径获取
* Home目录

`NSString *homeDirectory = NSHomeDirectory();`

* tmp目录(临时数据存储，重启APP会清除)

`NSString *tmpDir = NSTemporaryDirectory();`

* Documents文件夹路径获取

```objective-c
	
+ (NSString *)appDocumentsPath {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
   return documentsPath;
}
```
	
	
* Cache路径获取

```objective-c
+ (NSString *)appCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return cachePath;
}

```

* library文件夹路径获取(存储程序的默认设置或其它状态信息)

```objective-c
+ (NSString *)appLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return libraryPath;
}

```




### 7. 打印文件夹下面的文件列表

 打印出来的结果是个字符串数组，主要还是方便调试文件的一些操作过程吧。

* 打印Documents文件夹下面的文件列表

```
+ (void)printFileListWithDocuments
{
    [MMFileManagerUtils printFileListWithFolderPath:[MMFileManagerUtils appDocumentsPath]];
}
```

* 打印某个指定文件夹下面的文件列表

```objective-c

+ (void)printFileListWithFolderPath:(NSString *)path
{
    NSAssert(path != nil, @"path can't be nil");
    NSError *error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    NSLog(@"FileList in (%@):\n%@",path == nil ? DocumentsDirectory : path,[directoryContents description]);
}

```
