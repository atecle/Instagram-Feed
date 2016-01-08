//
//  Post.h
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Post : NSObject

@property (strong, nonatomic, readonly) NSString *userName, *caption;
@property (strong, nonatomic, readonly) UIImage *image;
@property (copy, nonatomic, readonly) NSArray *comments;
@property (nonatomic, readonly) NSInteger likes;

@end