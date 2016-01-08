//
//  APIClient.m
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "APIClient.h"

static NSString * const ClientID = @"85fb65e4c05a4ae8b492d15d034b2ad5";
static NSString * const ClientSecret = @"f1b960d1e74e4a0aba837b27f69e9516";
static NSString * const BaseURL = @"https://api.instagram.com/oauth/authorize/";

NSString * const InstagramRedirectScheme = @"https";
NSString * const InstagramRedirectHost = @"feed-app.com";

@implementation APIClient

+ (NSURL *)generateURLForAuthentication
{

    NSString *fullPath = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@://%@&response_type=token", BaseURL, ClientID, InstagramRedirectScheme, InstagramRedirectHost];
    
    
    return [NSURL URLWithString:fullPath];
}


@end
