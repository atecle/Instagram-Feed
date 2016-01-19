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

@interface PhotoViewController() <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet CameraView *cameraView;


@end


@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    self.title = NSLocalizedString(@"Filters", nil);
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(Margin, Margin, Margin, Margin)];
    flowLayout.itemSize = CGSizeMake(self.collectionView.bounds.size.width/9, self.collectionView.bounds.size.height - (3*Margin));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoFilterCell class]) bundle:nil] forCellWithReuseIdentifier:PhotoFilterCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
   // [cell configureForImage:self.image withFilter:NSLocalizedString(@"Filter", nil)];
    
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
