### 设备相机相册使用简单总结

### 


<center>**********************大致功能如下*********************
 *****************************************************
 *  *
	 *  1. 打开相机拍照
	 *  2. 打开手机相册选取图片
	 *  3. 打开相机拍摄视频
	 *  4. 打开手机相册中选取视频
	 *  5. 保存图片到相册图库中
	 *  6. 保存视频到相册图库中
	 *  7. 保存图片到沙盒
	 *  8. 图片转换为Base64String
	 *  
	 * * * * 如果自定义覆盖页面的话，还需要以下功能需要去调用,具体用法见代码中的注释
 	 *  9. 切换前后摄像头
 	 * 10. 闪光灯打开与关闭
 	 * 11. 调用拍摄照片功能
 	 * 12. 开始拍摄视频
 	 * 13. 结束拍摄视频 
 *  *
 *****************************************************
 *</center>
 
 Usage
 ------
 [源码以及demo](https://github.com/MinMao-Hub/iOS_CommonTools/tree/master/MMCameraLibraryUtils)
 
 使用的时候只需要将`MMCameraLibraryUtils.{h,m}`两个文件拖入项目中即可
 
 具体使用方法可看下面介绍或者直接参考demo
 

 概述
 ------
 
 使用相机、相册可能是我们在开发过程中最常用到的一个点，基本上任何一个大大小小的APP中都用到了相机功能，简单一点的就设置用户头像、上传身份证信息、上传一些图片材料等，这些功能基本的拍照技能简单实现，再复杂一些就是自定义简单的相机界面；上述简单的功能只要使用`UIImagePickerController`即可实现。这里我主要总结的就是简单的这种使用方式，一般的需求也基本能满足，除非需要做相机相册啥的时候才可能会用到更复杂的功能。
 
 更复杂的相机使用就是一些图片处理相关的功能，诸如完全自定义相机界面、控制图片的大小、旋转角度、裁剪图片、改变拍摄区域、滤镜等；还有一些图像识别技术等等也是通过使用相机来是别的，这块的实现就需要你自己去定义相机、调用设备的硬件信息`AVCaptureSession `,网上一个例子如[kevinMkY/MKCustomCamera](https://github.com/kevinMkY/MKCustomCamera), 自己往后有时间的话也会研究一下。
 
 这里简单的总结了一下相机相关的简单使用，复杂的后续有时间再做研究与跟进
 
 里面主要使用`block`回调的方式将最终的`image`传递回来
 
 注意
 ------
 
 要使用设备相机拍照先要对应用开启相机、相册的访问权限，如果需要拍摄视频还需要开启麦克风访问权限。否则会直接crash。
 
 xml代码如下
 
 ```
 <key>NSPhotoLibraryUsageDescription</key>
	<string>App需要您的同意,才能访问相册</string>
	<key>NSCameraUsageDescription</key>
	<string>App需要您的同意,才能访问相机</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>App需要您的同意,才能访问麦克风</string>
 
 ```
 
 直接将上述xml复制粘贴到info.plist文件中即可。
 
 
 API
 ------
 
* 判断设备相机是否可用
 
```
- (BOOL) cameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
```

* 前置摄像头是否可用

```
- (BOOL) frontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
```

* 后置摄像头是否可用

```
- (BOOL) rearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
```

* 直接弹出一个`ActionSheet`提供你选择使用相机拍摄照片还是相册来选取照片

```
- (void)showActionSheetPicker:(void (^)(UIImage *image, NSDictionary *info))completeImage
                     onTarget:(UIViewController *)parentViewController
```


回调回来的具体信息如下：

```
image  照片的原图，即 [info objectForKey:UIImagePickerControllerOriginalImage]
 
info信息里面包含如下数据，具体按照实际情况获取，若果未设置图片可编辑(`[self.imagePicker setAllowsEditing:YES]`),编辑后的图片为空,可能会导致奔溃
{
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];      //照片的原图
 
    UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];            //裁剪后的图
 
    UIImage* crop = [info objectForKey:UIImagePickerControllerCropRect];               //图片裁剪后，剩下的图
 
    NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];                  //图片在相册中的url
 
    NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata]; //获取图片的metadata数据信息
}
```

* 调用相机拍照

```
- (void)capturePhoto:(void (^)(UIImage *image, NSDictionary *info))completeImage
    isUseFrontDevice:(BOOL)isFront
            onTarget:(UIViewController *)parentViewController
```

* 图册选取照片

```
- (void)selectImageFromLibrary:(void (^)(UIImage *image, NSDictionary *info))completeImage
                      onTarget:(UIViewController *)parentViewController
```

* 拍摄视频

```
- (void)captureVideoMaximumDuration:(NSTimeInterval)maximumDuration
                   isUseFrontDevice:(BOOL)isFront
                           onTarget:(UIViewController *)parentViewController
                    captureComplete:(void (^)(NSString *videoFilePath))completeVideo
```

* 图册选取视频

```
- (void)selectVideoFromLibrary:(void (^)(NSString *videoFilePath))completeVideo
                      onTarget:(UIViewController *)parentViewController
```

* 保存照片到相册

```
- (void)saveImageToAlbum:(UIImage *)image
```

* 保存视频到相册

```
- (void)saveVideoToAlbum:(NSString *)videoFilePath
```

* 保存图片到沙盒(Documents文件夹下面)

```
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
```

* 图片转换为Base64String

```
- (NSString *)base64StringFromImage:(UIImage *)image
```

* 切换前后摄像头

```
- (void)enchangeCameraDevice
```

* 闪光灯打开与关闭

```
- (void)flashModeOn
```

* 调用拍摄照片功能

```
- (void)takePhoto 
```

* 开始拍摄视频

```
- (void)startVideo
```

* 结束拍摄视频

```
- (void)stopVideo
```