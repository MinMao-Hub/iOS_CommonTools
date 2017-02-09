//
//  cameraOverFlowView.m
//  MMCameraLibraryUtils
//
//  Created by 郭永红 on 2017/2/8.
//  Copyright © 2017年 郭永红. All rights reserved.
//

#import "CameraOverFlowView.h"

@interface CameraOverFlowView ()

@property (weak, nonatomic) IBOutlet UIButton *captureBtn;  //拍照

@property (weak, nonatomic) IBOutlet UIButton *flashBtn; //闪光灯

@property (weak, nonatomic) IBOutlet UIButton *exchangeDevideBtn;  //切换前后摄像头



@end

@implementation CameraOverFlowView

- (IBAction)flashBtnClicked:(id)sender {
    
    [self.overFlowDelegate flashOn];
}

- (IBAction)exchangeDevideBtnClicked:(id)sender {
    [self.overFlowDelegate exchangeDevide];
}

- (IBAction)captureBtnClicked:(id)sender {
    
    [self.overFlowDelegate capture:sender];
}

- (IBAction)cancel:(id)sender {
    
    [self.overFlowDelegate cancelCapture];
}

@end
