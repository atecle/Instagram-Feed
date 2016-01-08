//
//  APIClient.h
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const InstagramRedirectScheme;
extern NSString * const InstagramRedirectHost;

@interface APIClient : NSObject

+ (NSURL *)generateURLForAuthentication;

@end
