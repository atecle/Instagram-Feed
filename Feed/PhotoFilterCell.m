//
//  PhotoFilterCell.m
//  Feed
//
//  Created by Adam on 1/15/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "PhotoFilterCell.h"

NSString * const PhotoFilterCellIdentifier = @"PhotoFilterCell";

@interface PhotoFilterCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@end

@implementation PhotoFilterCell


- (void)configureForImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

@end
