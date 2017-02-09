//
//  cameraOverFlowView.h
//  MMCameraLibraryUtils
//
//  Created by 郭永红 on 2017/2/8.
//  Copyright © 2017年 郭永红. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraOverFlowViewDelegate <NSObject>

@optional
- (void)capture:(UIButton *)button;

- (void)flashOn;

- (void)exchangeDevide;

- (void)cancelCapture;

@end

@interface CameraOverFlowView : UIView

@property (nonatomic, weak) id<CameraOverFlowViewDelegate> overFlowDelegate;

@end


