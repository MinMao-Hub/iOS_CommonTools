//
//  MMCameraLibraryUtils.h
//  DDWeexDemo
//
//  Created by 郭永红 on 2017/1/4.
//  Copyright © 2017年 郭永红. All rights reserved.
//


/*****************************************************
 *****************************************************
 *
 *   1. 打开相机拍照
 *   2. 打开手机相册选取图片
 *   3. 打开相机拍摄视频
 *   4. 打开手机相册中选取视频
 *   5. 保存图片到相册图库中
 *   6. 保存视频到相册图库中
 *   7. 保存图片到沙盒
 *
 * * * 如果自定义覆盖页面的话，还需要以下功能需要去调用,具体用法见代码中的注释
 *   8. 切换前后摄像头
 *   9. 闪光灯打开与关闭
 *
 *****************************************************
 */


#import <Foundation/Foundation.h>

@interface MMCameraLibraryUtils : NSObject

@property (nonatomic, strong) UIView *photoOverFlowView;   //拍照时自定义的覆盖视图
@property (nonatomic, strong) UIView *videoOverFlowView;    //拍视频时自定义的覆盖视图


/**
 单例创建该对象

 @return MMCameraLibraryUtils对象
 */
+ (instancetype)sharedInstance;


/**
 判断设备是否有摄像头 (现在的手机摄像头是必须有的，所以该方法基本无用)

 @return 是否可用
 */
- (BOOL) cameraAvailable;


/**
 前置摄像头是否可用

 @return 是否可用
 */
- (BOOL) frontCameraAvailable;


/**
 后置摄像头是否可用

 @return 是否可用
 */
- (BOOL) rearCameraAvailable;



/**
 弹出一个简单的ActionSheet来选择相册或者拍照来获取图片

 @param completeImage 结束后的回调
 *  *
    *
 
    #param image  照片的原图
 
    #info信息里面包含如下数据，具体按照实际情况获取，若果未设置图片可编辑(`[self.imagePicker setAllowsEditing:YES]`),编辑后的图片为空,可能会导致奔溃
    {
        UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];      //照片的原图
     
        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];            //裁剪后的图
     
        UIImage* crop = [info objectForKey:UIImagePickerControllerCropRect];               //图片裁剪后，剩下的图
     
        NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];                  //图片在相册中的url
     
        NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata]; //获取图片的metadata数据信息
    }
 
 *  *
    *
 @param parentViewController 父控制器（需要弹出picker的控制器）
 */
- (void)showActionSheetPicker:(void (^)(UIImage *image, NSDictionary *info))completeImage onTarget:(UIViewController *)parentViewController;



/**
 1. 调用相机拍摄照片

 @param completeImage 拍照后的回调: 回调参数同上
 @param isFront 是否使用前置摄像头
 @param parentViewController 父控制器
 */
- (void)capturePhoto:(void (^)(UIImage *image, NSDictionary *info))completeImage isUseFrontDevice:(BOOL)isFront onTarget:(UIViewController *)parentViewController;



/**
 2. 调用手机相册选取图片

 @param completeImage 选取后的回调: 回调参数同上上
 @param parentViewController 父控制器
 */
- (void)selectImageFromLibrary:(void (^)(UIImage *image, NSDictionary *info))completeImage onTarget:(UIViewController *)parentViewController;



/**
 3. 调用相机拍摄视频

 @param maximumDuration 拍摄最长时间 （如果不想限制时间，直接传 0 ）
 @param isFront 是否使用前置摄像头
 @param parentViewController 父控制器
 @param completeVideo 选取完成回调: 参数为视频文件的绝对路径
 */
- (void)captureVideoMaximumDuration:(NSTimeInterval)maximumDuration isUseFrontDevice:(BOOL)isFront onTarget:(UIViewController *)parentViewController captureComplete:(void (^)(NSString *videoFilePath))completeVideo;



/**
 4. 从手机相册中选取视频

 @param completeVideo 选取完成回调: 参数为视频文件的绝对路径
 @param parentViewController 父控制器
 */
- (void)selectVideoFromLibrary:(void (^)(NSString *videoFilePath))completeVideo onTarget:(UIViewController *)parentViewController;



/**
 5. 保存图片到相册中

 @param image image对象
 */
- (void)saveImageToAlbum:(UIImage *)image;



/**
 6. 保存视频到相册中

 @param videoFilePath 视频绝对路径
 */
- (void)saveVideoToAlbum:(NSString *)videoFilePath;


/**
 7. 保存图片到沙盒
 
 @param videoFilePath 视频绝对路径
 */
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;


/**
 8. 切换前后摄像头
 */
- (void)enchangeCameraDevice;



/**
 9. 打开与关闭闪光灯

 */
- (void)flashModeOn;



/**
 如果是自定义相机UI的话，还需要开放该方法来调用拍摄
 */
- (void)takePhoto;


/**
 视频拍摄也一样，如果是自定义相机UI的话，还需要开放如下方法来调用拍摄开始与结束
 */
- (void)startVideo;

- (void)stopVideo;

- (NSString *)base64StringFromImage:(UIImage *)image;
@end
