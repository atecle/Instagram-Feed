//
//  CameraView.h
//  Feed
//
//  Created by Adam on 1/19/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CameraView;

@protocol CameraViewDelegate <NSObject>

- (void)cameraView:(CameraView *)cameraView didCaptureImage:(UIImage *)image;
- (void)cameraViewTakeAgainButtonPressed:(CameraView *)cameraView;

- (void)cameraViewDidEnterCaptureMode:(CameraView *)cameraView;
- (void)cameraViewDidExitCaptureMode:(CameraView *)cameraView;

@end

@interface CameraView : UIView

@property (weak, nonatomic) id<CameraViewDelegate> delegate;

- (void)startCaptureSession;

@end
