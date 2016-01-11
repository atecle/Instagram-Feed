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
@property (strong, nonatomic, readonly) NSURL *avatarURL, *imageURL;
@property (nonatomic, readonly) NSInteger likes;

+ (NSArray *) postsFromPostDictionaries:(NSArray *)postDictionaries;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end