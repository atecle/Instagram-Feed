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
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) UIButton *cameraButton;
@property (strong, nonatomic) UIView *cameraView;
@property (nonatomic) BOOL hasImage;
@property (strong, nonatomic) UIImage *image;

@end

@implementation CameraView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureCameraView];
  // [self configureCameraButton];
    
    [self configureCaptureSession];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.previewLayer.frame = self.cameraView.bounds;
}


- (void)configureCameraView
{
    UIView *cameraView = [[UIView alloc] init];
    cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:cameraView];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cameraView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cameraView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cameraView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cameraView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];
    [self  addConstraint:rightConstraint];
    [self addConstraint:bottomConstraint];
    //[cameraView setBackgroundColor:[UIColor blackColor]];
    self.cameraView = cameraView;
    
}

- (void)configureCameraButton
{
    UIButton *cameraButton = [[UIButton alloc] init];
    [self addSubview:cameraButton];
    self.cameraButton = cameraButton;
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.cameraView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cameraButton attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.cameraView addConstraint:topConstraint];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
 
        [self.captureSession startRunning];
        [self.delegate cameraViewDidEnterCaptureMode:self];
    });
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.cameraView.layer addSublayer:self.previewLayer];
   
    
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
        
        [self.delegate cameraViewDidExitCaptureMode:self];
        NSLog(@"Test");
    }];
    
}

@end
