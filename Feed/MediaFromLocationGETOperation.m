//
//  MediaFromLocationGETOperation.m
//  Feed
//
//  Created by Adam on 1/13/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "MediaFromLocationGETOperation.h"

@implementation MediaFromLocationGETOperation


- (instancetype) initWithClient:(APIClient *)client
{
    return [super initWithClient:client];
}

- (void)main
{
    [self.client requestRecentMediaWithLocationID:self.locationID success:^(NSArray *feedEntries) {
        _posts = feedEntries;
        [self didFinishExecuting];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [self didBeginExecuting];
}

- (void)setLocationID:(NSString *)locationID
{
    _locationID = locationID;
}

@end
