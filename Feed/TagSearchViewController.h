//
//  TagSearchViewController.h
//  Feed
//
//  Created by Adam on 1/12/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIClient.h"
#import "Post.h"
#import "PostTableCell.h"

extern NSString * const TagSearchViewControllerIdentifier;

@interface TagSearchViewController : UIViewController

- (void)setAPIClient:(APIClient *)client;

@end
