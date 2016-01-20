//
//  CameraView.m
//  Feed
//
//  Created by Adam on 1/19/16.
//  Copyright © 2016 ;. All rights reserved.
//

#import "CameraView.h"


@interface CameraView()

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) UIButton *cameraButton;
@property (strong, nonatomic) UIView *cameraView;
@property (nonatomic) BOOL hasImage;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@end

@implementation CameraView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureCameraView];
    [self configureCameraButton];
    [self configureTakeAgainButton];
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
    [self addConstraint:rightConstraint];
    [self addConstraint:bottomConstraint];
    self.cameraView = cameraView;
    
}

- (void)configureCameraButton
{
    UIButton *cameraButton = [[UIButton alloc] init];
    cameraButton.layer.masksToBounds = NO;
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"white-camera-icon"] forState:UIControlStateNormal];
    [cameraButton layoutIfNeeded];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraButton];
    self.cameraButton = cameraButton;
    
    NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:self.cameraView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.cameraButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cameraButton attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
    
    [self addConstraint:centerConstraint];
    [self addConstraint:bottomConstraint];
    [self addConstraint:heightConstraint];
    [self addConstraint:widthConstraint];
}

- (void)configureTakeAgainButton
{
    UIButton *takeAgainButton = [[UIButton alloc] init];
    takeAgainButton.layer.masksToBounds = NO;
    takeAgainButton.translatesAutoresizingMaskIntoConstraints = NO;
    [takeAgainButton setTitle:NSLocalizedString(@"Take Again", nil) forState:UIControlStateNormal];
    
    [takeAgainButton addTarget:self action:@selector(takeAgainButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
        NSDictionary *newSettings =
        @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
        self.captureOutput.outputSettings = newSettings;
    }
    else
    {
        NSLog(@"Couldn't add output.");
        return;
    }
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.cameraView.layer addSublayer:self.previewLayer];
}

- (void)startCaptureSession
{
    [self.captureSession startRunning];
    [self.delegate cameraViewDidEnterCaptureMode:self];
}


- (void)cameraButtonPressed
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
        
        UIImage *image = [self imageFromSampleBuffer:imageDataSampleBuffer];
        self.cameraButton.hidden = YES;
        
        [self.delegate cameraView:self didCaptureImage:image];
        [self displayCapturedImage:image];
        [self.delegate cameraViewDidExitCaptureMode:self];
    }];
}

- (void)takeAgainButtonPressed
{
    [self.imageView removeFromSuperview];
    self.cameraButton.hidden = NO;
}

- (void)displayCapturedImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView = imageView;
    imageView.frame = self.cameraView.bounds;
    [self.cameraView addSubview:imageView];
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image =  [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

@end
