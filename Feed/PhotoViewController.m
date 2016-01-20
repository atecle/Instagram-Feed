//
//  CameraViewController.m
//  Feed
//
//  Created by Adam on 1/15/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "PhotoViewController.h"

NSString * const PhotoViewControllerIdentifier = @"PhotoViewController";

static NSInteger Margin = 20;

@interface PhotoViewController() <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CameraViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet CameraView *cameraView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottomConstraint;


@end


@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Filters", nil);
    
    self.cameraView.delegate = self;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *testButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Test", nil) style:UIBarButtonItemStyleDone target:self action:@selector(hideFilterDrawer)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = testButton;
  
    [self configureFilterDrawer];
    [self.cameraView layoutIfNeeded];
    [self hideFilterDrawer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureFilterDrawer
{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(Margin, Margin, Margin, Margin)];
    flowLayout.itemSize = CGSizeMake(self.collectionView.bounds.size.width/9, self.collectionView.bounds.size.height - (3*Margin));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoFilterCell class]) bundle:nil] forCellWithReuseIdentifier:PhotoFilterCellIdentifier];
}

- (void)hideFilterDrawer
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.collectionViewBottomConstraint.constant = -1 * self.collectionView.bounds.size.height;
                         [self.view layoutIfNeeded];
                     }
                         completion:nil];
}

- (void)showFilterDrawer
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.collectionViewBottomConstraint.constant = 0;
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (IBAction)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CameraViewDelegate

- (void) cameraViewDidEnterCaptureMode:(CameraView *)cameraView
{
    
}

- (void)cameraViewDidExitCaptureMode:(CameraView *)cameraView
{
    
}

- (void)cameraView:(CameraView *)cameraView didCaptureImage:(UIImage *)image
{
    self.image = image;
    [self.collectionView reloadData];
    [self showFilterDrawer];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
//    self.image = chosenImage;
//    [self.imageView setImage:self.image];
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoFilterCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:PhotoFilterCellIdentifier forIndexPath:indexPath];
    
   [cell configureForImage:self.image withFilter:NSLocalizedString(@"Filter", nil)];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.imageView setImage:self.image];
}

@end
