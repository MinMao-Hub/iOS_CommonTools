//
//  FileManagerUtils.m
//  DDWeexDemo
//
//  Created by 郭永红 on 2016/12/27.
//  Copyright © 2016年 郭永红. All rights reserved.
//

#import "MMFileManagerUtils.h"

@implementation MMFileManagerUtils


+ (void)createFileAtDocuments:(NSString *)filename  completed:(void (^)(BOOL isCreated, NSError *error))complete
{
    NSString *documentsPath = [MMFileManagerUtils appDocumentsPath];
    
    [MMFileManagerUtils createFile:[documentsPath stringByAppendingPathComponent:filename] completed:^(BOOL isCreated, NSError *error) {
        if (complete) {
            complete(isCreated, error);
        }
    }];
}

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

+ (void)createFileAtDocuments:(NSString *)filename withObject:(id)dataObject  completed:(void (^)(BOOL isCreated, NSError *error))complete
{
    NSString *documentsPath = [MMFileManagerUtils appDocumentsPath];
    
    [MMFileManagerUtils createFileAtDocuments:[documentsPath stringByAppendingPathComponent:filename] withObject:dataObject completed:^(BOOL isCreated, NSError *error) {
        complete(isCreated, error);
    }];
}

+ (void)createFile:(NSString *)filepath withObject:(id)dataObject completed:(void (^)(BOOL isCreated, NSError *error))complete {
    NSAssert(filepath != nil || filepath.length >= 0, @"filepath isn't to nil");
    
    NSData *dataContent = [NSData data];
    if ([dataObject isKindOfClass:[NSData class]]) {
       dataContent = dataObject;
    }
    else if ([dataObject isKindOfClass:[NSString class]] ||
             [dataObject isKindOfClass:[NSArray class]] ||
             [dataObject isKindOfClass:[NSDictionary class]])
    {
        dataContent = [NSJSONSerialization dataWithJSONObject:dataObject options:NSJSONWritingPrettyPrinted error:nil];
    }
    else
    {
        dataContent = nil;
    }
    
    
    BOOL create = NO;
    NSError *cError;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        create =  [[NSFileManager defaultManager] createFileAtPath:filepath contents:dataContent attributes:nil];
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


+ (void)removeFileAtDocuments:(NSString *)filename completed:(void (^)(BOOL isRemoved, NSError *error))complete {
    
    NSString *documentsPath = [MMFileManagerUtils appDocumentsPath];
    
    [MMFileManagerUtils removeFile:[documentsPath stringByAppendingPathComponent:filename] completed:^(BOOL isRemoved, NSError *error) {
        if (complete) {
            complete(isRemoved, error);
        }
    }];
}

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


+ (void)createFolderAtDocuments:(NSString *)foldername completed:(void (^)(BOOL isCreated, NSError *error))complete {
    
    NSString *documentsPath = [MMFileManagerUtils appDocumentsPath];
    
    [MMFileManagerUtils createFolder:[documentsPath stringByAppendingPathComponent:foldername] completed:^(BOOL isCreated, NSError *error) {
        if (complete) {
            complete(isCreated, error);
        }
    }];
}


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


+ (void)removeFolderAtDocuments:(NSString *)foldername completed:(void (^)(BOOL isRemoved, NSError *error))complete {
    
    NSString *documentsPath = [MMFileManagerUtils appDocumentsPath];
    
    [MMFileManagerUtils removeFile:[documentsPath stringByAppendingPathComponent:foldername] completed:^(BOOL isRemoved, NSError *error) {
        if (complete) {
            complete(isRemoved, error);
        }
    }];
}


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


+ (void)renameFolder:(NSString *)folderPath toNewFolderName:(NSString *)newFolderName completed:(void (^)(BOOL isRenamed, NSError *error))complete {
    
    NSAssert(folderPath != nil || folderPath.length >= 0 || newFolderName, @"folderPath isn't to nil or new folderName isn't to nil");
    
    NSString *foldername = [folderPath stringByDeletingLastPathComponent];
    
    NSString *tmpFolderpath = newFolderName;
    if ([tmpFolderpath hasPrefix:foldername] || [tmpFolderpath componentsSeparatedByString:@"/"].count > 1) {
        tmpFolderpath = newFolderName;
    }else{
        tmpFolderpath = [foldername stringByAppendingPathComponent:newFolderName];
    }
    
    NSError *error;
    BOOL rename = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        rename =  [[NSFileManager defaultManager] moveItemAtPath:folderPath toPath:tmpFolderpath error:&error];
    }else{
        rename = NO;
        error = [NSError errorWithDomain:@"NSErrorDomain" code:0 userInfo:@{@"info":[NSString stringWithFormat:@"file ‘%@' rename failed to %@,because the folder isn't exist",folderPath, newFolderName]}];
    }
    
    if (complete) {
        complete(rename, error);
    }
    
}

+ (NSString *)appDocumentsPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return documentsPath;
}

+ (NSString *)appCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return cachePath;
}

+ (NSString *)appLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return libraryPath;
}


+ (void)printFileListWithDocuments
{
    [MMFileManagerUtils printFileListWithFolderPath:[MMFileManagerUtils appDocumentsPath]];
}


+ (void)printFileListWithFolderPath:(NSString *)path
{
    NSAssert(path != nil, @"path can't be nil");
    NSError *error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    NSLog(@"FileList in (%@):\n%@",path == nil ? DocumentsDirectory : path,[directoryContents description]);
}


+ (BOOL)fileExistAtDocuments:(NSString *)filename {
    return [MMFileManagerUtils fileExist:[[MMFileManagerUtils appDocumentsPath] stringByAppendingPathComponent:filename]];
}

+ (BOOL)fileExist:(NSString *)filepath {
    
    NSAssert(filepath != nil, @"filepath can't be nil");
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}
@end
