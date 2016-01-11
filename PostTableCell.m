//
//  PostTableCell.m
//  Feed
//
//  Created by Adam on 1/11/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "PostTableCell.h"

@interface PostTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation PostTableCell

- (void) configureForPost:(Post *)post
{
    self.userNameLabel.text = post.userName;
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", (long)post.likes];
}

- (void) setPost:(Post *)post
{
    _post = post;
    [self configureForPost:post];
}

- (void)setPhoto:(UIImage *)photo forPost:(Post *)post
{
    if ([self.post.imageURL isEqual:post.imageURL])
    {
        [self.photoImageView setImage:photo];
    }
}

- (void)setAvatarPhoto:(UIImage *)avatarPhoto forPost:(Post *)post
{
    if ([self.post.avatarURL isEqual:post.avatarURL])
    {
        [self.avatarPhotoImageView setImage:avatarPhoto];
    }
}

- (void) prepareForReuse
{
    [self.photoImageView setImage:nil];
    [self.avatarPhotoImageView setImage:nil];
}

@end
