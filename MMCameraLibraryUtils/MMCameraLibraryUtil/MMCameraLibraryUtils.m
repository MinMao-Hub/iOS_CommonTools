//
//  MMCameraLibraryUtils.m
//  DDWeexDemo
//
//  Created by 郭永红 on 2017/1/4.
//  Copyright © 2017年 郭永红. All rights reserved.
//

#import "MMCameraLibraryUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "DDUtils.h"

@interface MMCameraLibraryUtils()<UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, copy) void (^imagePickerBlock)(UIImage *image, NSDictionary *info);
@property (nonatomic, copy) void (^videoBlock)(NSString *videoFilePath);
@property (nonatomic, strong) UIViewController *parentViewController;

@end


@implementation MMCameraLibraryUtils

+ (instancetype)sharedInstance {
    static MMCameraLibraryUtils * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[MMCameraLibraryUtils alloc] init];
        
        shareInstance.imagePicker = [[UIImagePickerController alloc] init];
        shareInstance.imagePicker.delegate = (id)shareInstance;
        
    });
    return shareInstance;
}


// 判断设备是否有摄像头
- (BOOL) cameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL) frontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) rearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


- (void)showActionSheetPicker:(void (^)(UIImage *image, NSDictionary *info))completeImage onTarget:(UIViewController *)parentViewController {
    
    self.parentViewController = parentViewController;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择照片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self capturePhoto:^(UIImage *image, NSDictionary *info) {
            completeImage(image, info);
        } isUseFrontDevice:NO onTarget:parentViewController];
    }];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromLibrary:^(UIImage *image, NSDictionary *info) {
            completeImage(image, info);
        } onTarget:parentViewController];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        [actionSheet addAction:camera];
        [actionSheet addAction:photoLibrary];
        [actionSheet addAction:cancel];
    }
    else
    {
        [actionSheet addAction:photoLibrary];
        [actionSheet addAction:cancel];
    }
    
    [self.parentViewController presentViewController:actionSheet animated:YES completion:NULL];
}


