###UIImagePickerController简单剖析

概述
------

`UIImagePickerController`是苹果官方提供的一套相机、相册处理的方式。
 
使用`UIImagePickerController `你可以调用相机拍摄照片视频、调用相册功能。
 
下面详细介绍一下其相关的属性以及API，其中已经遗弃(DEPRECATED)的属性和方法将不再赘述

相关属性介绍
------

###1.***`@property(nonatomic)           UIImagePickerControllerSourceType     sourceType;                                                        // default value is UIImagePickerControllerSourceTypePhotoLibrary.`***

资源类型，决定相机启用以后要跳转到哪个界面（相机拍照、照片图库、相册）

如下几种值

```
typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
    UIImagePickerControllerSourceTypePhotoLibrary,    //照片图库
    UIImagePickerControllerSourceTypeCamera,          //相机
    UIImagePickerControllerSourceTypeSavedPhotosAlbum //相册
}
```

###2.***`@property(nonatomic,copy)      NSArray<NSString *>                   *mediaTypes;//默认值是 @[(NSString *)kUTTypeImage].`***

媒体类型，在相册模式的时候可以做一些筛选，筛选图片、视频、livephoto等各种不同类型的媒体。详细可设置参数见`MobileCoreServices.framework`的`<MobileCoreServices/UTCoreTypes.h>`
 
###3.***`@property(nonatomic)           BOOL                                  allowsImageEditing`***

拍照结束后的是否允许编辑

###4.***`@property(nonatomic)           NSTimeInterval                        videoMaximumDuration`***

拍摄视频时的最大拍摄时间

###5.***`@property(nonatomic)           UIImagePickerControllerQualityType    videoQuality `***
拍摄视频的质量

有如下几种值

```
typedef NS_ENUM(NSInteger, UIImagePickerControllerQualityType) {
    UIImagePickerControllerQualityTypeHigh = 0,       //最高质量
    UIImagePickerControllerQualityTypeMedium = 1,     //中质量，适合用WIFI传输
    UIImagePickerControllerQualityTypeLow = 2,        //低质量，可以用手机网络传输
    UIImagePickerControllerQualityType640x480 = 3,    // VGA质量  640x480 
    UIImagePickerControllerQualityTypeIFrame1280x720 = 4,
    UIImagePickerControllerQualityTypeIFrame960x540 = 5,
}
```


###6.***`@property(nonatomic)           BOOL                                  showsCameraControls`***

是否显示系统默认相机UI界面（包括拍摄按钮、前后摄像头切换、闪光灯开关），默认为YES（显示系统默认UI），如果你需要自定义该界面，则需要隐藏该UI，设置自定义的UI给cameraOverlayView

###7.***`@property(nullable, nonatomic,strong) __kindof UIView                *cameraOverlayView`***

自定义相机遮盖层，可以自定义拍照框、拍照按钮、闪关灯、切换前后摄像头等UI，设置该属性是，同事需要将属性`showsCameraControls `设置为`NO`。


###8.***`@property(nonatomic)           CGAffineTransform                     cameraViewTransform`***  

设置相机界面旋转

###9.***`@property(nonatomic) UIImagePickerControllerCameraCaptureMode cameraCaptureMode`***  

拍摄模式（拍摄照片或者拍摄视频）

下面两种值

```
typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraCaptureMode) {
    UIImagePickerControllerCameraCaptureModePhoto, //拍摄照片
    UIImagePickerControllerCameraCaptureModeVideo  //拍摄视频
}
```

###10.***`@property(nonatomic) UIImagePickerControllerCameraDevice      cameraDevice`***

设置使用哪个硬件设备，前置摄像头或者后置摄像头

如下两种可选值

```
typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraDevice) {
    UIImagePickerControllerCameraDeviceRear,  //后置摄像头
    UIImagePickerControllerCameraDeviceFront  //前置摄像头
}
```


###11.***`@property(nonatomic) UIImagePickerControllerCameraFlashMode   cameraFlashMode`***

`UIImagePickerControllerCameraFlashMode`  闪光灯模式

关闭、自动、打开

如下两种可选值

```
typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraFlashMode) {
    UIImagePickerControllerCameraFlashModeOff  = -1, //关闭
    UIImagePickerControllerCameraFlashModeAuto = 0,  //自动
    UIImagePickerControllerCameraFlashModeOn   = 1   //打开
}
```

相关API方法介绍
------
 
###1.***`- (void)takePicture`***  

调用拍摄功能，即相机快门按钮所拥有的事件

###2.***`- (BOOL)startVideoCapture`***  

开始拍摄视频

###3.***`- (void)stopVideoCapture`***  

结束拍摄视频


`UIImagePickerControllerDelegate`代理方法介绍
------


