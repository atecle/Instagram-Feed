//
//  CameraView.m
//  Feed
//
//  Created by Adam on 1/19/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "CameraView.h"


@interface CameraView()

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (nonatomic) BOOL hasImage;
@property (strong, nonatomic) UIImage *image;

@end

@implementation CameraView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureCameraButton];
    
    [self configureCaptureSession];
}

- (void)configureCameraButton
{
    self.cameraButton.layer.cornerRadius = self.cameraButton.bounds.size.width / 2.0;

}

- (void)configureCaptureSession
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *inputError;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&inputError];
    
    if (captureInput == nil)
    {
        NSLog(@"%@", inputError);
        return;
    }
    
    if ([self.captureSession canAddInput:captureInput])
    {
        [self.captureSession addInput:captureInput];
    }
    else
    {
        NSLog(@"Couldn't add input");
        return;
    }
    
    AVCaptureStillImageOutput *captureOutput = [[AVCaptureStillImageOutput alloc] init];
    
    if ([self.captureSession canAddOutput:captureOutput])
    {
        [self.captureSession addOutput:captureOutput];
        self.captureOutput = captureOutput;
    }
    else
    {
        NSLog(@"Couldn't add output.");
        return;
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    
    previewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:previewLayer];
    
}
- (IBAction)cameraButtonPressed:(id)sender
{
    AVCaptureConnection *stillImageConnection = nil;
    
    for (AVCaptureConnection *connection in self.captureOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                stillImageConnection = connection;
            }
        }
    }
    
    if (stillImageConnection == nil) return;
    
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSLog(@"Test");
    }];
    
}

@end
