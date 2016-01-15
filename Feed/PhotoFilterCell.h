//
//  PhotoFilterCell.h
//  Feed
//
//  Created by Adam on 1/15/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const PhotoFilterCellIdentifier;

@interface PhotoFilterCell : UICollectionViewCell

@property (strong, nonatomic, readonly) UIImage *image;

- (void)configureForImage:(UIImage *)image withFilter:(NSString *)filter;

@end
