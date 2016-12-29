//
//  MMFileWRUtil.m
//  DDWeexDemo
//
//  Created by 郭永红 on 2016/12/28.
//  Copyright © 2016年 郭永红. All rights reserved.
//

#import "MMFileWRUtil.h"

@implementation MMFileWRUtil


+ (void)writeJsonObject:(id)jsonObject IntoDocumentsFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocumentsPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *JsonPath = [DocumentsPath stringByAppendingPathComponent:fileName];
    
    [DDUtils writeJsonContent:jsonObject IntoFilePath:JsonPath];
}

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

+ (NSString *)readStringFromFilePath:(NSString *)filePath {
    return [MMFileWRUtil readObjectFromFile:filePath];
}

+ (NSArray *)readArrayFromFilePath:(NSString *)filePath {
    return [MMFileWRUtil readObjectFromFile:filePath];
}

+ (NSDictionary *)readDictionaryFromFilePath:(NSString *)filePath {
    return [MMFileWRUtil readObjectFromFile:filePath];
}

@end
