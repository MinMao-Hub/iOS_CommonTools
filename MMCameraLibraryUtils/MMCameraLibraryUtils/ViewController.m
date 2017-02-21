//
//  ViewController.m
//  MMCameraLibraryUtils
//
//  Created by 郭永红 on 2017/2/8.
//  Copyright © 2017年 郭永红. All rights reserved.
//

#import "ViewController.h"
#import "MMCameraLibraryUtils.h"

#import "CameraOverFlowView.h"

#import <UIKit/UIKit.h>

#import <MBProgressHUD/MBProgressHUD.h>


@interface ViewController ()<CameraOverFlowViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@property (strong, nonatomic) CameraOverFlowView *overFlowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSArray *nibViewArray = [[NSBundle mainBundle] loadNibNamed:@"CameraOverFlowView" owner:nil options:nil];
    
    _overFlowView = [nibViewArray objectAtIndex:0];
    
    [_overFlowView setFrame:[[MMCameraLibraryUtils sharedInstance] imagePicker].view.bounds];
    
    _overFlowView.overFlowDelegate = self;
    
}


//弹出一个简单的Alert来选取照片或者拍摄照片
- (IBAction)actionToSelectPhoto:(id)sender {
    [[MMCameraLibraryUtils sharedInstance] showActionSheetPicker:^(UIImage *image, NSDictionary *info) {
        [_testImageView setImage:image];
        
    } onTarget:self];
}

- (IBAction)openCameraGetPhoto:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[MMCameraLibraryUtils sharedInstance] capturePhoto:^(UIImage *image, NSDictionary *info) {
        
        UIImage *aImage = [weakSelf subImageFromImage:image origin:CGPointMake(0, 0) size:CGSizeMake(357, 221)];
        
        [_testImageView setImage:aImage];
    } isUseFrontDevice:NO onTarget:self];
}

- (IBAction)openAlbumLibraryGetPhoto:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[MMCameraLibraryUtils sharedInstance] selectImageFromLibrary:^(UIImage *image, NSDictionary *info) {
        UIImage *aImage = [weakSelf subImageFromImage:image origin:CGPointMake(30, 30) size:CGSizeMake(357, 221)];
        
            [_testImageView setImage:aImage];

    } onTarget:self];
}

- (IBAction)openCameraGetVideo:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[MMCameraLibraryUtils sharedInstance] captureVideoMaximumDuration:60.0 isUseFrontDevice:NO onTarget:self captureComplete:^(NSString *videoFilePath) {
        NSLog(@"%@",videoFilePath);
        [weakSelf showToastWithMessage:[NSString stringWithFormat:@"视频路径为%@",videoFilePath] inView:weakSelf.view];
    }];
}

- (IBAction)openAlbumLibrarygetVideo:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [[MMCameraLibraryUtils sharedInstance] selectVideoFromLibrary:^(NSString *videoFilePath) {
        NSLog(@"%@",videoFilePath);
        
        [weakSelf showToastWithMessage:[NSString stringWithFormat:@"视频路径为%@",videoFilePath] inView:weakSelf.view];
        
    } onTarget:self];
}


//弹出自定义的相机UI
- (IBAction)presentSelfDefineCamera:(UIButton *)sender {
    
    
    if ([sender.titleLabel.text isEqualToString:@"设置自定义UI"]) {

        [sender setTitle:@"取消自定义UI" forState:UIControlStateNormal];
        [[MMCameraLibraryUtils sharedInstance] setPhotoOverFlowView:self.overFlowView];
        [[MMCameraLibraryUtils sharedInstance] setVideoOverFlowView:self.overFlowView];
        
    }else{
        
        [sender setTitle:@"设置自定义UI" forState:UIControlStateNormal];
        [[MMCameraLibraryUtils sharedInstance] setPhotoOverFlowView:nil];
        [[MMCameraLibraryUtils sharedInstance] setVideoOverFlowView:nil];
        
    }
}

- (void)showToastWithMessage:(NSString *)mesage
{
    UIWindow *winodw = [UIApplication sharedApplication].keyWindow;
    [self showToastWithMessage:mesage inView:winodw];
}


- (void)showToastWithMessage:(NSString *)mesage inView:(UIView*)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = mesage;
    hud.userInteractionEnabled = YES;
    [hud hide:NO afterDelay:3.];
}


#pragma mark - CameraOverFlowViewDelegate

- (void)capture:(UIButton *)button
{
    
    
    if ([[MMCameraLibraryUtils sharedInstance] imagePicker].cameraCaptureMode == UIImagePickerControllerCameraCaptureModeVideo) {
        
        if ([button.titleLabel.text isEqualToString:@"点击拍摄"]) {
            [button setTitle:@"结束拍摄" forState:UIControlStateNormal];
            [[MMCameraLibraryUtils sharedInstance] startVideo];
        }else{
            [button setTitle:@"点击拍摄" forState:UIControlStateNormal];
            [[MMCameraLibraryUtils sharedInstance] stopVideo];
        }
    }else{
        [[MMCameraLibraryUtils sharedInstance] takePhoto];
    }
}

- (void)flashOn
{
    [[MMCameraLibraryUtils sharedInstance] flashModeOn];
}

- (void)exchangeDevide
{
    [[MMCameraLibraryUtils sharedInstance] enchangeCameraDevice];
}

- (void)cancelCapture
{
    [[[MMCameraLibraryUtils sharedInstance] imagePicker] dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)subImageFromImage:(UIImage *)image origin:(CGPoint)location size:(CGSize)subSize{
    
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(location.x, location.y, subSize.width * screenScale, subSize.height * screenScale));
    UIImage *subImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return subImage;
}


@end
