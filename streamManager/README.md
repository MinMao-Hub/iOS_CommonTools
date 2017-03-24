## 文件写入与读出（read and write）


1. [个人github](https://github.com/MinMao-Hub)
2. [CDSN博客首页](http://blog.csdn.net/u012988591)


[详细源码见github](https://github.com/MinMao-Hub/iOS_CommonTools/tree/master/streamManager)

```
/**
 *    普通的写入方式大家都应该用过，就是用集合对象直接调用系统提供的方法来写入文件
 *      eg：[object writeToFile:@"filepath" atomically:YES];
 *         ps: 该方法中object中的参数值不能为null，否则一定会写入失败
 *
 *    这里我们使用`NSInputStream`和`NSOutputStream`两个输入输出流对象来处理写入与读取，而stream的方式读取速度是优于普通方式的，因为它直接处理数据流，没有过多的处理数据。
 *    
 *    有任何不足或者需要加强的地方，希望多多提意见，在下感激不尽...
 */

```

### NSInputStream、NSOutputStream两个流对象的简单使用

#### 1. 将一个jsonObject写入到文件中

```objective-c
+ (void)writeJsonObject:(id)object intoFile:(NSString *)filePath {
    NSError *error;
    //1.创建输出流对象
    NSOutputStream *outpusStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    //2.打开
    [outpusStream open];
    //3.将json内容写入文件
    [NSJSONSerialization writeJSONObject:object toStream:outpusStream options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"写入文件失败: %@",error.description);
    }else{
        NSLog(@"写入文件成功: %@",filePath);
    }
    //4.关闭
    [outpusStream close];
}
```

*PS: 其中`jsonObject`可以是：`NSDictionary`、`NSArray`、`NSString`等可属性列表(.plist)化的对象之一.*

filepath必须为文件绝对路径，详细见源码[MMFileWRUtil.m](https://github.com/MinMao-Hub/iOS_CommonTools/blob/master/streamManager/MMFileWRUtil.m)，其中对Documents文件夹单独了一个方法`+ (void)writeJsonObject:(id)jsonObject IntoDocumentsFile:(NSString *)fileName`，只需要传入文件名即可。


#### 2. 从文件中读取出jsonObject

```objective-c
+ (id)readObjectFromFile:(NSString *)filePath {
    NSError *error;
    //1.创建输入流对象
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:filePath];
    [inputStream open];
    //2.将json文件的内容读写到NSDictionary
    id jsonObject = [NSJSONSerialization JSONObjectWithStream:inputStream options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"读取文件失败: %@",error.description);
    }else{
        NSLog(@"读取文件成功: %@",filePath);
    }
    
    [inputStream close];
    return jsonObject;
}
```

*PS: 返回值可能为：`NSDictionary`、`NSArray`、`NSString`等可属性列表(.plist)化的对象之一*

filepath必须为文件绝对路径，详细见源码[MMFileWRUtil.m]()，其中做了一些专有的归类化方法（分别针对`NSDictionary `、`NSArray `、`NSString `）