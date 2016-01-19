//
//  PostTableCell.m
//  Feed
//
//  Created by Adam on 1/11/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "PostTableCell.h"

NSString * const PostCellIdentifier = @"PostCell";

@interface PostTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *actionSheetButton;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesTextLabel;

@end

@implementation PostTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatarPhotoImageView.layer.cornerRadius = self.avatarPhotoImageView.bounds.size.width / 2.0;
    self.avatarPhotoImageView.layer.masksToBounds = YES;
}


- (void) configureForPost:(Post *)post
{
    self.userNameLabel.text = post.userName;
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", (long)post.likes];
    if (post.likes == 1)
    {
        self.likesTextLabel.text = NSLocalizedString(@"like", nil);
    }
    else
    {
        self.likesTextLabel.text = NSLocalizedString(@"likes", nil);
    }
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

- (IBAction)actionSheetButtonPressed:(id)sender
{
    [self.delegate postTableCellDidPressActionButton:self];
}

@end
