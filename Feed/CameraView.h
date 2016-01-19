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

@end

@interface CameraView : UIView

@end