- (void)capturePhoto:(void (^)(UIImage *image, NSDictionary *info))completeImage isUseFrontDevice:(BOOL)isFront onTarget:(UIViewController *)parentViewController {
    
    self.parentViewController = parentViewController;
    
    if (completeImage) {
        self.imagePickerBlock = completeImage;
    }
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //是否允许编辑照片
    [self.imagePicker setAllowsEditing:YES];
    
    //是否显示默认相机UI
    [self.imagePicker setShowsCameraControls:_photoOverFlowView ? NO : YES];
    [self.imagePicker setCameraDevice: (isFront && [self frontCameraAvailable]) ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear];
    [self.imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    [self.imagePicker setCameraOverlayView:_photoOverFlowView];
    
    //设置媒体类型
    [self.imagePicker setMediaTypes:@[(NSString *)kUTTypeImage]];
    
    //设置拍摄模式 （拍摄照片或者视频）
    [self.imagePicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
    [self showImagePicker];
}

- (void)selectImageFromLibrary:(void (^)(UIImage *image, NSDictionary *info))completeImage onTarget:(UIViewController *)parentViewController {
    
    self.parentViewController = parentViewController;
    
    if (completeImage) {
        self.imagePickerBlock = completeImage;
    }
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.imagePicker setAllowsEditing:YES];
    
    //媒体类型的话，就选常用的几种吧
    [self.imagePicker setMediaTypes:@[(NSString *)kUTTypeImage,
                                      (NSString *)kUTTypeJPEG,
                                      (NSString *)kUTTypeGIF,
                                      (NSString *)kUTTypePNG,
                                      (NSString *)kUTTypeQuickTimeImage,
                                      (NSString *)kUTTypeLivePhoto
                                      ]];
    
    [self showImagePicker];
    
}

- (void)captureVideoMaximumDuration:(NSTimeInterval)maximumDuration isUseFrontDevice:(BOOL)isFront onTarget:(UIViewController *)parentViewController captureComplete:(void (^)(NSString *videoFilePath))completeVideo {
    
    self.parentViewController = parentViewController;
    
    if (completeVideo) {
        self.videoBlock = completeVideo;
    }
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.imagePicker setAllowsEditing:YES];
    [self.imagePicker setShowsCameraControls:_videoOverFlowView ? NO : YES];
    [self.imagePicker setCameraDevice: (isFront && [self frontCameraAvailable]) ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear];
    [self.imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    [self.imagePicker setCameraOverlayView:_videoOverFlowView];
    // 设置录制视频的质量
    [self.imagePicker setVideoQuality:UIImagePickerControllerQualityTypeHigh];
    //设置最长摄像时间
    [self.imagePicker setVideoMaximumDuration:maximumDuration < 0.1 ? MAXFLOAT : maximumDuration];
    
    [self.imagePicker setMediaTypes:@[(NSString *)kUTTypeMovie]];
    
    //设置拍摄模式 （拍摄视频）
    [self.imagePicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModeVideo];
    
    [self showImagePicker];
}

- (void)selectVideoFromLibrary:(void (^)(NSString *videoFilePath))completeVideo onTarget:(UIViewController *)parentViewController {
    self.parentViewController = parentViewController;
    
    if (completeVideo) {
        self.videoBlock = completeVideo;
    }
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //媒体类型的话，就选常用的几种吧
    [self.imagePicker setMediaTypes:@[(NSString *)kUTTypeMovie,
                                      (NSString *)kUTTypeVideo,
                                      (NSString *)kUTTypeQuickTimeMovie,
                                      ]];
    
    [self showImagePicker];
}


- (void) showImagePicker {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     [self.parentViewController presentViewController:self.imagePicker animated:YES completion:NULL];
                 }
                 else
                 {
                     [self showAlert:@"媒体(相机、相册)访问未授权"];
                     return;
                 }
             }];
        }
            break;
            
        case AVAuthorizationStatusAuthorized:
            [self.parentViewController presentViewController:self.imagePicker animated:YES completion:NULL];
            break;
            
        default:
            [self showAlert:@"请先在系统设置中对该应用开启相机、相册访问权限"];
            break;
    }
}

- (void)showAlert:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [alert addAction:okAction];
    
    [self.parentViewController presentViewController:alert animated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
    
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        if ([info valueForKey:UIImagePickerControllerOriginalImage]) {
            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
            if (self.imagePickerBlock) {
                self.imagePickerBlock(image, info);
            }
        }else{
            if (self.videoBlock) {
                self.videoBlock([info valueForKey:UIImagePickerControllerMediaURL]);
            }
        }
    }else{
        if (picker.cameraCaptureMode == UIImagePickerControllerCameraCaptureModeVideo) {
            if (self.videoBlock) {
                self.videoBlock([info objectForKey:UIImagePickerControllerMediaURL]);
            }
        }else{
            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
            if (self.imagePickerBlock) {
                self.imagePickerBlock(image, info);
            }
        }
    }
    
    
    NSLog(@"%@",info.description);
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    @try {
        [picker dismissViewControllerAnimated:YES completion:NULL];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}


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

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    //获取沙盒Documents路径
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //定义图片存储路径
    NSString *imageFullPath = [DocumentsPath stringByAppendingPathComponent:imageName];
    
    //将图片数据写入文件
    [imageData writeToFile:imageFullPath atomically:NO];
}

- (void)enchangeCameraDevice {
    
    if (self.imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else
    {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}


- (void)flashModeOn {
    
    if (self.imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto || self.imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    else
    {
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}

- (void)takePhoto {
    [self.imagePicker takePicture];
}

- (void)startVideo {
    [self.imagePicker startVideoCapture];
}

- (void)stopVideo {
    [self.imagePicker stopVideoCapture];
}

- (NSString *)base64StringFromImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    return [self base64forData:imageData];
}

- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
