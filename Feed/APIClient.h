//
//  APIClient.h
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

extern NSString * const InstagramRedirectScheme;
extern NSString * const InstagramRedirectHost;
extern NSString * const APIClientErrorDomain;

typedef NS_ENUM(NSInteger, APIClientErrorCode)
{
    APIClientErrorCodeNotAnError,
    APIClientErrorCodeServerError,
    APIClientErrorCodeInvalidContentType
};

@interface APIClient : NSObject

+ (NSURL *)generateURLForAuthentication;

- (instancetype) initWithAccessToken:(NSString *)accessToken;
- (void)downloadImageFromURL:(NSURL *)URL withSuccess:(void (^)(UIImage *))success failure:( void (^)(NSError *))failure;
- (void)requestRecentMediaWithSuccess:(void (^)(NSArray *feedEntries))success failure:(void (^)(NSError *error))failure;

@end
