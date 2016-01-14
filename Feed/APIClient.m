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
static NSString * accessToken;

NSString * const InstagramRedirectScheme = @"https";
NSString * const InstagramRedirectHost = @"feed-app.com";

NSString * const APIClientErrorDomain = @"APIClientErrorDomain";

@interface APIClient()

@property (copy, nonatomic, readonly) NSString *accessToken;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *configuration;

@end

@implementation APIClient

- (instancetype)initWithAccessToken:(NSString *)accessToken
{
    if ((self = [super init]))
    {
        _accessToken = accessToken;
    }
    
    _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:self.configuration];
    
    return self;
}

+ (NSURL *)generateURLForAuthentication
{
    NSString *fullPath = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@://%@&response_type=token&scope=public_content", BaseURL, ClientID, InstagramRedirectScheme, InstagramRedirectHost];
    return [NSURL URLWithString:fullPath];
}

- (void)requestRecentMediaWithSuccess:( void (^)(NSArray *))success failure:( void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@", self.accessToken];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:path]];
    [URLRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        if (HTTPResponse.statusCode < 200 || HTTPResponse.statusCode > 299)
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeServerError userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        if (![[HTTPResponse.allHeaderFields objectForKey:@"Content-Type"] hasPrefix:@"application/json"])
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeInvalidContentType userInfo:nil];
            failure(error);
            return;
        }
        
        NSError *JSONError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONError];
        
        //we check if dictionary is nil because it's a better indication of whether or not there is an error.
        //NSURLSession is a well behaved api in that the error will always be populated if there is an error, so we could check that, but some other apis may populate the nserror with junk data even though the dictionary has info in it
        if (dictionary == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(JSONError);
            });
            return;
        }
        
        NSArray *postDictionaries = [dictionary objectForKey:@"data"];
        NSArray *posts = [Post postsFromPostDictionaries:postDictionaries];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(posts);
        });
    }];
    
    [dataTask resume];
}

- (void)downloadImageFromURL:(NSURL *)URL withSuccess:(void (^)(UIImage *))success failure:( void (^)(NSError *))failure
{
    
    
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:URL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        if (HTTPResponse.statusCode < 200 || HTTPResponse.statusCode > 299)
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeServerError userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(downloadedImage);
        });
    }];
    
    [downloadTask resume];
}

- (NSURLSessionDataTask *)requestRecentlyTaggedMedia: (NSString *) tag withSuccess:(void (^)(NSArray *feedEntries))success failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@", tag, self.accessToken];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:fullPath]];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        if (HTTPResponse.statusCode < 200 || HTTPResponse.statusCode > 299)
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeServerError userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        if (![[HTTPResponse.allHeaderFields objectForKey:@"Content-Type"] hasPrefix:@"application/json"])
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeServerError userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSError *JSONError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONError];
        
        if (dictionary == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(JSONError);
            });
            return;
        }
        
        NSArray *postDictionaries = [dictionary objectForKey:@"data"];
        NSArray *posts = [Post postsFromPostDictionaries:postDictionaries];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(posts);
        });
    }];
    
    [dataTask resume];
    
    return dataTask;
}

- (void)requestRecentMediaWithLocationID:(NSString *)locationID success:(void (^)(NSArray *feedEntries))success failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/%@/media/recent?access_token=%@", locationID, self.accessToken];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:fullPath]];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        
        if (HTTPResponse.statusCode < 200 || HTTPResponse.statusCode > 299)
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeServerError userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        if (![[HTTPResponse.allHeaderFields objectForKey:@"Content-Type"] hasPrefix:@"application/json"])
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeServerError userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSError *JSONError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONError];
        
        if (dictionary == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(JSONError);
            });
            return;
        }
        
        NSArray *postDictionaries = [dictionary objectForKey:@"data"];
        NSArray *posts = [Post postsFromPostDictionaries:postDictionaries];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(posts);
        });


    }];
    
    [dataTask resume];
}

- (void)requestLocationIDWithLatitude:(float)latitude longitude: (float) longitude success:(void (^)(NSString *locationID))success failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/search?lat=%@&lng=%@&access_token=%@", [NSString stringWithFormat:@"%f", latitude], [NSString stringWithFormat:@"%f", longitude], self.accessToken];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:fullPath]];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        
        if (HTTPResponse.statusCode < 200 || HTTPResponse.statusCode > 299)
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeServerError userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        if (![[HTTPResponse.allHeaderFields objectForKey:@"Content-Type"] hasPrefix:@"application/json"])
        {
            NSError *error = [NSError errorWithDomain:APIClientErrorDomain code:APIClientErrorCodeServerError userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return;
        }
        
        NSError *JSONError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONError];
        
        if (data == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(JSONError);
            });
            return;
        }
        
        NSArray *postDictionaries = dictionary[@"data"];
        
        NSString *locationID = [postDictionaries firstObject][@"id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(locationID);
        });
        
    }];
    
    [dataTask resume];
}

@end