###1.***`- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info`***

拍摄（照片、视频）、相机选取（照片、视频）结束之后的回调。

info里面的具体参数如下：

* `[info objectForKey:UIImagePickerControllerOriginalImage];`    
 	照片的原图
* `[info objectForKey:UIImagePickerControllerEditedImage];`   
	裁剪后的图
* `[info objectForKey:UIImagePickerControllerCropRect];` 
	图片裁剪后，剩下的图
* `[info objectForKey:UIImagePickerControllerMediaURL]`    
	图片在相册中的url
* `[info objectForKey:UIImagePickerControllerMediaMetadata];`    
	获取图片的metadata数据信息



可根据`picker.sourceType`来判断是相机拍摄之后的结果还是照片图库选择之后的结果,如果是照片图库的话，根据`info`里面的参数来判断是否是图片还是视频；如果是相机的话，再根据`picker.cameraCaptureMode`来判断拍摄的是图片还是视频，区别处理`info`信息，具体代码如下

```
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
    
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        if ([info valueForKey:UIImagePickerControllerOriginalImage]) {
            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage]; //原始图片
            //处理图片信息`info` ...
            
        }else{
		  	  //处理视频信息 `info` ...
		  	  NSLog(@"视频URL是：%@",[info valueForKey:UIImagePickerControllerMediaURL]);
        }
    }else{
        if (picker.cameraCaptureMode == UIImagePickerControllerCameraCaptureModeVideo) {
			  //处理视频信息 `info`
		  	  NSLog(@"视频URL是：%@",[info valueForKey:UIImagePickerControllerMediaURL]);
        }else{
            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage]; //原始图片
			  //处理图片信息`info`   ...
        }
    }
    
    
    NSLog(@"%@",info.description);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

```

PS：如果只是单单的拍照或者拍视频的话，上面的判断皆可以修改为你自己需要的就行


###2.***`- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker`***

相机界面点击取消按钮的回调

里面写上如下代码即可退出相机界面

```
[imagePicker dismissViewControllerAnimated:YES completion:nil];
```


相册存储相关API
------

###1.***`UIKIT_EXTERN void UIImageWriteToSavedPhotosAlbum(UIImage *image, __nullable id completionTarget, __nullable SEL completionSelector, void * __nullable contextInfo)`***

将图片保存到相册

简单的使用：

```
- (void)saveImageToAlbum:(UIImage *)image {
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

//保存照片成功后的回调
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    
    if (!error) {
        NSLog(@"保存图片到相册成功");
    }else {
        NSLog(@"保存图片到相册发生错误，错误信息%@",error);
    }
}

```


###2.***`UIKIT_EXTERN void UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, __nullable id completionTarget, __nullable SEL completionSelector, void * __nullable contextInfo)`***

将视频保存到相册

简单的使用：

```
- (void)saveVideoToAlbum:(NSString *)videoFilePath {
    
    UISaveVideoAtPathToSavedPhotosAlbum(videoFilePath, self, @selector(videoSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)videoSavedToPhotosAlbum:(NSString *)videoPath didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"保存视频到相册成功");
    }else {
        NSLog(@"保存视频到相册发生错误，错误信息%@",error);
    }
}
```


简单的使用代码如下：
------
 
 ```objc
 - (void)showCamera {
   	 UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	 imagePicker.delegate = (id)shareInstance;	
	 imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //是否允许编辑照片
    [imagePicker setAllowsEditing:YES];
    
    //是否显示默认相机UI
    [imagePicker setShowsCameraControls:YES];
    [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    [imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    
    //设置媒体类型
    [self.imagePicker setMediaTypes:@[(NSString *)kUTTypeImage]];
    
    //设置拍摄模式 （拍摄照片或者视频）
    [self.imagePicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
	 
	 //[self presentViewController:imagePicker animated:YES completion:NULL];
	 //需要请求权限，所以上一行行代码替换为：
	 [self showImagePicker];
 }
 
 ```
 
 ***PS：需要注意一点，在使用之前要向设备请求相机、相册权限，所以不能直接present，需要加上下面代码来请求权限***
 
 ```
 - (void) showImagePicker {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                 if(granted){
                     [self presentViewController:imagePicker animated:YES completion:NULL];
                 }else{
                     [self showAlert:@"媒体(相机、相册)访问未授权"];
                     return;
                 }
             }];
        }
            break;
            
        case AVAuthorizationStatusAuthorized:
            [self presentViewController:imagePicker animated:YES completion:NULL];
            break;
        default:
            [self showAlert:@"请先在系统设置中对该应用开启相机、相册访问权限"];
            break;
    }
}
 ```
 ***PS：还需要注意一点，在使用之前在`info.plist`中添加相机请求的相关参数，`xml`代码如下***
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



