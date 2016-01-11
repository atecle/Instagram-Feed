//
//  PostTableCell.h
//  Feed
//
//  Created by Adam on 1/11/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostTableCell : UITableViewCell

@property (weak, nonatomic) Post *post;

- (void) configureForPost:(Post *)post;
- (void)setPhoto:(UIImage *)photo forPost:(Post *)post;
- (void)setAvatarPhoto:(UIImage *)avatarPhoto forPost:(Post *)post;

@end
