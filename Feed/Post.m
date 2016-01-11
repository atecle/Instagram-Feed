//
//  Post.m
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "Post.h"

@implementation Post

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init]))
    {
        _userName = dictionary[@"user"][@"username"];
        _avatarURL = [NSURL URLWithString: dictionary[@"user"][@"profile_picture"]];
        _imageURL = [NSURL URLWithString:dictionary[@"images"][@"standard_resolution"][@"url"]];
        _caption = dictionary[@"caption"];
        _likes = [dictionary[@"likes"][@"count"] integerValue];
    }
    
    return  self;
}

+ (NSArray *) postsFromPostDictionaries: (NSArray *)postDictionaries
{
    NSMutableArray *posts = [NSMutableArray array];
    
    for (NSDictionary *dictionary in postDictionaries)
    {
        Post *post = [[Post alloc] initWithDictionary:dictionary];
        [posts addObject:post];
    }
    
    return [posts copy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Post:%p, username=%@, imageURL=%@>", self, self.userName, self.imageURL];
}

@end
